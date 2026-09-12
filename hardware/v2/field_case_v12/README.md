# IceGeiger V2 Field Case – HITT Tracker V1.2

This is the **current compact field enclosure** for IceGeiger V2. It is a clean-room parametric design; the uploaded Printables `GC-1602-NANO_CAJOE_1.1.stl` was used only as an external-envelope plausibility reference and is **not redistributed or imported**.

## Hardware basis

- GC-1602-NANO: **108 × 65 × 47 mm seller envelope** (exact PCB holes/tube centre pending delivery)
- GM tube: preliminary **90 × 10 mm J305-like envelope** from seller specification
- delivered HITT-Tracker V1.2: **65.84 × 28.00 × 14.71 mm**, SX1262 + UC6580
- 2× Samsung INR18650-25R, replaceable, 1S2P
- parallel 2×18650 holder envelope: 76 × 40.5 × 20 mm
- Pololu S13V10F5 5 V regulator
- Joy-IT COM-MSD microSD module, mounted vertically
- 1S BMS
- U.FL/IPEX → sealed SMA bulkhead

## Parts

- `icegeiger_field_case_v12.scad` – complete self-contained source, no external libraries
- `stl/icegeiger_field_case_v12_base_PRELIMINARY.stl`
- `stl/icegeiger_field_case_v12_lid_PRELIMINARY.stl`
- `stl/icegeiger_field_case_v12_tracker_shelf_PRELIMINARY.stl`
- `stl/icegeiger_field_case_v12_beta_cap_PRELIMINARY.stl`
- `stl/icegeiger_field_case_v12_gasket_jig_TEST.stl`
- `stl/icegeiger_field_case_v12_fit_jig_TEST.stl`
- `check_fit.py` – conservative envelope collision test

## Important layout choices

The two 18650 cells are on the service side. The tracker is carried above part of the service bay on an open-centre shelf so its already-soldered header pins hang into free space. It is rotated so the UC6580 GNSS patch sits above a deliberately empty **22 × 24 mm no-metal column**, not directly above the steel cells.

The GC tube side faces the opposite outer wall. A large side window is sealed with thin PET/Mylar and protected by a removable rigid cap. The cap is left on for transport/splash exposure and removed for beta-sensitive measurements.

## Seal

The main joint has a 2.45 mm wide × 1.55 mm deep groove for 2 mm silicone cord (~22.5% nominal squeeze). Eight M3 clamp points surround the housing. The display apertures are intended for 1 mm polycarbonate windows bonded from inside.

This is a **splash-resistant design concept, not an IP-certified enclosure**.

## Build

```bash
./scripts/build-field-case-v12.sh
python3 hardware/v2/field_case_v12/check_fit.py
```

## PRELIMINARY status

Tracker geometry is based on the delivered hardware. The GC-1602 has not yet been physically measured. Before changing the GC-specific files from `PRELIMINARY` to `FINAL`, verify the PCB size, mounting-hole centres, assembled height, actual tube marking and tube centre position.
