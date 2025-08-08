#!/usr/bin/env python
# build_pac_files.py ----------------------------------------------------
#  ➔ 1.  <Project>_map.st       (assignments only, uses Name column)
#  ➔ 2.  <Project>_Rvars.csv    (PME-import file, creates WORD/INT/STRING vars @ %R…)
#  ➔ 3.  <Project>_init.st      (register initial values, call once on power-up)
#  ➔     global_maps/<Project>_global_io_map.csv  (authoritative PLC→%R map per project)
# ----------------------------------------------------------------------
import csv, re, collections, pathlib

# ---- INPUT CSV --------------------------------------------------------
SRC_CSV = "IO-Mapping-Modbus-Curr.csv"       # ← your exported sheet

# ---- LOOSE HEADER KEYS (lower-case, no spaces) ------------------------
NEEDED = dict(
    proj="projectname",
    tag="plctag",
    reg="registerplc",
    name="name",
    type="datatype",            # works for “DataType” or “Data Type”
    desc="description",
    init="initialvalue",
)

# ---- PME header & template (unchanged) --------------------------------
IMPORT_HEADER = [
    "Name","DataType","Description","DataTypeID","Retentive","Force2","DisplayFormat",
    "ArrayDimension1","ArrayDimension2","Publish","MarkAsUsed","MaxLength",
    "InitialValue","DataSource","DataSourceClsid","IOAddress","IOAddressOffset",
    "IOAddressAlias","Input_VTL","Output_VTL","DisplayName","OPCAccessLevel",
    "extra_properties"
]
IMPORT_TEMPLATE = [
    "", "WORD", "", "", "YES", "", "Decimal",
    "0","0", "External Read/Write", "NO", "16", "0",
    "Controller", "{98D70480-4881-11D4-9F26-0050DA19DE4A}",
    "", "", "", "", "", "", "Private", ""
]

# ---- helpers -----------------------------------------------------------
def st_safe(text: str) -> str:
    text = re.sub(r"[^A-Za-z0-9_]", "_", text.strip())
    return ("X_" + text if text and text[0].isdigit() else text or "X").upper()

def esc_comment(txt: str) -> str:
    return (txt or "").replace("*)", ")*").strip()

def st_literal(dtyp: str, val: str) -> str:
    """Return a Structured-Text literal matching dtyp (BOOL/INT/WORD/STRING)."""
    val = (val or "").strip()

    # -------- BOOL ----------------------------------------------------
    if dtyp == "BOOL":
        return 1 if val.upper() in ("1", "TRUE", "T", "YES") else 0

    # -------- STRING --------------------------------------------------
    if dtyp == "STRING":
        escaped = val.replace("'", "''")      # double any single quotes
        return f"\"{escaped}\""

    # -------- INT -----------------------------------------------------
    if dtyp == "INT":
        try:
            num = int(val, 0)                 # accepts 0xFF, 16#FF etc.
        except ValueError:
            num = 0
        return f"{num}"

    # -------- WORD ----------------------------------------------------
    if dtyp == "WORD":
        try:
            num = int(val, 0)
        except ValueError:
            num = 0
        return f"{num}"

    # -------- fallback ------------------------------------------------
    return val or "0"

# === PER-PROJECT MASTER MAPS ===========================================
MAP_DIR = pathlib.Path("global_maps")
MAP_DIR.mkdir(exist_ok=True)

def _proj_safe(proj: str) -> str:
    s = (proj or "DEFAULT").strip()
    return re.sub(r"[^A-Za-z0-9_.-]+", "_", s) or "DEFAULT"

def map_path_for(proj: str) -> pathlib.Path:
    return MAP_DIR / f"{_proj_safe(proj)}_global_io_map.csv"

# io2r stores per-project dicts: { proj -> { PLC_TAG(UPPER) -> R_ADDR(UPPER) } }
io2r = collections.defaultdict(dict)
_loaded = set()

def ensure_loaded(proj: str):
    """Lazy-load the project's master PLC→%R map (once)."""
    if proj in _loaded:
        return
    gpath = map_path_for(proj)
    if gpath.exists():
        with gpath.open(newline='') as f:
            rd = csv.reader(f)
            io2r[proj] = {
                (plc or "").strip().upper(): (r or "").strip().upper()
                for plc, r in rd if plc and r
            }
    _loaded.add(proj)

# === ACCUMULATORS FOR OUTPUT ===========================================
# projects = { proj -> { "map": [st lines], "rvars": { r_sym -> (r_sym, rloc, tag, typ, init) } } }
projects = collections.defaultdict(lambda: {"map": [], "rvars": {}})

# ---------- read CSV with loose header matching ------------------------
with open(SRC_CSV, newline='', encoding="utf-8-sig") as f:
    dial = csv.Sniffer().sniff(f.read(2048), delimiters=",;\t"); f.seek(0)
    rd = csv.DictReader(f, dialect=dial)

    # build mapping: “stripped-lower” header → real header text
    hmap = {re.sub(r"\s+", "", h).lower(): h for h in rd.fieldnames}

    missing = [k for k in NEEDED if NEEDED[k] not in hmap]
    if missing:
        raise SystemExit(f"❌ CSV missing columns: {', '.join(missing)}")

    for row in rd:
        typ  = (row[hmap[NEEDED["type"]]] or "").strip().upper()
        if typ not in ("BOOL", "INT", "WORD", "STRING"):        # skip REAL etc.
            continue

        proj = (row[hmap[NEEDED["proj"]]] or "DEFAULT").strip()
        ensure_loaded(proj)  # ← per-project map

        plc_raw  = (row[hmap[NEEDED["tag"]]] or "").strip()
        rloc_raw = (row[hmap[NEEDED["reg"]]] or "").strip()
        plcU = plc_raw.upper()
        rlocU = rloc_raw.upper()

        name = (row[hmap[NEEDED["name"]]] or "").strip() or plc_raw
        desc = esc_comment(row[hmap[NEEDED["desc"]]])
        init = (row[hmap[NEEDED["init"]]] or "").strip() or "0"

        tag   = st_safe(name)           # symbolic tag name

        # >>> decide the definitive R-address (per-project master first)
        if not rlocU and plcU in io2r[proj]:                # (1) CSV blank
            rlocU = io2r[proj][plcU]

        elif plcU in io2r[proj] and rlocU and rlocU != io2r[proj][plcU]:
            print(f"⚠  {plc_raw}: overriding CSV {rloc_raw} with master {io2r[proj][plcU]}")
            rlocU = io2r[proj][plcU]

        if plcU not in io2r[proj] and rlocU:
            io2r[proj][plcU] = rlocU                          # (3) new mapping learned

        # Normalize %R symbol (drop '%' for ST symbol/PME Name fields)
        r_sym = (rlocU or "").replace("%", "")   # e.g. "%R01019" → "R01019"

        P = projects[proj]

        # ==========  %I / %AI / %R  →  IN / AI  =======================
        if plcU.startswith(("%I", "%AI", "%R", "%M")):
            if not r_sym:
                # No destination register: skip but warn once per tag
                print(f"⚠  {proj}: no R-address for {plc_raw} ({tag}); row skipped")
                continue

            if typ == "BOOL":
                P["map"].append(f"{tag} := {r_sym} <> 0; (* {desc} *)")
            else:
                P["map"].append(f"{tag} := {r_sym}; (* {desc} *)")

            P["rvars"][r_sym] = (r_sym, rlocU, tag, typ, init)

        # ==========  OUT / AQ  →  %R  ================================
        elif plcU.startswith(("%Q", "%AQ")):
            if not r_sym:
                print(f"⚠  {proj}: no R-address for {plc_raw} ({tag}); row skipped")
                continue

            if typ == "BOOL":
                P["map"].extend([
                    f"IF {tag} THEN",
                    f"   {r_sym} := 1;",
                    f"ELSE",
                    f"   {r_sym} := 0;",
                    f"END_IF; (* {desc} *)"
                ])
            else:
                P["map"].append(f"{r_sym} := {tag}; (* {desc} *)")

            P["rvars"][r_sym] = (r_sym, rlocU, tag, typ, init)

        # else: unknown PLC area (skip silently)

# ---------- write outputs per project ----------------------------------
for proj, blk in projects.items():
    # 1) mapping ST file
    map_path = pathlib.Path(f"{proj}_map.st")
    map_path.write_text("(* AUTOGEN MAPPINGS *)\n" + "\n".join(blk["map"]),
                        encoding="utf-8")
    print("✔", map_path)

    # 2) import CSV for %R variables
    csv_path = pathlib.Path(f"{proj}_Rvars.csv")
    with open(csv_path, "w", newline="", encoding="utf-8") as f:
        wr = csv.writer(f)
        wr.writerow(IMPORT_HEADER)
        for r_sym, rloc, tag_sym, dtyp, vinit in sorted(blk["rvars"].values()):
            if dtyp == "INT":
                _dtyp = "INT"
            elif dtyp == "STRING":
                _dtyp = "STRING"
            else:
                _dtyp = "WORD"
            row = IMPORT_TEMPLATE.copy()
            row[0]  = r_sym           # Name
            row[1]  = _dtyp           # DataType
            row[2]  = f"mirror of {tag_sym}"  # Description
            row[12] = vinit           # InitialValue
            row[15] = rloc            # IOAddress (e.g. %R01019)
            wr.writerow(row)
    print("✔", csv_path)

    # 3) init ST block (call once on power-up)
    init_path = pathlib.Path(f"{proj}_init.st")
    init_block = [
        "(* AUTOGEN REGISTER PRESETS — call once on power-up *)",
    ] + [
        f"   {r_sym} := {st_literal(dtyp, vinit)}; (* {tag_sym} *)"
        for r_sym, rloc, tag_sym, dtyp, vinit in sorted(blk['rvars'].values())
    ]
    init_path.write_text("\n".join(init_block), encoding="utf-8")
    print("✔", init_path)

# --- SAVE per-project master maps -------------------------------------
for proj, mapping in io2r.items():
    gpath = map_path_for(proj)
    with gpath.open("w", newline='') as f:
        wr = csv.writer(f)
        for plc, r in sorted(mapping.items()):
            wr.writerow([plc, r])
    print(f"✔  master map updated → {gpath}")

print("\n→ Import each *_Rvars.csv via PME ‘Variables → Import…’.")
print("→ Paste the corresponding *_map.st into your Structured-Text routine.")
