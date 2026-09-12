# Mechanical fit report – Field Case V1.2

Generated from conservative axis-aligned envelopes. Values are design clearances, not a substitute for physical fit testing of the GC-1602 after delivery.

```text
IceGeiger Field Case V1.2 envelope check
Body: 120.0 x 120.0 x 54.0 mm + 4.2 mm lid
Service divider: y 71.0..73.2 mm

GC-1602 envelope         vs battery holder          : OK
GC-1602 envelope         vs tracker full envelope   : OK
GC-1602 envelope         vs microSD vertical        : OK
battery holder           vs tracker full envelope   : OK
battery holder           vs microSD vertical        : OK
GNSS no-metal column     vs battery holder          : OK
GNSS no-metal column     vs microSD vertical        : OK
GNSS no-metal column     vs BMS                     : OK
GNSS no-metal column     vs 5V regulator            : OK

Key clearances:
  GC top -> lid underside               :  2.70 mm
  battery top -> tracker pin tips       :  2.00 mm
  tracker top -> lid underside          :  8.19 mm
  GC right edge -> case inner wall      :  3.40 mm
  battery right edge -> case inner wall :  2.40 mm
  battery outer-Y edge -> case inner wall:  1.40 mm
  GC outer-Y edge -> divider            :  2.00 mm

PASS: no conservative envelope collisions detected.
```

## Remaining physical validation

- GC-1602 mounting-hole centres and exact PCB size
- final tube marking and centreline relative to PCB edge
- exact assembled GC height / LCD position
- real fit of the selected 2x18650 holder, BMS and microSD breakout
- beta membrane material thickness and cap gasket compression
