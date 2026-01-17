#!/usr/bin/env python3
"""Convert DW4 characters JSON to .pasm format."""

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
dw4_chars_path = Path("C:/Users/me/source/repos/dragon-warrior-4-info/assets/json/characters.json")
output_pasm = Path("src/data/characters_dw4.pasm")

# Load characters JSON
with open(dw4_chars_path) as f:
	data = json.load(f)

party_members = data.get("party_members", [])
extra_companions = data.get("extra_companions", [])

all_chars = party_members + extra_companions
print(f"Converting DW4 characters JSON to .pasm...")
print(f"Loaded {len(party_members)} party members + {len(extra_companions)} companions = {len(all_chars)} total")

# Generate .pasm
pasm_lines = [
	"; Characters: {} total (party + companions) from DW4".format(len(all_chars)),
	"CHARACTER_COUNT = ${:02x}".format(len(all_chars)),
	"",
	"CHARACTER_TABLE:",
]

for char in all_chars:
	char_id = safe_int(char.get("id"), 0)
	name = char.get("name", f"char_{char_id:02x}")
	chapter = safe_int(char.get("playable_chapter", char.get("chapter", 0)), 0)
	char_class = char.get("class", "Unknown")
	
	label = f"char_{char_id:02x}"
	pasm_lines.append(f"{label}: .byte ${char_id:02x}, ${chapter:02x} ; {name}")

pasm_lines.append("")

# Write .pasm file
output_pasm.parent.mkdir(parents=True, exist_ok=True)
with open(output_pasm, 'w') as f:
	f.write('\n'.join(pasm_lines))

print(f"Wrote {output_pasm}")
