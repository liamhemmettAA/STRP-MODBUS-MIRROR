using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Threading;
using System.Threading.Tasks;
using FluentModbus;
using System.Net;

namespace CS_GESRTP
{
    public sealed record RegisterSyncMapping(string PlcArea, int PlcStart, int ModbusStart, int Count, bool SwapBytes = false);

    internal sealed class SyncArea
    {
        public RegisterSyncMapping Map { get; }
        public ushort[] LastPlc { get; }
        public ushort[] LastMb { get; }
        public SyncArea(RegisterSyncMapping map)
        {
            Map = map;
            LastPlc = new ushort[map.Count];
            LastMb = new ushort[map.Count];
        }
    }

    // -------------------------------------------------- RegisterSynchronizer ---
    internal sealed class RegisterSynchronizer : IAsyncDisposable
    {
        private readonly PlcClient _plc;
        private readonly ModbusTcpClient _mb;
        private readonly byte _slaveId;
        private readonly string _plcId;
        private readonly List<SyncArea> _areas;
        public RegisterSynchronizer(PlcClient plc, ModbusTcpClient mb, byte slaveId, IEnumerable<RegisterSyncMapping> maps, string plcId)
        {
            _plc = plc; _mb = mb; _slaveId = slaveId; _plcId = plcId; _areas = maps.Select(m => new SyncArea(m)).ToList();
        }
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        private static ushort Swap(ushort v) => (ushort)((v << 8) | (v >> 8));
        private const int MaxMb = 120;   // stay safely under 125‑word limit

        private ushort[] ReadHoldingBlock(int mbStart, int words)
        {
            var buffer = new ushort[words];
            int off = 0;
            while (off < words)
            {
                int slice = Math.Min(MaxMb, words - off);
                var part = _mb.ReadHoldingRegisters<ushort>(
                               _slaveId, (ushort)(mbStart + off), (ushort)slice);
                part.CopyTo(buffer.AsSpan(off));
                off += slice;
            }
            return buffer;
        }

        public async Task InitialiseAsync()
        {

            foreach (var a in _areas)
            {
                var plc = await _plc.ReadRegistersAsync(a.Map.PlcStart, (ushort)a.Map.Count, a.Map.PlcArea);
                var mb = ReadHoldingBlock(a.Map.ModbusStart, a.Map.Count);
                bool swap = a.Map.SwapBytes;
                for (int i = 0; i < a.Map.Count; i++)
                {
                    ushort plcWord = plc[i];
                    ushort mbWord = swap ? Swap(mb[i]) : mb[i];
                    if (plcWord == mbWord) continue;
                    ushort toMb = swap ? Swap(plcWord) : plcWord;
                    _mb.WriteSingleRegister(_slaveId, (ushort)(a.Map.ModbusStart + i), (short)toMb);
                    mb[i] = toMb;
                }
                a.LastPlc.CopyFrom(plc);
                a.LastMb.CopyFrom(mb);
            }
        }

        public async Task RunAsync(TimeSpan interval, CancellationToken ct)
        {
            while (!ct.IsCancellationRequested)
            {
                var t0 = DateTime.UtcNow;
                foreach (var a in _areas)
                {
                    var plcTask = _plc.ReadRegistersAsync(a.Map.PlcStart, (ushort)a.Map.Count, a.Map.PlcArea);
                    var mbTask = Task.Run(() => ReadHoldingBlock(a.Map.ModbusStart, a.Map.Count));
                    await Task.WhenAll(plcTask, mbTask);
                    var plc = plcTask.Result;
                    var mb = mbTask.Result;
                    bool swap = a.Map.SwapBytes;

                    for (int i = 0; i < a.Map.Count; i++)
                    {
                        ushort p = plc[i];
                        ushort m = mb[i];
                        if (swap ? p == Swap(m) : p == m) continue;
                        bool pChange = p != a.LastPlc[i];
                        bool mChange = m != a.LastMb[i];
                        if (pChange && !mChange)
                        {
                            ushort toMb = swap ? Swap(p) : p;
                            _mb.WriteSingleRegister(_slaveId, (ushort)(a.Map.ModbusStart + i), (short)toMb);
                            mb[i] = toMb;
                        }
                        else if (mChange && !pChange)
                        {
                            ushort toPlc = swap ? Swap(m) : m;
                            await _plc.WriteRegistersAsync(a.Map.PlcStart + i, new[] { toPlc }, a.Map.PlcArea);
                            plc[i] = toPlc;
                        }
                        else if (pChange && mChange) // conflict → PLC wins
                        {
                            ushort toMb = swap ? Swap(p) : p;
                            _mb.WriteSingleRegister(_slaveId, (ushort)(a.Map.ModbusStart + i), (short)toMb);
                            mb[i] = toMb;
                        }
                    }
                    a.LastPlc.CopyFrom(plc);
                    a.LastMb.CopyFrom(mb);
                }
                var delay = interval - (DateTime.UtcNow - t0);
                if (delay > TimeSpan.Zero) await Task.Delay(delay, ct);
            }
        }
        public async ValueTask DisposeAsync() { await _plc.DisconnectAsync(); _mb.Disconnect(); }
    }
    internal static class ArrayExtensions
    {
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static void CopyFrom(this ushort[] destination, ushort[]? source)
        {
            if (source == null) return;
            Array.Copy(source, destination, Math.Min(destination.Length, source.Length));
        }
    }

    internal class Program
    {
        private const string ModbusIp = "192.168.30.181";   // shared slave
        private const byte SlaveId = 1;                  // Unit‑ID / slave‑ID
        private const int ModbusPort = 502;               // default

        public static async Task Main()
        {
            Console.WriteLine("⚡️  Starting SRTP ⇆ Modbus synchroniser\n");

            // 1. Parse config -------------------------------------------------
            var (pollInterval, plcConfigs) = ConfigLoader.Load("config.json");
            Console.WriteLine($"🗂️  Loaded {plcConfigs.Count} PLC block(s) – polling every {pollInterval.TotalMilliseconds} ms\n");

            // // 2. Create one Modbus‑TCP client (shared by all PLC tasks) ------
            // using var mb = new ModbusTcpClient();
            // var endpoint = new IPEndPoint(IPAddress.Parse(ModbusIp), ModbusPort);
            // mb.Connect(endpoint);
            // Console.WriteLine($"✅  Modbus connected ({ModbusIp}:{ModbusPort})\n");

            // 3. Cancellation via Ctrl‑C -------------------------------------
            using var cts = new CancellationTokenSource();
            var shutdownRequested = false;
            Console.CancelKeyPress += (_, e) =>
            {
                if (!shutdownRequested)
                {
                    // FIRST Ctrl‑C → cooperative shutdown
                    shutdownRequested = true;
                    e.Cancel = true;             // keep the CLR alive
                    cts.Cancel();                 // signal all tasks
                    Console.WriteLine("\n→ Ctrl‑C detected – shutting down …");
                }
                else
                {
                    // SECOND Ctrl‑C → hard kill
                    e.Cancel = false;            // let runtime terminate
                    Console.WriteLine("\n→ Ctrl‑C again – terminating now.");
                }
            };

            // 4. Launch one synchroniser per PLC -----------------------------
            var tasks = plcConfigs.Select(p => RunForPlcAsync(p, pollInterval, cts.Token))
                        .ToArray();

            try
            {
                await Task.WhenAll(tasks);
            }
            catch (OperationCanceledException) { /* expected on Ctrl‑C */ }

            Console.WriteLine("\n👋  Stopped");
        }

        private static async Task RunForPlcAsync(
            ConfigLoader.PlcConfig p,
            TimeSpan poll,
            CancellationToken ct)
        {
            Console.WriteLine($"🔌  PLC {p.Ip}:{p.Port} – connecting …");
            var plcId = $"{p.Ip}:{p.Port}";
            using var plc = new PlcClient(p.Ip, p.Port);
            if (!await plc.ConnectAsync())
            {
                Console.WriteLine($"❌  PLC {p.Ip}:{p.Port} connect failed");
                return;
            }
            Console.WriteLine($"✅  PLC {p.Ip}:{p.Port} connected");

            // log mappings
            foreach (var m in p.Maps)
                Console.WriteLine($"   ↔  {p.Ip}:{p.Port} PLC[{m.PlcArea}{m.PlcStart}] ⇆ MB[{m.ModbusStart}] Count={m.Count} Swap={m.SwapBytes}");

            using var mb = new ModbusTcpClient();
            mb.Connect(new IPEndPoint(IPAddress.Parse(ModbusIp), ModbusPort));

            await using var sync = new RegisterSynchronizer(plc, mb, SlaveId, p.Maps, plcId);

            // ① first‑run reconciliation then ② periodic loop
            await sync.InitialiseAsync();
            await sync.RunAsync(poll, ct);

            // normal exit (cancellation) drops to here and disposers clean up
        }
    }
}
