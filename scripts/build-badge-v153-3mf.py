#!/usr/bin/env python3
from pathlib import Path
import trimesh

root = Path(__file__).resolve().parents[1]
dir_ = root / "hardware/v2/field_case_v151/badge_v153"
stl = dir_ / "stl"
out = dir_ / "3mf"
out.mkdir(parents=True, exist_ok=True)

base = trimesh.load(stl / "IceGeiger_Badge_v1.5.3_BASE.stl", force="mesh")
art = trimesh.load(stl / "IceGeiger_Badge_v1.5.3_LOGO_TEXT.stl", force="mesh")

scene = trimesh.Scene()
scene.add_geometry(base, node_name="Badge_Base_Black", geom_name="Badge_Base_Black")
scene.add_geometry(art, node_name="Logo_Text_Yellow", geom_name="Logo_Text_Yellow")

payload = scene.export(file_type="3mf")
path = out / "IceGeiger_Badge_v1.5.3_ACE_2COLOR.3mf"
path.write_bytes(payload if isinstance(payload, (bytes, bytearray)) else payload.encode())
print(path)
