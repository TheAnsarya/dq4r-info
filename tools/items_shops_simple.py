#!/usr/bin/env python3
"""Convert DW4 items/shops JSON to .pasm."""

import json
from pathlib import Path
from typing import List, Dict, Any

OUTPUT_DIR = Path("c:\\Users\\me\\source\\repos\\dq4r-info\\src\\data")

def safe_int(val, base=10):
    """Safely convert to int, handling hex strings."""
    if isinstance(val, int):
        return val
    if isinstance(val, str):
        if val.startswith('0x'):
            return int(val, 16)
        try:
            return int(val, base)
        except:
            return 0
    return 0

def load_items() -> List[Dict[str, Any]]:
    """Load items from JSON."""
    path = Path("C:\\Users\\me\\source\\repos\\dragon-warrior-4-info\\assets\\json\\items.json")
    if not path.exists():
        return []
    with open(path) as f:
        data = json.load(f)
    return data if isinstance(data, list) else data.get('items', [])

def load_shops() -> Dict[str, Any]:
    """Load shops from JSON."""
    path = Path("C:\\Users\\me\\source\\repos\\dragon-warrior-4-info\\assets\\json\\shops.json")
    if not path.exists():
        return {}
    with open(path) as f:
        return json.load(f)

def items_to_pasm(items: List[Dict[str, Any]]) -> str:
    """Generate .pasm for items."""
    lines = [
        "; Items: 128 items from DW4",
        f"ITEM_COUNT = ${len(items):02X}",
        "",
        "ITEM_TABLE:",
    ]
    
    for itm in items:
        idx = safe_int(itm.get('id', 0))
        name = itm.get('name', f'Item')
        price = safe_int(itm.get('price', 0))
        
        lines.append(f"item_{idx:02X}: .word ${price:04x} ; {name}")
    
    return "\n".join(lines)

def shops_to_pasm(shops_data: Dict[str, Any]) -> str:
    """Generate .pasm for shops."""
    shops = shops_data.get('shops', [])
    lines = [
        "; Shops: DW4 shop data",
        f"SHOP_COUNT = ${len(shops):02X}",
        "",
        "SHOP_TABLE:",
    ]
    
    for shop in shops:
        idx = safe_int(shop.get('id', 0))
        shop_type = safe_int(shop.get('shop_type', 0))
        item_ids = shop.get('item_ids', [])
        items_list = ",".join(f"${safe_int(i):02X}" for i in item_ids[:8])
        
        lines.append(f"shop_{idx:02X}: .byte ${shop_type:02X} ; items: {items_list}")
    
    return "\n".join(lines)

def main():
    print("Converting DW4 items/shops JSON to .pasm...")
    
    try:
        items = load_items()
        print(f"Loaded {len(items)} items")
        if items:
            pasm = items_to_pasm(items)
            path = OUTPUT_DIR / "items_dw4.pasm"
            path.parent.mkdir(parents=True, exist_ok=True)
            with open(path, "w") as f:
                f.write(pasm)
            print(f"Wrote {path}")
        
        shops_data = load_shops()
        shops = shops_data.get('shops', [])
        print(f"Loaded {len(shops)} shops")
        if shops:
            pasm = shops_to_pasm(shops_data)
            path = OUTPUT_DIR / "shops_dw4.pasm"
            with open(path, "w") as f:
                f.write(pasm)
            print(f"Wrote {path}")
    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()
