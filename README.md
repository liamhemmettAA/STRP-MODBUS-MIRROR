# SRTP‑MODBUS‑MIRROR

Bidirectional synchroniser that keeps GE/Emerson PACMachine Edition PLC registers (via **SRTP**) and a **Modbus TCP** register block in lock‑step. Multiple PLCs can be mirrored to a single Modbus slave. Conflicts are auto‑resolved (PLC wins), and optional byte‑swapping is supported per mapping.

---

## Table of Contents

1. [How it works](#how-it-works)
2. [Project layout](#project-layout)
3. [Quick start](#quick-start)
4. [Configuration (`config.json`)](#configuration-configjson)
5. [Generating ST mappings & %R variables for PME](#generating-st-mappings--r-variables-for-pme)
6. [Build & run](#build--run)
7. [Logging & shutdown](#logging--shutdown)
8. [Accessing the PLC from outside a VM (Ncat relay)](<#Accessing-the-PLC-from-outside-a-VM-(Ncat-relay)>)
9. [Troubleshooting](#troubleshooting)
10. [License](#license)

---

## How it works

- You declare one or more **RegisterSyncMapping** objects that map a PLC register range (e.g. `%R01001`) to a Modbus range (e.g. `400001`).
- On startup the program:

  1. Reads both sides and reconciles differences (first run init).
  2. Starts a periodic loop. For each mapping it reads PLC & Modbus, detects which side changed since last scan, and writes the newer value to the other side. If **both** changed, the PLC value wins.

- A per‑mapping `SwapBytes` flag lets you deal with 16‑bit endianness differences.

---

## Project layout

```
CS_GESRTP/                      # C# synchroniser
  ├─ Program.cs                 # entry point, loads config and spins workers
  ├─ RegisterSynchronizer.cs    # core mirror logic (excerpt below)
  ├─ PlcClient.cs               # SRTP client wrapper (not shown above)
  └─ ConfigLoader.cs            # config.json parser

build_pac_files.py              # Helper to autogenerate PME ST & CSV imports
IO-Mapping-Modbus-Upgrade.csv   # Your exported mapping sheet (input to script)
```

### Core class excerpt

```csharp
public sealed record RegisterSyncMapping(string PlcArea, int PlcStart, int ModbusStart, int Count, bool SwapBytes = false);

internal sealed class RegisterSynchronizer : IAsyncDisposable
{
    // ... ctor omitted
    public async Task InitialiseAsync() { /* first-run reconciliation */ }
    public async Task RunAsync(TimeSpan interval, CancellationToken ct) { /* loop */ }
}
```

---

## Quick start

```bash
# 1) Clone / copy the repo
# 2) Edit config.json to match your PLCs & Modbus ranges
# 3) (Optional) Generate PME ST & CSV files (see section below)
# 4) Build & run

dotnet build -c Release
# or directly
dotnet run -c Release
```

Ensure your `config.json` is in the working directory

---

## Configuration (`config.json`)

Minimal example (with two PLC blocks):

```json
{
  "PollMs": 100,
  "DefaultSwapBytes": true,
  "Plcs": [
    {
      "Ip": "192.168.30.244",
      "SrtpPort": 18245,
      "Links": [{ "Plc": "R01001", "Modbus": "400001", "Count": 161 }]
    },
    {
      "Ip": "192.168.30.244",
      "SrtpPort": 18246,
      "Links": [{ "Plc": "R01162", "Modbus": "400162", "Count": 540 }]
    }
  ]
}
```

### Keys

- **PollMs**: scan interval in milliseconds.
- **DefaultSwapBytes**: default `SwapBytes` if not specified per link.
- **Plcs\[]**:

  - `Ip`: PLC IP.
  - `SrtpPort`: SRTP port (18245/18246 typical for GE PACs).
  - `Links[]`: Each link is one contiguous block:

    - `Plc`: starting `%R` (or `%AI/%I/%Q/%AQ` mirrored as WORDs) **without the `%`** in code but include `%` in CSV.
    - `Modbus`: starting Modbus register (4xxxx style).
    - `Count`: number of 16‑bit registers.
    - `SwapBytes` (optional): override default for this block.

> **Tip:** Keep blocks ≤ 120 words to stay under the Modbus 125‑register limit (the code chunks automatically when reading, but writing single regs anyway).

---

## Generating ST mappings & %R variables for PME

To avoid hand‑typing hundreds of assignments, use the provided Python helper:

```bash
python createSTcode.py
```

The script expects an exported CSV with columns similar to:

- **ProjectName**, **PlcTag**, **RegisterPLC**, **Modbus Address**, **Name**, **DataType**, **Description**, **InitialValue**

It outputs, per project:

1. **`<Project>_map.st`** – Structured Text you paste into a routine. Creates assignments between your symbolic tags and the mirrored `%Rxxxx` words. BOOLs become bit‑tests/sets, others assign directly.
2. **`<Project>_Rvars.csv`** – Import file for PME (**Variables → Import…**) that creates WORD/INT/STRING vars mapped to the `%R` space the C# tool mirrors.

### Import steps in PAC Machine Edition

1. **Variables → Import…** and select `*_Rvars.csv`.
2. Paste the contents of `*_map.st` into a Structured‑Text block and ensure runs each scan when simulating.
3. Rebuild & download to PLC.

---

## Build & run

Requirements:

- .NET 6+ SDK (adjust `TargetFramework` if needed).
- Python 3.8+ if you want to use `createSTcode.py`.

Command line:

```bash
dotnet run -c Release

```

---

## Logging & shutdown

Runtime log examples:

```
⚡️  Starting SRTP ⇆ Modbus synchroniser
🗂️  Loaded 2 PLC block(s) – polling every 100 ms
🔌  PLC 192.168.30.244:18245 – connecting …
✅  PLC 192.168.30.244:18245 connected
```

- **Ctrl‑C once** → graceful cancel (finishes current scan, disposes clients).
- **Ctrl‑C twice** → immediate termination.

---

## Accessing the PLC from outside a VM (Ncat relay)

If your synchroniser runs **inside a VM** but you need a PLC (or another host) to reach the SRTP port from **outside** that VM, you can relay the port with **Ncat** (bundled with Nmap).

### 1. Install Nmap/Ncat (Windows host)

- Download & install Nmap (which includes `ncat.exe`).
- Default path is usually `C:\Program Files (x86)\Nmap\ncat.exe` (short path `C:\Progra~2\Nmap\ncat.exe`).

### 2. Start a persistent relay in PowerShell

```powershell
PS C:\> & 'C:\Progra~2\Nmap\ncat.exe' -l 18245 --keep-open --sh-exec '"C:\Progra~2\Nmap\ncat.exe" 127.1.0.2 18245'
```

**What it does:**

- `-l 18245` – listen on host port 18245 (SRTP).
- `--keep-open` – keep the listener alive for multiple connections.
- `--sh-exec "…"` – for each incoming connection, execute another `ncat` that dials the VM side (`127.1.0.2:18245` in this example).
- Replace `127.1.0.2` with the IP that the **VM can reach the PLC service on** (e.g., the VM’s host-only adapter or NAT loopback).

### 3. Open firewall & test

- Allow inbound TCP 18245 on the host firewall.
- From an external machine, connect to `<host-ip>:18245` and verify packets reach the VM app.

### 4. Make it survive reboots (optional)

- Wrap the command with **Task Scheduler**, **NSSM**, or a PowerShell service script.
- Or create a small `.ps1` wrapper and schedule it at logon.

> Need other ports (e.g., 18246)? Run another listener or duplicate the command with the new port.

## Troubleshooting

---

## License
