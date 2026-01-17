#!/usr/bin/env python3
"""
DW4 ROM structure analyzer - find correct offsets for data tables.
"""

import struct
from pathlib import Path

DW4_ROM_PATH = Path("C:\\Users\\me\\source\\repos\\dragon-warrior-4-info\\roms\\Dragon Warrior IV (1992-10)(Enix)(US).nes")

def analyze_dw4_rom():
    """Analyze DW4 ROM structure."""
    with open(DW4_ROM_PATH, "rb") as f:
        rom = f.read()
    
    print(f"ROM Size: {len(rom)} bytes")
    print(f"iNES Header: {rom[0:16].hex()}")
    
    # Parse iNES header
    if rom[0:4] == b'NES\x1a':
        prg_size = rom[4] * 0x4000  # 16 KB banks
        chr_size = rom[5] * 0x2000  # 8 KB banks
        flags6 = rom[6]
        flags7 = rom[7]
        print(f"\niNES Header:")
        print(f"  PRG ROM: {prg_size} bytes ({rom[4]} x 16KB banks)")
        print(f"  CHR ROM: {chr_size} bytes ({rom[5]} x 8KB banks)")
        print(f"  Flags 6: {hex(flags6)} (mirror: {flags6 & 0x03}, mapper_lo: {(flags6 >> 4) & 0x0f})")
        print(f"  Flags 7: {hex(flags7)} (mapper_hi: {(flags7 >> 4) & 0x0f})")
        
        data_start = 16  # After iNES header
        
        # Try to find monster table markers (pattern: HP values typical for game)
        print(f"\nSearching for data patterns...")
        
        # Common DW4 monsters should have reasonable HP (10-300 range)
        # Look for clusters of low-byte HP values followed by structure
        sample_region = rom[0x1A000:0x1C000]  # Around expected offset
        
        print(f"\nSample from 0x1A000-0x1C000:")
        for i in range(0, 256, 16):
            hp_low = sample_region[i] if i < len(sample_region) else 0
            hp_high = sample_region[i+1] if i+1 < len(sample_region) else 0
            combined = hp_low | (hp_high << 8)
            
            if 5 < hp_low < 250 or (hp_low < 256 and hp_high < 10):
                atk = sample_region[i+2] if i+2 < len(sample_region) else 0
                def_ = sample_region[i+3] if i+3 < len(sample_region) else 0
                print(f"  Offset 0x{0x1A000+i:06X}: HP={hp_low:3d} HI={hp_high:3d} "
                      f"(16-bit={combined:5d}) ATK={atk:3d} DEF={def_:3d}")

if __name__ == "__main__":
    analyze_dw4_rom()
