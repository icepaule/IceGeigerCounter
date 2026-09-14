# IceGeiger V2 Field Case v1.4 – integrated dual-18650 Battery Shield

This is the current **print-candidate** enclosure for IceGeiger V2.

It integrates:

- GC-1602-NANO measurement section
- delivered HITT/Heltec Wireless Tracker V1.2 (`SX1262` + `UC6580`)
- the physically measured dual-18650 Battery Shield
- two replaceable Samsung INR18650-25R cells
- microSD module
- U.FL/IPEX → SMA LoRa bulkhead
- two visible displays
- removable beta-window protection cap
- 2 mm silicone-cord lid seal

The design is standalone OpenSCAD and uses no external libraries.

## Measured Battery Shield input

Actual module measured from the user's hardware:

- PCB / holder: **100.2 × 48.0 mm**
- underside component protrusion: **5.0 mm**
- requested solid mounting material at both short PCB edges: **5 × 5 mm rail**
- two 18650 cells remain replaceable

The rails are deliberately not pre-drilled. Place the real Shield on the rails, use its real mounting holes as a drill guide, then drill the rail/pad locally. This avoids encoding uncertain clone hole spacing.

The module visually and dimensionally matches the common DFR0969/OKY3604-2 style dual-cell power-bank shield family with HOLD/NORMAL mode, 5 V output and charge/protection electronics. **The exact electrical revision of this clone is not assumed from appearance alone. Bench-test its outputs and protection behaviour before relying on it.**

## Current enclosure dimensions

- CAD case body: **130 × 132 × 58 mm**
- lid: **4.2 mm**
- maximum STL envelope including external lid screw lugs: about **140.4 × 142.4 mm**
- service bridge: **119 × 31 mm**
- beta cap: about **104 × 26 mm**

## Calculated clearances

- Battery Shield underside component → case floor: **1.2 mm**
- 18650 top → service bridge: about **4.1 mm**
- 18650 top → HITT header pin tips: about **5.0 mm**
- HITT top → lid plane: about **9.4 mm**
- microSD top → lid plane: about **9.1 mm**
- GC seller-envelope top → lid plane: about **6.5 mm**
- Battery Shield PCB → long inner side walls: about **12.3 mm**
- outer edge of the 5 mm Shield rails → long inner side walls: about **7.3 mm**

See `FIT_REPORT.md` and `check_fit.py`.

## Printable parts

The GitHub Action generates:

- `stl/icegeiger_field_case_v14_base.stl`
- `stl/icegeiger_field_case_v14_lid.stl`
- `stl/icegeiger_field_case_v14_service_bridge.stl`
- `stl/icegeiger_field_case_v14_beta_cap.stl`
- `stl/icegeiger_field_case_v14_gasket_jig.stl`

The service bridge is removable. It carries the HITT Tracker and microSD above the Battery Shield. Long slots leave space for the Tracker's already-soldered pin rows, and the GNSS area is open below the patch antenna.

## Print recommendation

- PETG or ASA
- 0.20 mm layer
- 4 walls/perimeters
- 25–35% infill
- base and lid flat on their outer faces
- print the gasket jig first

The design targets splash resistance but has **no certified IP rating**.

## GC-1602 mounting strategy

The seller envelope remains **108 × 65 × 47 mm** until the delivered GC board is measured with calipers. To keep the print usable despite unknown hole spacing, v1.4 uses broad solid GC corner pads rather than pre-drilled standoffs. Dry-fit the actual GC board and drill through its real mounting holes.

This makes v1.4 printable now without inventing an unverified GC hole pattern.
