# IceGeiger V2 Hardware

Current print candidate: [`field_case_v151/`](field_case_v151/) for:

- GC-1602-NANO
- delivered HITT-Tracker V1.2
- physically measured dual-18650 Battery Shield
- two replaceable INR18650-25R cells
- microSD
- removable beta cap and silicone-cord lid seal
- reinforced drone-suspension eye
- contrasting rear badge with radiation symbol and `IceDrone`

The older `field_case_v14/`, `field_case_v12/`, `openscad/icegeiger_v2_enclosure.scad` and older STL files remain as historical geometry. **Use `field_case_v151/` for the current Battery-Shield build.**

Build current CAD locally:

```bash
./scripts/build-field-case-v151.sh
./scripts/render-field-case-v151.sh
```

Key v1.5.1 physical measurements / print-test corrections:

- Battery Shield: **100.2 × 48.0 mm**
- longitudinal mounting-hole centers: **97.0 mm**
- support rails: **90.0 mm** long
- approximately **5.1 mm** free PCB length at each end
- four 10 × 10 mm insert lands for the real Shield holes
- two 10 × 10 mm divider passages
- 11 mm Shield-side cable feed-through

GC-specific hole spacing is still intentionally not hard-coded; v1.5.1 uses broad drillable mounting pads so the real GC board can be used as the drilling template.

## Rear badge v1.5.2 for Kobra S1 + ACE Pro

The enclosure itself remains v1.5.1. The rear badge has a newer two-color ACE variant under [`field_case_v151/badge_v152/`](field_case_v151/badge_v152/).

Build it locally with:

```bash
./scripts/build-badge-v152.sh
./scripts/render-badge-v152.sh
```

The generated two meshes share the same coordinate system:

- `IceGeiger_Badge_v1.5.2_BASE.stl` – recommended black
- `IceGeiger_Badge_v1.5.2_LOGO_TEXT.stl` – recommended yellow / fluorescent yellow

The artwork is keyed 0.40 mm into the background plate and remains 0.90 mm visibly raised above it.
