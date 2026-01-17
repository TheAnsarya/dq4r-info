#!/usr/bin/env python3
"""
DW4 NES to DQ4r SNES Monster Converter (using DW4Lib offsets from C# docs)
Converts Dragon Warrior IV NES monster data to DQ3r SNES format for Poppy rebuild.
"""

import struct
from pathlib import Path
from typing import List, Tuple

# From DW4Lib.DataStructures.Monster C# source:
# Bank 6 ($06), CPU address $A2A2
# PRG-ROM layout: [iNES header (16 bytes)] + [Bank 0...Bank 31]
# Each bank is 16KB ($4000)
# CPU addresses $8000-$FFFF map to current bank
# So Bank 6 file offset = 16 + (6 * 0x4000) = 0x18010
# CPU $A2A2 within bank = $A2A2 - $8000 = $2A2A
# File offset = 0x18010 + 0x2A2A = 0x1A2B2

ROM_PATH = Path("C:\\Users\\me\\source\\repos\\dragon-warrior-4-info\\roms\\Dragon Warrior IV (1992-10)(Enix)(US).nes")
MONSTER_OFFSET = 0x1A2B2
MONSTER_SIZE = 27
MONSTER_LIMIT = 200  # Safety limit

def read_word_le(data: bytes, offset: int) -> int:
    """Read little-endian 16-bit word."""
    return struct.unpack_from('<H', data, offset)[0]

class DW4Monster:
    """DW4 NES monster from 27-byte record."""
    __slots__ = ['idx', 'exp', 'gold', 'hp', 'atk', 'def_', 'agi', 'drop_id', 'drop_rate']
    
    def __init__(self, idx: int, data: bytes):
        self.idx = idx
        self.exp = read_word_le(data, 0)
        self.gold = read_word_le(data, 2)
        self.hp = read_word_le(data, 4)
        self.atk = data[6]
        self.def_ = data[7]
        self.agi = data[8]
        self.drop_id = data[19]
        self.drop_rate = data[23]
    
    def is_valid(self) -> bool:
        """Check if monster data looks reasonable."""
        # HP should be 1-999, ATK/DEF/AGI reasonable
        return 1 <= self.hp <= 999 and 0 <= self.atk <= 255 and 0 <= self.def_ <= 255

def extract_dw4_monsters() -> List[DW4Monster]:
    """Extract monsters from DW4 NES ROM."""
    if not ROM_PATH.exists():
        raise FileNotFoundError(f"ROM not found: {ROM_PATH}")
    
    with open(ROM_PATH, "rb") as f:
        rom = f.read()
    
    if MONSTER_OFFSET + MONSTER_SIZE > len(rom):
        raise ValueError(f"Monster table offset {MONSTER_OFFSET:06X} out of bounds")
    
    monsters = []
    for i in range(MONSTER_LIMIT):
        offset = MONSTER_OFFSET + (i * MONSTER_SIZE)
        if offset + MONSTER_SIZE > len(rom):
            break
        
        record = rom[offset:offset + MONSTER_SIZE]
        monster = DW4Monster(i, record)
        
        if not monster.is_valid():
            break
        
        monsters.append(monster)
    
    return monsters

def write_pasm_monsters(monsters: List[DW4Monster], output_path: Path):
    """Write monsters to Poppy-compatible .pasm file."""
    lines = [
        "; ============================================================================",
        "; DW4 Monsters - Converted to DQ3r SNES Format",
        "; ============================================================================",
        "; Generated from DW4 NES ROM via Python converter",
        "; Structure per monster:",
        ";   HP (2 bytes, little-endian)",
        ";   Experience (2 bytes, LE)",
        ";   Gold (2 bytes, LE)",
        ";   Attack (1 byte)",
        ";   Defense (1 byte)",
        ";   Agility (1 byte)",
        ";   Drop Item ID (1 byte)",
        ";   Drop Rate (1 byte)",
        "; ============================================================================",
        "",
        f"MONSTER_COUNT = ${len(monsters):03X}",
        "",
        "MONSTER_TABLE:",
    ]
    
    for m in monsters:
        lines.append("")
        lines.append(f"; Monster ${m.idx:02X}: HP={m.hp:3d} ATK={m.atk:2d} DEF={m.def_:2d} AGI={m.agi:2d}")
        lines.append(f"monster_{m.idx:02X}:")
        lines.append(f"\t.word ${m.hp:04x}")
        lines.append(f"\t.word ${m.exp:04x}")
        lines.append(f"\t.word ${m.gold:04x}")
        lines.append(f"\t.byte ${m.atk:02x}")
        lines.append(f"\t.byte ${m.def_:02x}")
        lines.append(f"\t.byte ${m.agi:02x}")
        lines.append(f"\t.byte ${m.drop_id:02x}")
        lines.append(f"\t.byte ${m.drop_rate:02x}")
    
    lines.extend(["", "MONSTER_TABLE_END:"])
    
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w") as f:
        f.write("\n".join(lines))

def main():
    print("=" * 70)
    print("DW4 NES to DQ4r SNES Monster Converter")
    print("=" * 70)
    print(f"\nROM Path: {ROM_PATH}")
    print(f"Monster Table Offset: 0x{MONSTER_OFFSET:06X}")
    
    try:
        monsters = extract_dw4_monsters()
        print(f"\nExtracted {len(monsters)} valid monsters")
        
        if monsters:
            print(f"\nFirst 5 monsters:")
            for m in monsters[:5]:
                print(f"  ${m.idx:02X}: HP={m.hp:4d} ATK={m.atk:3d} DEF={m.def_:3d} AGI={m.agi:3d} "
                      f"EXP={m.exp:5d} Gold={m.gold:5d}")
            
            if len(monsters) > 5:
                print(f"  ...")
                m = monsters[-1]
                print(f"  ${m.idx:02X}: HP={m.hp:4d} ATK={m.atk:3d} DEF={m.def_:3d} AGI={m.agi:3d} "
                      f"EXP={m.exp:5d} Gold={m.gold:5d}")
        
        output = Path("c:\\Users\\me\\source\\repos\\dq4r-info\\src\\data\\monsters_dw4.pasm")
        write_pasm_monsters(monsters, output)
        print(f"\nWrote {output}")
        
    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()
