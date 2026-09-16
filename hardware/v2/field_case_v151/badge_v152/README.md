# IceGeiger rear badge v1.5.2 – ACE two-color print

This is the two-color replacement for the v1.5.1 rear badge. The surrounding Field Case geometry is unchanged.

## Color split

- `IceGeiger_Badge_v1.5.2_BASE.stl` – background plate, recommended **black**
- `IceGeiger_Badge_v1.5.2_LOGO_TEXT.stl` – radiation symbol + `IceDrone`, recommended **yellow / fluorescent yellow**

The badge remains **78 × 24 mm**.

## Mechanical interlock

The second color is keyed into the first color instead of only sitting on top:

- base thickness: **1.20 mm**
- artwork pocket depth: **0.40 mm**
- artwork begins at Z = **0.80 mm**
- artwork total top height: **2.10 mm**
- visible raised artwork above the black base: **0.90 mm**

At 0.20-mm layer height the keyed section spans two layers.

## Anycubic Kobra S1 + ACE Pro

Import the two STL files **together as parts of one object** and preserve their original coordinates. If Anycubic Slicer Next asks whether the files form one multi-part object, answer **Yes**.

Assign:

- BASE → black ACE slot
- LOGO_TEXT → yellow ACE slot

Do not auto-arrange the two meshes independently after import. In the slicer layer preview verify that the yellow geometry begins inside the matching recesses in the black base and then continues 0.9 mm above the base.

A pre-aligned multi-part 3MF is also provided when available in this folder/artifact bundle.

## Print settings

Suggested start:

- 0.20 mm layer height
- 3–4 walls
- 20–30% infill
- purge tower according to Anycubic Slicer Next
- print flat with the badge back on the bed

Only the badge needs to be reprinted when upgrading from v1.5.1.
