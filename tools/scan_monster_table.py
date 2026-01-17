#!/usr/bin/env python3
"""Find actual DW4 monster table by pattern scanning."""

import struct
from pathlib import Path

ROM_PATH = Path("C:\\Users\\me\\source\\repos\\dragon-warrior-4-info\\roms\\Dragon Warrior IV (1992-10)(Enix)(US).nes")

def scan_for_monster_table(rom: bytes) -> list:
    """Scan ROM for likely monster table starts."""
    candidates = []
    
    # Look for patterns: 4-byte LE number (could be EXP), followed by reasonable values
    # Typical first monster: low EXP, low gold, 4-50 HP
    for offset in range(len(rom) - 100):
        # Try to read as 27-byte monster record
        if offset + 27 > len(rom):
            break
        
        record = rom[offset:offset + 27]
        exp = struct.unpack_from('<H', record, 0)[0]
        gold = struct.unpack_from('<H', record, 2)[0]
        hp = struct.unpack_from('<H', record, 4)[0]
        atk = record[6]
        def_ = record[7]
        agi = record[8]
        
        # Sanity checks: reasonable game stats
        if (1 <= hp <= 300 and 0 <= atk <= 255 and 0 <= def_ <= 255 and
            0 <= agi <= 50 and 1 <= exp <= 5000 and 1 <= gold <= 5000):
            candidates.append({
                'offset': offset,
                'hp': hp, 'exp': exp, 'gold': gold,
                'atk': atk, 'def': def_, 'agi': agi
            })
    
    return candidates

def main():
    with open(ROM_PATH, "rb") as f:
        rom = f.read()
    
    print(f"Scanning {len(rom)} byte ROM for monster table...")
    candidates = scan_for_monster_table(rom)
    
    print(f"\nFound {len(candidates)} candidate offsets:")
    for c in candidates[:20]:
        bank = (c['offset'] - 0x10) // 0x4000
        bank_ofs = (c['offset'] - 0x10) % 0x4000
        cpu_addr = bank_ofs + 0x8000
        print(f"  0x{c['offset']:06X} (Bank {bank} ${cpu_addr:04X}): "
              f"HP={c['hp']:3d} ATK={c['atk']:2d} DEF={c['def']:2d} EXP={c['exp']:4d} Gold={c['gold']:4d}")
    
    # Check if any form a sequence (good sign for table start)
    if candidates:
        print(f"\nChecking first candidate for sequence...")
        start = candidates[0]['offset']
        for i in range(10):
            offset = start + (i * 27)
            if offset + 27 > len(rom):
                break
            record = rom[offset:offset + 27]
            hp = struct.unpack_from('<H', record, 4)[0]
            atk = record[6]
            print(f"  Record {i}: 0x{offset:06X} - HP={hp:3d} ATK={atk:2d}")

if __name__ == "__main__":
    main()
