#!/usr/bin/env python
# build_pac_files.py ----------------------------------------------------
#  ➔ 1.  <Project>_map.st       (assignments only, uses Name column)
#  ➔ 2.  <Project>_Rvars.csv    (PME‑import file, creates WORD vars @ %R…)
# ----------------------------------------------------------------------
import csv, re, collections, pathlib

SRC_CSV = "IO-Mapping-Modbus-Curr.csv"       # ← your exported sheet
# logical column keys we need (lower‑case, no spaces)

GLOBAL_MAP = pathlib.Path("global_io_map.csv")   # PLC-addr,R-addr on disk

NEEDED = dict(
    proj="projectname",
    tag="plctag",
    reg="registerplc",
    name="name",
    type="datatype",            # works for “DataType” or “Data Type”
    desc="description",
    init="initialvalue",
)

# ---- PME header & template (unchanged) -------------------------------
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

def st_safe(text: str) -> str:
    text = re.sub(r"[^A-Za-z0-9_]", "_", text.strip())
    return ("X_" + text if text and text[0].isdigit() else text or "X").upper()

def esc_comment(txt: str) -> str:
    return txt.replace("*)", ")*").strip()

def st_literal(dtyp: str, val: str) -> str:
    """Return a Structured-Text literal matching dtyp (BOOL/INT/WORD/STRING)."""
    val = val.strip()

    # -------- BOOL ----------------------------------------------------
    if dtyp == "BOOL":
        return "TRUE" if val.upper() in ("1", "TRUE", "T", "YES") else "FALSE"

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
io2r = {}
if GLOBAL_MAP.exists():
    with GLOBAL_MAP.open(newline='') as f:
        rd = csv.reader(f)
        io2r = {plc.strip().upper(): r.strip().upper() for plc, r in rd if plc and r}
# ---------- read CSV with loose header matching -----------------------
projects = collections.defaultdict(lambda: {"map": [], "rvars": {}})

with open(SRC_CSV, newline='', encoding="utf-8-sig") as f:
    dial = csv.Sniffer().sniff(f.read(2048), delimiters=",;\t"); f.seek(0)
    rd = csv.DictReader(f, dialect=dial)

    # build mapping: “stripped‑lower”  header → real header text
    hmap = {re.sub(r"\s+", "", h).lower(): h for h in rd.fieldnames}

    missing = [k for k in NEEDED if NEEDED[k] not in hmap]
    if missing:
        raise SystemExit(f"❌ CSV missing columns: {', '.join(missing)}")

    for row in rd:
        typ  = row[hmap[NEEDED["type"]]].strip().upper()
        if typ not in ("BOOL", "INT", "WORD", "STRING"):        # skip REAL etc.
            continue

        proj = (row[hmap[NEEDED["proj"]]] or "DEFAULT").strip()
        plc  = row[hmap[NEEDED["tag"]]].strip()
        rloc = row[hmap[NEEDED["reg"]]].strip()
        name = row[hmap[NEEDED["name"]]].strip() or plc
        desc = esc_comment(row[hmap[NEEDED["desc"]]])
        init = row[hmap[NEEDED["init"]]].strip()   # << correct key
        if not init:
            init = "0"
        tag   = st_safe(name)           # symbolic tag name

        # >>> ADDED ––––– decide the definitive R-address -------------
        if not rloc and plc in io2r:                # (1) CSV blank
            rloc = io2r[plc]

        elif plc in io2r and rloc and rloc != io2r[plc]:
            print(f"⚠  {plc}: overriding CSV {rloc} "
                  f"with master {io2r[plc]}")
            rloc = io2r[plc]

        if plc not in io2r and rloc:
            io2r[plc] = rloc                        # (3) new mapping


        r_sym = rloc.replace("%", "")   # R01019 …

        P = projects[proj]

        # ==========  %R  →  IN / AI  =================================
        if plc.startswith(("%I", "%AI", "%R")):
            if typ == "BOOL":
                P["map"].append(f"{tag} := {r_sym} <> 0; (* {desc} *)")
            else:  
                P["map"].append(f"{tag} := {r_sym}; (* {desc} *)")

            P["rvars"][r_sym] = (r_sym, rloc, tag, typ, init)

        # ==========  OUT / AQ  →  %R  ===============================
        elif plc.startswith(("%Q", "%AQ")):
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

            P["rvars"][r_sym] = (r_sym, rloc, tag, typ, init)

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
            elif dtyp =="STRING":
                _dtyp = "STRING"
            else:
                _dtyp = "WORD" 
            row = IMPORT_TEMPLATE.copy()
            row[0] = r_sym
            row[1]  = _dtyp
            row[2] = f"mirror of {tag_sym}"
            row[12] = vinit
            row[15] = rloc                    # IOAddress
            wr.writerow(row)
    print("✔", csv_path)

    init_path = pathlib.Path(f"{proj}_init.st")
    init_block = [
        "(* AUTOGEN REGISTER PRESETS — call once on power-up *)",
          ] + [
        f"   {r_sym} := {st_literal(dtyp, vinit)}; (* {tag_sym} *)"
            for r_sym, rloc, tag_sym, dtyp, vinit
            in sorted(blk['rvars'].values())
    ]   

    init_path.write_text("\n".join(init_block), encoding="utf-8")
    print("✔", init_path)
# >>> ADDED ––––– save master mapping back to disk ----------------------
with GLOBAL_MAP.open("w", newline='') as f:
    wr = csv.writer(f)
    for plc, r in sorted(io2r.items()):
        wr.writerow([plc, r])
print("✔  master map updated →", GLOBAL_MAP)
# <<< ADDED
print("\n→ Import each *_Rvars.csv via PME ‘Variables → Import…’.")
print("→ Paste the corresponding *_map.st into your Structured‑Text routine.")
