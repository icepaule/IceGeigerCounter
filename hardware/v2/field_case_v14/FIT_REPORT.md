# IceGeiger Field Case v1.4 – Fit Report

This report covers conservative component envelopes used by `icegeiger_field_case_v14.scad`.

## Inputs

| Component | Envelope / measured data |
|---|---|
| Main case | 130 × 132 × 58 mm |
| GC-1602-NANO | 108 × 65 × 47 mm seller envelope |
| HITT Tracker V1.2 | 65.84 × 28.00 × 14.71 mm |
| Tracker soldered-pin drop | 6.10 mm |
| Battery Shield | **100.2 × 48.0 mm measured** |
| Battery Shield underside component | **5.0 mm measured max protrusion** |
| INR18650-25R | Ø18.3 × 64.85 mm |
| microSD envelope | 21 × 18 × 12 mm |

## Calculated vertical clearances

- Shield PCB underside is at `z=9.0 mm`.
- deepest underside component is therefore at `z=4.0 mm`.
- case floor top is at `z=2.8 mm`.
- underside component → floor: **1.2 mm**.

The modelled 18650 cell top is **28.9 mm**.

- service bridge underside: `z=33.0 mm` → **4.1 mm** cell-to-bridge clearance.
- Tracker header pin tips: `z=33.9 mm` → **5.0 mm** cell-to-pin clearance.

Tracker top is approximately `z=48.61 mm`.

- Tracker top → lid plane (`z=58 mm`): **9.39 mm**.

microSD top is approximately `z=48.9 mm`.

- microSD → lid plane: **9.1 mm**.

GC seller envelope reaches `z=51.5 mm`.

- GC envelope → lid plane: **6.5 mm**.

## Horizontal Battery Shield fit

The 100.2 mm Shield is centred in X.

- PCB X range: 14.9 … 115.1 mm.
- inner wall X range: 2.6 … 127.4 mm.
- PCB clearance to either long inner wall: **12.3 mm**.
- 5 mm mounting rails occupy X 9.9 … 14.9 and 115.1 … 120.1 mm.
- outer rail edge to inner wall: **7.3 mm**.

The Shield Y range is 78.0 … 126.0 mm, leaving about **3.4 mm** to the rear inner wall.

## Service bridge

The bridge support posts are outside the Battery Shield footprint in X, so the post columns do not pass through the Shield PCB.

The bridge contains:
- open slots for both soldered HITT pin rows,
- an open area below the GNSS patch antenna,
- a separate microSD tray on the left.

## Beta window

The front measurement wall has a ~96 × 18 mm opening plus a recessed membrane seat and removable printed cap. Use thin PET/Mylar for beta-sensitive operation.

## Status

**CAD static fit: PASS for the measured Battery Shield and delivered Tracker envelopes.**

Still physically unverified:
- exact GC-1602 PCB dimensions/height,
- exact GC mounting-hole pattern,
- real Shield mounting-hole pattern,
- closed-case GNSS/LoRa RF performance,
- gasket compression on the selected printer/material.

For this reason v1.4 is a **print candidate**, not an IP-certified or fully hardware-validated production enclosure.
