using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Json;

namespace CS_GESRTP
{
    /// <summary>Reads config.json → (poll‑interval, PLC‑configs)</summary>
    internal static class ConfigLoader
    {
        // Returned object  (Ip, Port, Maps) ---------------------------------
        public sealed record PlcConfig(string Ip, int Port, IReadOnlyList<RegisterSyncMapping> Maps);

        public static (TimeSpan Poll, IReadOnlyList<PlcConfig> Plcs) Load(string path)
        {
            var cfg = JsonSerializer.Deserialize<SyncConfig>(
                          File.ReadAllText(path),
                          new JsonSerializerOptions { PropertyNameCaseInsensitive = true })!;

            var plcConfigs = cfg.Plcs.Select(plc =>
            {
                // Build mapping list for this PLC block ----------------------
                var maps = plc.Links.Select(link =>
                {
                    var area = new string(link.Plc.TakeWhile(char.IsLetter).ToArray());
                    var start = int.Parse(link.Plc[area.Length..].TrimStart('0'));

                    var mbAddr = int.Parse(link.Modbus);
                    var mbStart = mbAddr >= 400001 ? mbAddr - 400001 : mbAddr;

                    bool swap = link.SwapBytes ?? cfg.DefaultSwapBytes;
                    return new RegisterSyncMapping(area, start, mbStart, link.Count, swap);
                }).ToList();

                int port = plc.SrtpPort ?? 18245;           // default GE SRTP port
                return new PlcConfig(plc.Ip, port, maps);
            }).ToList();

            return (TimeSpan.FromMilliseconds(cfg.PollMs), plcConfigs);
        }

        // DTOs that mirror the JSON -----------------------------------------
        private sealed record SyncConfig(int PollMs,
                                         bool DefaultSwapBytes,
                                         List<PlcBlock> Plcs);

        private sealed record PlcBlock(string Ip,
                                       int? SrtpPort,
                                       List<Link> Links);

        private sealed record Link(string Plc,
                                   string Modbus,
                                   int Count,
                                   bool? SwapBytes);
    }
}
