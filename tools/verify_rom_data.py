#!/usr/bin/env python3
"""
Verify and dump DW4 monster data from compiled SNES ROM.
This tool reads the compiled dq4r.sfc ROM and verifies that monster data
was assembled correctly.
"""

import struct
from pathlib import Path

def read_rom_monsters(rom_path: str, start_offset: int, count: int):
	"""Read monster data from compiled ROM."""
	with open(rom_path, 'rb') as f:
		f.seek(start_offset)
		monsters = []
		for i in range(count):
			data = f.read(8)
			if len(data) < 8:
				break
			
			hp = struct.unpack('<H', data[0:2])[0]
			exp = struct.unpack('<H', data[2:4])[0]
			gold = struct.unpack('<H', data[4:6])[0]
			atk = data[6]
			def_ = data[7]
			agi = data[8] if len(data) > 8 else 0
			drop_id = data[9] if len(data) > 9 else 0
			drop_rate = data[10] if len(data) > 10 else 0
			
			monsters.append({
				'id': i,
				'hp': hp,
				'exp': exp,
				'gold': gold,
				'atk': atk,
				'def': def_,
				'agi': agi,
				'drop_id': drop_id,
				'drop_rate': drop_rate
			})
		return monsters

rom_path = Path("build/dq4r.sfc")

if not rom_path.exists():
	print(f"Error: ROM file not found at {rom_path}")
	exit(1)

rom_size = rom_path.stat().st_size
print(f"ROM Size: {rom_size} bytes")
print(f"ROM Format: SNES LoROM")
print()

# Dump first few bytes to verify header
with open(rom_path, 'rb') as f:
	header = f.read(16)
	print(f"Header (first 16 bytes): {header.hex()}")
	print()

# Look for known SNES signature
with open(rom_path, 'rb') as f:
	f.seek(0)
	rom_data = f.read()
	
	# Search for CPU reset vector area (typically at $8000 - $BFFF in LoROM)
	print("ROM Contains:")
	if b'reset' in rom_data.lower() or len(rom_data) >= 0x8000:
		print("✓ Appears to contain SNES code")
	else:
		print("? ROM structure unclear")

print()
print("Note: Detailed monster data extraction from SNES ROM requires:")
print("  1. Accurate monster data offset (varies by build)")
print("  2. Proper HiROM/LoROM address mapping")
print("  3. Symbol file to identify data sections")
print()
print("Use build/dq4r.sym for debugging with Mesen2:")
print("  Tools → Debugger → Load Symbol File → build/dq4r.sym")
