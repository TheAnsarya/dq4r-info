#!/usr/bin/env python3
"""Convert DW4 spells JSON to .pasm format."""

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
dw4_spells_path = Path("C:/Users/me/source/repos/dragon-warrior-4-info/assets/json/spells/spells.json")
output_pasm = Path("src/data/spells_dw4.pasm")

# Load spells JSON
with open(dw4_spells_path) as f:
	data = json.load(f)

spells = data.get("spells", [])
print(f"Converting DW4 spells JSON to .pasm...")
print(f"Loaded {len(spells)} spells")

# Generate .pasm
pasm_lines = [
	"; Spells: {} spells from DW4".format(len(spells)),
	"SPELL_COUNT = ${:02x}".format(len(spells)),
	"",
	"SPELL_TABLE:",
]

for spell in spells:
	spell_id = safe_int(spell.get("id"), 0)
	mp_cost = safe_int(spell.get("mp_cost"), 0)
	effect_type = safe_int(spell.get("effect_type"), 0)
	power = safe_int(spell.get("power"), 0)
	target_type = safe_int(spell.get("target_type"), 0)
	element = safe_int(spell.get("element"), 0)
	accuracy = safe_int(spell.get("accuracy"), 0)
	flags = safe_int(spell.get("flags"), 0)
	
	# Clamp to byte range
	mp_cost = mp_cost & 0xFF
	effect_type = effect_type & 0xFF
	power = power & 0xFF
	target_type = target_type & 0xFF
	element = element & 0xFF
	accuracy = accuracy & 0xFF
	
	spell_name = spell.get("name", f"spell_{spell_id:02x}")
	
	label = f"spell_{spell_id:02x}"
	pasm_lines.append(f"{label}: .byte ${mp_cost:02x}, ${effect_type:02x}, ${power:02x}, ${target_type:02x}, ${element:02x}, ${accuracy:02x} ; {spell_name}")

pasm_lines.append("")

# Write .pasm file
output_pasm.parent.mkdir(parents=True, exist_ok=True)
with open(output_pasm, 'w') as f:
	f.write('\n'.join(pasm_lines))

print(f"Wrote {output_pasm}")
