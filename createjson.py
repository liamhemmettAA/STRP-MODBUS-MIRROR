import csv, json, pathlib, re

CSV_FILE      = "RLF.csv"          # exported from Excel
OUT_JSON_FILE = "config.generated.json"
PLC_IP        = "192.168.30.244"
SRTP_PORT     = 18245
POLL_MS       = 100
DEFAULT_SWAP  = True

# ─── helpers ────────────────────────────────────────────────────────────
def parse_reg(token: str) -> int:
    """'%R01017' → 1017 (strip %R + leading zeros)"""
    m = re.match(r"\s*%R0*(\d+)\s*$", token.upper())
    if not m:
        raise ValueError(f"Bad register token {token!r}")
    return int(m.group(1))

def parse_mb(token: str) -> int:
    m = re.match(r"\s*4?0*(\d+)\s*$", token)   # handles 400001 or 000001
    if not m:
        raise ValueError(f"Bad Modbus addr {token!r}")
    return int(token)

# ─── open CSV with dialect sniffing ─────────────────────────────────────
with open(CSV_FILE, newline='', encoding="utf‑8‑sig") as f:
    sample = f.read(2048)
    f.seek(0)
    dialect = csv.Sniffer().sniff(sample, delimiters=",;\t")
    rd = csv.reader(f, dialect)
    
    # find header row (skip blank / junk lines)
    for header in rd:
        if any("register" in h.lower() for h in header):
            break
    try:
        reg_col = header.index("Register PLC")
        mb_col  = header.index("Modbus Address")
    except ValueError:
        raise SystemExit("❌  Couldn’t find 'Register PLC' or 'Modbus Address' columns")

    rows = []
    for r in rd:
        if len(r) <= max(reg_col, mb_col):
            continue  # skip incomplete lines
        try:
            reg = parse_reg(r[reg_col])
            mb  = parse_mb(r[mb_col])
            rows.append((reg, mb))
        except ValueError:
            continue   # silently skip bad rows; comment out to debug

rows.sort()

# ─── merge contiguous ranges ────────────────────────────────────────────
links = []
i = 0
while i < len(rows):
    reg_start, mb_start = rows[i]
    cnt = 1
    while (i + cnt < len(rows) and
           rows[i + cnt][0] == reg_start + cnt and
           rows[i + cnt][1] == mb_start  + cnt):
        cnt += 1
    links.append({
        "Plc":  f"R{reg_start:05}",
        "Modbus": f"{mb_start}",
        "Count":  cnt
    })
    i += cnt

# ─── write config.json ──────────────────────────────────────────────────
json_doc = {
    "PollMs": POLL_MS,
    "DefaultSwapBytes": DEFAULT_SWAP,
    "Plcs": [
        {
            "Ip": PLC_IP,
            "SrtpPort": SRTP_PORT,
            "Links": links
        }
    ]
}
with open(OUT_JSON_FILE, "w") as f:
    json.dump(json_doc, f, indent=2)
print(f"✅  Wrote {OUT_JSON_FILE} with {len(links)} link blocks "
      f"covering {len(rows)} PLC/Modbus pairs.")
