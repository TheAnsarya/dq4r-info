#!/usr/bin/env python3
"""
Convert DW4 items and shops JSON to DQ4r SNES `.pasm` format.
"""

import json
from pathlib import Path
from typing import List, Dict, Any

DW4_ITEMS_FILE = Path("C:\\Users\\me\\source\\repos\\dragon-warrior-4-info\\assets\\json\\items.json")
DW4_SHOPS_FILE = Path("C:\\Users\\me\\source\\repos\\dragon-warrior-4-info\\assets\\json\\shops.json")
OUTPUT_DIR = Path("c:\\Users\\me\\source\\repos\\dq4r-info\\src\\data")

def load_items() -> List[Dict[str, Any]]:
    """Load items from JSON array."""
    if not DW4_ITEMS_FILE.exists():
        print(f"Warning: {DW4_ITEMS_FILE} not found")
        return []
    
    with open(DW4_ITEMS_FILE) as f:
        data = json.load(f)
    
    # Handle both array format and object with items key
    if isinstance(data, list):
        return data
    elif isinstance(data, dict) and 'items' in data:
        return data['items']
    else:
        return []

def load_shops() -> Dict[str, Any]:
    """Load shops from JSON."""
    if not DW4_SHOPS_FILE.exists():
        print(f"Warning: {DW4_SHOPS_FILE} not found")
        return {}
    
    with open(DW4_SHOPS_FILE) as f:
        return json.load(f)

def items_to_pasm(items: List[Dict[str, Any]]) -> str:
    """Generate .pasm for items."""
    lines = [
        "; ============================================================================",
        "; DW4 Items - Converted to DQ3r SNES Format",
        "; ============================================================================",
        "; Auto-generated from DW4 JSON",
        "; Each item: Price(2) Flags(1)",
        "; ============================================================================",
        "",
        f"ITEM_COUNT = ${len(items):02X}",
        "",
        "ITEM_TABLE:",
    ]
    
    for itm in items:
        id_val = itm.get('id', '0x00')
        idx = int(id_val, 0) if isinstance(id_val, str) and id_val.startswith('0x') else int(id_val)
        name = itm.get('name', f'Item {idx}')
        price = int(itm.get('price', 0))
        flags = int(itm.get('type', 0))  # type or flags
        
        lines.append("")
        lines.append(f"; Item ${idx:02X}: {name}")
        lines.append(f"item_{idx:02X}:")
        lines.append(f"\t.word ${price:04x}\t\t; Price {price}")
        lines.append(f"\t.byte ${flags:02x}\t\t; Type/Flags {flags}")
    
    lines.append("")
    lines.append("ITEM_TABLE_END:")
    
    return "\n".join(lines)

def shops_to_pasm(shops_data: Dict[str, Any]) -> str:
    """Generate .pasm for shops."""
    shops = shops_data.get('shops', [])
    shop_types = shops_data.get('shop_types', {})
    
    lines = [
        "; ============================================================================",
        "; DW4 Shops - Converted to DQ3r SNES Format",
        "; ============================================================================",
        "; Auto-generated from DW4 JSON",
        "; Each shop: Type(1) ItemCount(1) Items(variable)",
        "; ============================================================================",
        "",
        f"SHOP_COUNT = ${len(shops):02X}",
        "",
        "SHOP_TYPES:",
    ]
    
    for type_id, type_name in shop_types.items():
        lines.append(f"\t.byte ${int(type_id):02x}\t\t; {type_name}")
    
    lines.extend(["", "SHOP_TABLE:"])
    
    for shop in shops:
        idx = shop.get('id', 0)
        shop_type = shop.get('shop_type', 0)
        item_ids = shop.get('item_ids', [])
        
        lines.append("")
        lines.append(f"; Shop ${idx:02X}: Type {shop_type}")
        lines.append(f"shop_{idx:02X}:")
        lines.append(f"\t.byte ${shop_type:02x}\t\t; Shop type")
        lines.append(f"\t.byte ${len(item_ids):02x}\t\t; Item count")
        
        for item_id in item_ids[:16]:  # Limit to 16 items per shop
            lines.append(f"\t.byte ${item_id:02x}\t\t; Item {item_id}")
        
        lines.append(f"\t.byte $ff\t\t; End marker")
    
    lines.append("")
    lines.append("SHOP_TABLE_END:")
    
    return "\n".join(lines)

def main():
    print("=" * 70)
    print("DW4 Items & Shops JSON to SNES .pasm Converter")
    print("=" * 70)
    
    try:
        # Load and convert items
        items = load_items()
        print(f"\nLoaded {len(items)} items")
        
        if items:
            print(f"First 5 items:")
            for itm in items[:5]:
                id_val = itm.get('id', '0x00')
                idx = int(id_val, 0) if isinstance(id_val, str) and id_val.startswith('0x') else int(id_val)
                print(f"  ${idx:02X}: {itm.get('name')} - ${itm.get('price')}")
            
            pasm = items_to_pasm(items)
            items_path = OUTPUT_DIR / "items_dw4.pasm"
            items_path.parent.mkdir(parents=True, exist_ok=True)
            with open(items_path, "w") as f:
                f.write(pasm)
            print(f"\nWrote {items_path}")
        
        # Load and convert shops
        shops_data = load_shops()
        shops = shops_data.get('shops', [])
        print(f"\nLoaded {len(shops)} shops")
        
        if shops:
            print(f"First 3 shops:")
            for shop in shops[:3]:
                items_list = shop.get('item_ids', [])
                print(f"  Shop ${shop.get('id'):02X}: Type {shop.get('shop_type')} - "
                      f"{len(items_list)} items")
            
            pasm = shops_to_pasm(shops_data)
            shops_path = OUTPUT_DIR / "shops_dw4.pasm"
            with open(shops_path, "w") as f:
                f.write(pasm)
            print(f"\nWrote {shops_path}")
        
    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()
