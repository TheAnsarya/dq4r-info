# DW4 Data Pipeline into DQ4r

## Goal
Use DW4 (NES) assets as content for DQ4r (SNES) while the runtime engine follows DQ3r patterns.

## Steps
- Install Python deps in dragon-warrior-4-info:
  - `cd dragon-warrior-4-info`
  - `python -m venv .venv && .venv\\Scripts\\activate`
  - `pip install -r requirements.txt`
- Extract assets:
  - Set PYTHONPATH to repo root (module imports):
    - PowerShell: `$env:PYTHONPATH = (Get-Location).Path`
  - Run task or command:
    - `python tools/asset_extractor.py --rom roms/Dragon Warrior IV (1992-10)(Enix)(US).nes --output assets`
- Convert to editable formats:
  - `python tools/bin_to_editable.py --input assets/binary --output assets/json`
- Generate ASM from JSON (for NES repo):
  - `python tools/json_to_asm.py --input assets/json --output src/data`

## Integration into DQ4r
- Preferred: Write small converters (C# or Python) that map DW4 JSON to DQ3r engine WRAM structs.
- Option: Generate `.pasm` arrays in DQ4r (`src/data/*.pasm`) from DW4 JSON (names, stats tables).
- Load data at startup into WRAM and use engine modules to consume.

## Mapping Examples
- Items: ID, price, flags → table of structs; names via text tables.
- Monsters: HP, attack, defense, AI flags → battle module tables.
- Spells: Cost, effect, target rules → ability system tables.

## Next
- Implement minimal JSON-to-`.pasm` converter for items.
- Add `src/data/items.pasm` and load table into WRAM on init.
