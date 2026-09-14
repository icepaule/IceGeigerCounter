# IceGeiger V2 Hardware

Current print candidate: [`field_case_v14/`](field_case_v14/) for:

- GC-1602-NANO
- delivered HITT-Tracker V1.2
- physically measured dual-18650 Battery Shield
- two replaceable INR18650-25R cells
- microSD
- removable beta cap and silicone-cord lid seal

The older `field_case_v12/`, `openscad/icegeiger_v2_enclosure.scad` and older STL files remain as historical geometry. **Use `field_case_v14/` for the current Battery-Shield build.**

Build current CAD locally:

```bash
./scripts/build-field-case-v14.sh
./scripts/render-field-case-v14.sh
```

The Battery Shield dimensions are based on the actual measured hardware. GC-specific hole spacing is intentionally not hard-coded yet; v1.4 uses broad drillable mounting pads so the current print can be tested without inventing an unverified GC hole pattern.
