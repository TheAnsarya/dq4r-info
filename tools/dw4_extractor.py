#!/usr/bin/env python3
"""
DW4 to DQ4r Data Extractor
Extract monsters, items, shops from DW4 NES ROM and convert to DQ4r SNES format.
"""

import struct
from pathlib import Path
from typing import List, Dict, Any

# DW4 NES offsets (bank-relative, after iNES header)
DW4_ROM_PATH = Path("C:\\Users\\me\\source\\repos\\dragon-warrior-4-info\\roms\\Dragon Warrior IV (1992-10)(Enix)(US).nes")
DQ3R_ROM_PATH = Path("C:\\Users\\me\\source\\repos\\GameInfo\\~roms\\SNES\\GoodSNES\\Dragon Quest III - Soshite Densetsu he... (J) [!].sfc")

# DW4 NES data offsets (from documentation)
# Bank 6, CPU $A2A2 = File offset 0x1A2B2 (includes 16-byte header)
DW4_MONSTER_OFFSET = 0x1A2B2  # File offset (includes iNES header)
DW4_MONSTER_COUNT = 195  # Approximate
DW4_MONSTER_SIZE = 27  # Bytes per monster

# DW4 Item structure offsets
DW4_ITEM_OFFSET = 0x18010  # Example: may need verification
DW4_ITEM_COUNT = 150
DW4_ITEM_SIZE = 16

class DW4Monster:
    """DW4 NES monster record (27 bytes)."""
    SIZE = 27
    
    def __init__(self, data: bytes, offset: int = 0):
        """Parse monster from 27-byte record."""
        if len(data) < offset + self.SIZE:
            raise ValueError(f"Not enough data for monster record at offset {offset}")
        
        d = data[offset:offset + self.SIZE]
        self.experience = struct.unpack_from('<H', d, 0)[0]
        self.gold = struct.unpack_from('<H', d, 2)[0]
        self.hp = struct.unpack_from('<H', d, 4)[0]
        self.attack = d[6]
        self.defense = d[7]
        self.agility = d[8]
        self.skill_data = d[9:15]  # 6 bytes
        self.behavior_data = d[15:19]  # 4 bytes
        self.item_drop_id = d[19]
        self.unknown20 = d[20]
        self.unknown21 = d[21]
        self.metal_flags = d[22]
        self.drop_rate_flags = d[23]
        self.status_vulnerability = d[24]
        self.unknown25 = d[25]
        self.unknown26 = d[26]
    
    def to_dict(self) -> Dict[str, Any]:
        """Convert to JSON-serializable dict."""
        return {
            "experience": self.experience,
            "gold": self.gold,
            "hp": self.hp,
            "attack": self.attack,
            "defense": self.defense,
            "agility": self.agility,
            "skill_data": list(self.skill_data),
            "behavior_data": list(self.behavior_data),
            "item_drop_id": self.item_drop_id,
            "drop_rate_flags": self.drop_rate_flags,
        }

class DQ3RMonster:
    """DQ3r SNES monster record format (TBD from disassembly)."""
    # Placeholder: may differ from DW4
    SIZE = 32
    
    @staticmethod
    def from_dw4(dw4: DW4Monster) -> bytes:
        """Convert DW4 monster to DQ3r SNES format."""
        # Simple direct mapping for now
        data = bytearray(DQ3RMonster.SIZE)
        struct.pack_into('<H', data, 0, dw4.hp)
        struct.pack_into('<H', data, 2, dw4.experience)
        struct.pack_into('<H', data, 4, dw4.gold)
        data[6] = dw4.attack
        data[7] = dw4.defense
        data[8] = dw4.agility
        data[9] = dw4.item_drop_id
        # Copy behavior/skill data
        data[10:16] = dw4.skill_data + dw4.behavior_data[:2]
        return bytes(data)

def extract_dw4_monsters() -> List[DW4Monster]:
    """Extract all monsters from DW4 NES ROM."""
    if not DW4_ROM_PATH.exists():
        raise FileNotFoundError(f"DW4 ROM not found: {DW4_ROM_PATH}")
    
    monsters = []
    with open(DW4_ROM_PATH, "rb") as f:
        rom = f.read()
    
    for i in range(DW4_MONSTER_COUNT):
        offset = DW4_MONSTER_OFFSET + (i * DW4_MONSTER_SIZE)
        if offset + DW4_MONSTER_SIZE > len(rom):
            break
        
        try:
            monster = DW4Monster(rom, offset)
            monsters.append(monster)
        except Exception as e:
            print(f"Warning: Failed to parse monster {i}: {e}")
            continue
    
    print(f"Extracted {len(monsters)} monsters from DW4 NES")
    return monsters

def extract_dw4_items() -> List[Dict[str, Any]]:
    """Extract items from DW4 NES ROM (stub)."""
    # Placeholder for item extraction
    items = []
    if not DW4_ROM_PATH.exists():
        print(f"Warning: DW4 ROM not found for item extraction")
        return items
    
    with open(DW4_ROM_PATH, "rb") as f:
        rom = f.read()
    
    # TODO: Find actual item table offset and format
    print(f"Item extraction: placeholder (found {len(items)} items)")
    return items

def main():
    print("=" * 70)
    print("DW4 to DQ4r Data Extractor")
    print("=" * 70)
    
    try:
        monsters = extract_dw4_monsters()
        items = extract_dw4_items()
        
        print(f"\nExtracted data:")
        print(f"  Monsters: {len(monsters)}")
        print(f"  Items: {len(items)}")
        
        # Show first monster as example
        if monsters:
            m = monsters[0]
            print(f"\nFirst monster example:")
            print(f"  HP: {m.hp}, ATK: {m.attack}, DEF: {m.defense}, AGI: {m.agility}")
            print(f"  EXP: {m.experience}, Gold: {m.gold}")
    
    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()
