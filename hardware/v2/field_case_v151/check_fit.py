#!/usr/bin/env python3
from math import isclose

case_h=58.0
floor=2.8
shield_l=100.2
shield_board_z=9.0
shield_under=5.0
shield_hole_dx=97.0
rail_len=90.0
cell_d=18.3
shield_pcb=1.6
cell_z=shield_board_z+shield_pcb+cell_d/2
cell_top=cell_z+cell_d/2
bridge_z=33.0
tracker_z=40.0
tracker_h=14.71
tracker_pin=6.10
tracker_top=tracker_z+(tracker_h-tracker_pin)
tracker_pin_tip=tracker_z-tracker_pin
sd_z=36.9
sd_h=12.0
gc_z=4.5
gc_h=47.0

checks={
    'Battery Shield hole centers = 97.0 mm': isclose(shield_hole_dx,97.0),
    'support rails = 90.0 mm': isclose(rail_len,90.0),
    'rail end clearance >= 5.0 mm': (shield_l-rail_len)/2 >= 5.0,
    'Shield underside clears floor >= 1.0 mm': shield_board_z-shield_under-floor >= 1.0,
    'cells clear service bridge >= 3.0 mm': bridge_z-cell_top >= 3.0,
    'cells clear Tracker pin tips >= 4.0 mm': tracker_pin_tip-cell_top >= 4.0,
    'Tracker clears lid plane >= 8.0 mm': case_h-tracker_top >= 8.0,
    'microSD clears lid plane >= 8.0 mm': case_h-(sd_z+sd_h) >= 8.0,
    'GC seller envelope clears lid plane >= 5.0 mm': case_h-(gc_z+gc_h) >= 5.0,
}
for name,ok in checks.items(): print(f"[{'OK' if ok else 'FAIL'}] {name}")
print(f'rail end clearance: {(shield_l-rail_len)/2:.2f} mm each end')
print(f'Shield underside clearance: {shield_board_z-shield_under-floor:.2f} mm')
print(f'cell top -> bridge: {bridge_z-cell_top:.2f} mm')
print(f'cell top -> Tracker pin tips: {tracker_pin_tip-cell_top:.2f} mm')
print(f'Tracker top -> lid: {case_h-tracker_top:.2f} mm')
raise SystemExit(0 if all(checks.values()) else 1)
