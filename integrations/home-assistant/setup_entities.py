#!/usr/bin/env python3
"""Rename the IceGeiger MQTT-discovery entities to short IDs and create the dashboard.

Runs against the Home Assistant WebSocket API (needs an admin token). Usage:
  HA_URL=ws://<host>:8123/api/websocket HA_TOKEN=<long-lived token> python3 setup_entities.py
On a Supervisor host the Supervisor token works with HA_URL=ws://<supervisor-ip>/core/websocket.
No credentials are stored in this repository.
"""
import asyncio, json, os, sys
import websockets, yaml

URL = os.environ["HA_URL"]
TOKEN = os.environ["HA_TOKEN"]
PREFIX = "icegeiger_icegeiger_v2_icegeiger_"
RENAMES = {
    "sensor." + PREFIX + "cpm": ("sensor.icegeiger_cpm", "CPM (60 s)"),
    "sensor." + PREFIX + "dose_rate": ("sensor.icegeiger_usvh", "Dosisleistung"),
    "sensor." + PREFIX + "gnss_satellites": ("sensor.icegeiger_gnss_satellites", "GNSS Satelliten"),
    "sensor." + PREFIX + "gnss_hdop": ("sensor.icegeiger_gnss_hdop", "GNSS HDOP"),
    "sensor." + PREFIX + "battery_voltage": ("sensor.icegeiger_battery_mv", "Akkuspannung"),
    "device_tracker.icegeiger_icegeiger_v2_icegeiger_icegeiger_v2": ("device_tracker.icegeiger_v2", "IceGeiger Position"),
}
DASH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "dashboard.yaml")


async def main():
    async with websockets.connect(URL) as ws:
        hello = json.loads(await ws.recv())
        await ws.send(json.dumps({"type": "auth", "access_token": TOKEN}))
        auth = json.loads(await ws.recv())
        if auth.get("type") != "auth_ok":
            sys.exit(f"auth failed: {auth}")
        n = 0

        async def call(payload):
            nonlocal n
            n += 1
            await ws.send(json.dumps({"id": n, **payload}))
            while True:
                r = json.loads(await ws.recv())
                if r.get("id") == n:
                    return r

        for old, (new, name) in RENAMES.items():
            r = await call({"type": "config/entity_registry/update", "entity_id": old, "new_entity_id": new, "name": name})
            print("rename", old.split(".")[1][:38], "->", new, "ok" if r.get("success") else r.get("error"))
        existing = await call({"type": "lovelace/dashboards/list"})
        if not any(d.get("url_path") == "lovelace-icegeiger" for d in existing.get("result", [])):
            r = await call({"type": "lovelace/dashboards/create", "url_path": "lovelace-icegeiger", "title": "IceGeiger",
                            "icon": "mdi:radioactive", "show_in_sidebar": True, "require_admin": False, "mode": "storage"})
            print("dashboard create", "ok" if r.get("success") else r.get("error"))
        cfg = yaml.safe_load(open(DASH, encoding="utf-8"))
        r = await call({"type": "lovelace/config/save", "url_path": "lovelace-icegeiger", "config": cfg})
        print("dashboard save", "ok" if r.get("success") else r.get("error"))


asyncio.run(main())
