#!/usr/bin/env python3
"""Static envelope checks for IceGeiger Field Case v1.4."""
EPS = 1e-9

case_l, case_w, base_h = 130.0, 132.0, 58.0
wall, floor_t = 2.6, 2.8

shield_l, shield_w = 100.2, 48.0
shield_x, shield_y, shield_board_z = 14.9, 78.0, 9.0
shield_bottom_component = 5.0
shield_end_rail = 5.0
shield_rail_x = 9.9

cell_d = 18.3
cell_z = 19.75
cell_top = cell_z + cell_d / 2

bridge_z = 33.0
tracker_pcb_z = 40.0
tracker_pin_drop = 6.10
tracker_h = 14.71
tracker_top_above_pcb = tracker_h - tracker_pin_drop
tracker_top = tracker_pcb_z + tracker_top_above_pcb

microsd_z, microsd_h = 36.9, 12.0
gc_z, gc_h = 4.5, 47.0

inner_x_min, inner_x_max = wall, case_l - wall
inner_y_max = case_w - wall

tests = {
    "Shield underside component -> floor": shield_board_z - shield_bottom_component - floor_t,
    "18650 top -> service bridge": bridge_z - cell_top,
    "18650 top -> Tracker pin tips": (tracker_pcb_z - tracker_pin_drop) - cell_top,
    "Tracker top -> lid plane": base_h - tracker_top,
    "microSD top -> lid plane": base_h - (microsd_z + microsd_h),
    "GC envelope top -> lid plane": base_h - (gc_z + gc_h),
    "Shield PCB -> left inner wall": shield_x - inner_x_min,
    "Shield PCB -> right inner wall": inner_x_max - (shield_x + shield_l),
    "left 5mm rail -> inner wall": shield_rail_x - inner_x_min,
    "right 5mm rail -> inner wall": inner_x_max - (shield_x + shield_l + shield_end_rail),
    "Shield rear -> inner wall": inner_y_max - (shield_y + shield_w),
}

minimum_required = {
    "Shield underside component -> floor": 1.0,
    "18650 top -> service bridge": 3.0,
    "18650 top -> Tracker pin tips": 3.0,
    "Tracker top -> lid plane": 3.0,
    "microSD top -> lid plane": 3.0,
    "GC envelope top -> lid plane": 3.0,
    "Shield PCB -> left inner wall": 2.0,
    "Shield PCB -> right inner wall": 2.0,
    "left 5mm rail -> inner wall": 2.0,
    "right 5mm rail -> inner wall": 2.0,
    "Shield rear -> inner wall": 2.0,
}

failed = False
for name, value in tests.items():
    req = minimum_required[name]
    ok = value + EPS >= req
    print(f"{'PASS' if ok else 'FAIL'}  {name}: {value:.2f} mm (min {req:.2f})")
    failed |= not ok

raise SystemExit(1 if failed else 0)
