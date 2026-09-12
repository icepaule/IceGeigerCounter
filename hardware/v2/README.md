# IceGeiger V2 Hardware

Current enclosure: [`field_case_v12/`](field_case_v12/) for the delivered HITT-Tracker V1.2, two replaceable INR18650-25R cells and the ordered GC-1602-NANO.

The older `openscad/icegeiger_v2_enclosure.scad` and `stl/icegeiger_v2_*_PRELIMINARY.stl` remain as historical first-pass geometry. **Do not print them for the current HITT-Tracker build.**

For the current design run:

```bash
./scripts/build-field-case-v12.sh
./scripts/render-field-case-v12.sh
```

GC-specific dimensions remain PRELIMINARY until the purchased board is physically measured.
