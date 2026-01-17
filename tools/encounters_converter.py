#!/usr/bin/env python3
"""Convert DW4 encounters JSON to .pasm format."""

import json
from pathlib import Path

def safe_int(val, default=0):
	"""Safely convert value to int."""
	if val is None:
		return default
	if isinstance(val, int):
		return val
	if isinstance(val, str):
		if val.startswith('0x'):
			try:
				return int(val, 16)
			except ValueError:
				return default
		try:
			return int(val)
		except ValueError:
			return default
	return default

# Paths
dw4_encounters_path = Path("C:/Users/me/source/repos/dragon-warrior-4-info/assets/json/encounters.json")
output_pasm = Path("src/data/encounters_dw4.pasm")

# Load encounters JSON
with open(dw4_encounters_path) as f:
	data = json.load(f)

encounter_groups = data.get("encounter_groups", [])
print(f"Converting DW4 encounters JSON to .pasm...")
print(f"Loaded {len(encounter_groups)} encounter groups")

# Generate .pasm
pasm_lines = [
	"; Encounters: {} encounter groups from DW4".format(len(encounter_groups)),
	"ENCOUNTER_COUNT = ${:04x}".format(len(encounter_groups)),
	"",
	"ENCOUNTER_TABLE:",
]

for idx, encounter in enumerate(encounter_groups):
	monster_ids = encounter.get("monster_ids", [])
	# Pad to 6 monsters per group
	while len(monster_ids) < 6:
		monster_ids.append(0)
	monster_ids = monster_ids[:6]  # Limit to 6
	
	monsters_hex = ", ".join(f"${mid:02x}" for mid in monster_ids)
	pasm_lines.append(f"encounter_{idx:04x}: .byte {monsters_hex}")

pasm_lines.append("")

# Write .pasm file
output_pasm.parent.mkdir(parents=True, exist_ok=True)
with open(output_pasm, 'w') as f:
	f.write('\n'.join(pasm_lines))

print(f"Wrote {output_pasm}")
