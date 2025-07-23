using System;
using System.Net.Sockets;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
// ---------------------------------------------------------------------
//  Fast PlcClient (block reads)
// ---------------------------------------------------------------------

public sealed class PlcClient : IDisposable
{
    private const int HEADER = 56; // SRTP fixed header length
    private readonly string _ip; private readonly int _port; private ushort _seq;
    private TcpClient? _tcp; private NetworkStream? _ns;
    public bool IsConnected => _tcp?.Connected ?? false;
    public PlcClient(string ip, int port = 18245) { _ip = ip; _port = port; }

    public async Task<bool> ConnectAsync()
    {
        if (IsConnected) return true;
        _tcp = new TcpClient();
        try { await _tcp.ConnectAsync(_ip, _port); _ns = _tcp.GetStream(); return await Handshake(); }
        catch { Dispose(); return false; }
    }
    public async Task DisconnectAsync() { if (!IsConnected || _ns == null) return; try { await _ns.WriteAsync(new byte[HEADER]); } catch { } finally { Dispose(); } }

    // ------------------------------- FAST block read -----------------------
    public async Task<ushort[]> ReadRegistersAsync(int start, ushort words, string area)
    {
        if (!IsConnected || _ns == null)
            throw new InvalidOperationException("PLC not connected");

        // 1. Send SRTP read request ------------------------------------------------
        await _ns.WriteAsync(BuildReadReq(start, words, GetMem(area)));

        // 2. Receive & accumulate --------------------------------------------------
        int need = HEADER + words * 2;          // full data‑frame size
        var buf = new byte[need];              // accumulator
        int got = 0;

        while (true)
        {
            int n = await _ns.ReadAsync(buf, got, buf.Length - got);
            if (n == 0) throw new Exception("PLC closed");
            got += n;

            // Haven't even got a full header yet → keep reading.
            if (got < HEADER)
                continue;

            // If first byte ≠ 0x03 this is just an ACK (0x01/0x02) → discard & restart.
            if (buf[0] != 0x03)
            {
                got = 0;      // reset accumulator for the actual data frame
                continue;
            }

            // We have the start of a data frame; wait until payload arrives.
            if (got < need)
                continue;

            break;            // full frame received
        }

        // 3. Parse ---------------------------------------------------------------
        return Parse(buf, need, words);
    }


    // ------------------------------- FAST block write ----------------------
    public async Task<bool> WriteRegistersAsync(int start, ushort[] vals, string area)
    {
        if (!IsConnected || _ns == null) throw new InvalidOperationException("PLC not connected");
        byte[] cmd = BuildWriteReq(start, vals, GetMem(area));
        var payload = new byte[vals.Length * 2];
        for (int i = 0; i < vals.Length; i++) { payload[i * 2] = (byte)(vals[i] & 0xFF); payload[i * 2 + 1] = (byte)(vals[i] >> 8); }
        await _ns.WriteAsync(cmd); await _ns.WriteAsync(payload);
        var ack = new byte[64]; return await _ns.ReadAsync(ack) > 0 && ack[0] == 0x03;
    }

    // ----------------------------- helpers ---------------------------------
    private async Task<bool> Handshake()
    {
        if (_ns == null) return false;
        byte[] h1 = new byte[HEADER];
        byte[] h2 = {/* truncated for brevity (same as previous)*/
                0x08,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,
                0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0xC0,
                0x00,0x00,0x00,0x00,0x10,0x0E,0x00,0x00,0x01,0x01,0x4F,0x01,0x00,0x00,0x00,0x00,
                0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 };
        var buf = new byte[64];
        await _ns.WriteAsync(h1); if (await _ns.ReadAsync(buf) == 0 || buf[0] != 0x01) return false;
        await _ns.WriteAsync(h2); return await _ns.ReadAsync(buf) > 0 && buf[0] == 0x03;
    }

    private static byte GetMem(string a) => a.Trim().ToUpperInvariant() switch
    {
        "R" => 0x08,
        "W" => 0x09,
        "AI" => 0x0A,
        "AQ" => 0x0C,
        "Q" => 0x12,
        "G" or "GA" => 0x20,
        "GB" => 0x22,
        "GC" => 0x24,
        "GD" => 0x26,
        "GE" => 0x28,
        "M" => 0x16,
        "T" => 0x14,
        "SA" => 0x30,
        "SB" => 0x32,
        "SC" => 0x34,
        "I" => 0x10,
        "S" => 0x30,
        _ => throw new($"Unknown area %{a}")
    };

    private byte[] BuildReadReq(int start, ushort words, byte mem)
    {
        byte[] r = new byte[HEADER]; _seq++;
        r[0] = 0x02; r[2] = (byte)(_seq & 0xFF); r[9] = 0x01; r[17] = 0x01; r[30] = (byte)(_seq & 0xFF); r[31] = 0xC0;
        r[36] = 0x10; r[37] = 0x0E; r[40] = 0x01; r[41] = 0x01; r[42] = 0x04; r[43] = mem;
        ushort offs = (ushort)(start - 1);
        r[44] = (byte)(offs & 0xFF); r[45] = (byte)(offs >> 8);
        r[46] = (byte)(words & 0xFF); r[47] = (byte)(words >> 8);
        r[48] = 0x01; r[49] = 0x01; return r;
    }
    private byte[] BuildWriteReq(int start, ushort[] v, byte mem)
    {
        byte[] r = new byte[HEADER]; _seq++; ushort w = (ushort)v.Length; ushort bytes = (ushort)(w * 2);
        r[0] = 0x02; r[2] = (byte)(_seq & 0xFF); r[4] = (byte)(bytes & 0xFF); r[5] = (byte)(bytes >> 8);
        r[9] = 0x02; r[17] = 0x02; r[30] = (byte)(_seq & 0xFF); r[31] = 0x80; r[36] = 0x10; r[37] = 0x0E;
        r[40] = 0x01; r[41] = 0x01; r[42] = 0x32; r[48] = 0x01; r[49] = 0x01; r[50] = 0x07; r[51] = mem;
        ushort offs = (ushort)(start - 1);
        r[52] = (byte)(offs & 0xFF); r[53] = (byte)(offs >> 8); r[54] = (byte)(w & 0xFF); r[55] = (byte)(w >> 8);
        return r;
    }
    private static ushort[] Parse(byte[] buf, int len, int words)
    {
        const int DATA = HEADER; if (len < DATA + words * 2) throw new Exception("SRTP payload truncated");
        var res = new ushort[words];
        for (int i = 0; i < words; i++) { int l = buf[DATA + i * 2]; int h = buf[DATA + i * 2 + 1]; res[i] = (ushort)(l | (h << 8)); }
        return res;
    }
    public void Dispose() { _ns?.Dispose(); _tcp?.Dispose(); }
}

internal static class ArrayExt
{
    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public static void CopyFrom(this ushort[] d, ushort[] s) => Array.Copy(s, d, Math.Min(d.Length, s.Length));
}

