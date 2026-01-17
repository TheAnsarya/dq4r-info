#!/usr/bin/env python3
"""
Convert DW4 JSON monsters to DQ4r SNES `.pasm` format.
Reads pre-extracted monster JSON files from dragon-warrior-4-info.
"""

import json
from pathlib import Path
from typing import List, Dict, Any

DW4_MONSTERS_DIR = Path("C:\\Users\\me\\source\\repos\\dragon-warrior-4-info\\assets\\json\\monsters")
DW4_ITEMS_DIR = Path("C:\\Users\\me\\source\\repos\\dragon-warrior-4-info\\assets\\json\\items")
OUTPUT_DIR = Path("c:\\Users\\me\\source\\repos\\dq4r-info\\src\\data")

def load_dw4_monsters() -> List[Dict[str, Any]]:
    """Load all DW4 monsters from individual JSON files."""
    monsters = []
    
    if not DW4_MONSTERS_DIR.exists():
        raise FileNotFoundError(f"DW4 monsters dir not found: {DW4_MONSTERS_DIR}")
    
    # Sort by monster ID
    files = sorted(DW4_MONSTERS_DIR.glob("monster_*.json"))
    
    for file_path in files:
        try:
            with open(file_path) as f:
                monster = json.load(f)
            monsters.append(monster)
        except Exception as e:
            print(f"Warning: Failed to load {file_path}: {e}")
    
    return monsters

def load_dw4_items() -> List[Dict[str, Any]]:
    """Load DW4 items from JSON."""
    items = []
    
    if not DW4_ITEMS_DIR.exists():
        print(f"Warning: Items dir not found: {DW4_ITEMS_DIR}")
        return items
    
    files = sorted(DW4_ITEMS_DIR.glob("item_*.json"))
    for file_path in files:
        try:
            with open(file_path) as f:
                item = json.load(f)
            items.append(item)
        except Exception as e:
            print(f"Warning: Failed to load {file_path}: {e}")
    
    return items

def monsters_to_pasm(monsters: List[Dict[str, Any]]) -> str:
    """Generate .pasm code for monsters."""
    lines = [
        "; ============================================================================",
        "; DW4 Monster Data - Converted to DQ3r SNES Format",
        "; ============================================================================",
        "; Auto-generated from DW4 JSON by json_to_pasm converter",
        "; Each monster: HP(2) EXP(2) Gold(2) ATK(1) DEF(1) AGI(1) Drop(1) Rate(1)",
        "; ============================================================================",
        "",
        f"MONSTER_COUNT = ${len(monsters):02X}",
        "",
        "MONSTER_TABLE:",
    ]
    
    for m in monsters:
        idx = m.get('id', 0)
        name = m.get('name', 'Unknown')
        hp = m.get('hp', 0)
        exp = m.get('exp', 0)
        gold = m.get('gold', 0)
        atk = m.get('attack', 0)
        def_ = m.get('defense', 0)
        agi = m.get('agility', 0)
        drop_id = m.get('drop_item_id', 0)
        drop_rate = m.get('drop_rate', 0)
        
        lines.append("")
        lines.append(f"; Monster ${idx:02X}: {name}")
        lines.append(f"monster_{idx:02X}:")
        lines.append(f"\t.word ${hp:04x}\t\t; HP {hp}")
        lines.append(f"\t.word ${exp:04x}\t\t; Experience {exp}")
        lines.append(f"\t.word ${gold:04x}\t\t; Gold {gold}")
        lines.append(f"\t.byte ${atk:02x}\t\t; Attack {atk}")
        lines.append(f"\t.byte ${def_:02x}\t\t; Defense {def_}")
        lines.append(f"\t.byte ${agi:02x}\t\t; Agility {agi}")
        lines.append(f"\t.byte ${drop_id:02x}\t\t; Drop Item")
        lines.append(f"\t.byte ${drop_rate:02x}\t\t; Drop Rate")
    
    lines.extend(["", "MONSTER_TABLE_END:"])
    
    return "\n".join(lines)

def items_to_pasm(items: List[Dict[str, Any]]) -> str:
    """Generate .pasm code for items."""
    lines = [
        "; ============================================================================",
        "; DW4 Items - Converted to DQ3r SNES Format",
        "; ============================================================================",
        "; Auto-generated from DW4 JSON",
        "; Each item: ID(1) Price(2) Flags(1)",
        "; ============================================================================",
        "",
        f"ITEM_COUNT = ${len(items):02X}",
        "",
        "ITEM_TABLE:",
    ]
    
    for itm in items:
        idx = itm.get('id', 0)
        name = itm.get('name', 'Unknown')
        price = itm.get('price', 0)
        flags = itm.get('flags', 0)
        
        lines.append("")
        lines.append(f"; Item ${idx:02X}: {name} (${price})")
        lines.append(f"item_{idx:02X}:")
        lines.append(f"\t.byte ${idx:02x}\t\t; ID")
        lines.append(f"\t.word ${price:04x}\t\t; Price")
        lines.append(f"\t.byte ${flags:02x}\t\t; Flags")
    
    lines.extend(["", "ITEM_TABLE_END:"])
    
    return "\n".join(lines)

def main():
    print("=" * 70)
    print("DW4 JSON to DQ4r SNES .pasm Converter")
    print("=" * 70)
    
    try:
        # Load and convert monsters
        monsters = load_dw4_monsters()
        print(f"\nLoaded {len(monsters)} monsters from JSON")
        
        if monsters:
            print(f"First 3 monsters:")
            for m in monsters[:3]:
                print(f"  ${m.get('id'):02X}: {m.get('name')} - "
                      f"HP={m.get('hp'):3d} ATK={m.get('attack'):2d} "
                      f"DEF={m.get('defense'):2d} AGI={m.get('agility'):2d}")
        
        # Generate and write monsters
        pasm_code = monsters_to_pasm(monsters)
        monsters_path = OUTPUT_DIR / "monsters_dw4.pasm"
        monsters_path.parent.mkdir(parents=True, exist_ok=True)
        with open(monsters_path, "w") as f:
            f.write(pasm_code)
        print(f"\nWrote {monsters_path}")
        
        # Load and convert items
        items = load_dw4_items()
        print(f"\nLoaded {len(items)} items from JSON")
        
        if items:
            print(f"First 3 items:")
            for itm in items[:3]:
                print(f"  ${itm.get('id'):02X}: {itm.get('name')} - ${itm.get('price')}")
        
        if items:
            pasm_code = items_to_pasm(items)
            items_path = OUTPUT_DIR / "items_dw4.pasm"
            with open(items_path, "w") as f:
                f.write(pasm_code)
            print(f"\nWrote {items_path}")
        
    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()
