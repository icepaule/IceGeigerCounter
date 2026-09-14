# V2 – Field Case / OpenSCAD / STL

Der aktuelle Druckstand liegt unter **`hardware/v2/field_case_v14/`**.

![assembled](images/field_case_v14_assembled.png)

![internal layout](images/field_case_v14_internal_layout.png)

## Was sich gegenüber v1.2 geändert hat

Field Case v1.4 integriert das real vorhandene duale 18650 Battery Shield direkt in das Gesamtgehäuse.

- Shield real gemessen: **100,2 × 48,0 mm**
- maximaler Bauteilüberstand an der Unterseite: **5 mm**
- zwei massive **5 × 5 mm Befestigungsschienen** an den kurzen Shield-Seiten
- wechselbare INR18650-25R bleiben im Shield
- herausnehmbare **Service-Brücke** oberhalb der Akkus
- HITT-Tracker + microSD auf dieser Brücke
- offene Schlitze für die bereits verlöteten Tracker-Pinleisten
- offene Zone unter der GNSS-Patchantenne
- separater BMS/Pololu-Boost aus v1.2 entfällt mechanisch; das reale Shield wird vor Nutzung elektrisch vermessen

Die vorherige `field_case_v12/` bleibt als historischer Stand im Repository.

## Aufbau

Zwei Funktionszonen:

- **Messkammer:** GC-1602-NANO, LCD, Zählrohr und HV-Elektronik
- **Servicekammer:** duales 18650 Battery Shield, 2×18650, Service-Brücke, HITT-Tracker, microSD und LoRa-Pigtail

## Abmessungen

- CAD-Hauptkörper: **130 × 132 × 58 mm**
- Deckel: **4,2 mm**
- maximale STL-Hüllfläche inklusive Schraubbossen: ca. **140,4 × 142,4 mm**
- Service-Brücke: **119 × 31 mm**
- Beta-Schutzkappe: ca. **104 × 26 mm**

## Druckteile

GitHub Actions erzeugt aus dem eigenständigen OpenSCAD-Modell:

- `icegeiger_field_case_v14_base.stl`
- `icegeiger_field_case_v14_lid.stl`
- `icegeiger_field_case_v14_service_bridge.stl`
- `icegeiger_field_case_v14_beta_cap.stl`
- `icegeiger_field_case_v14_gasket_jig.stl`

## Battery-Shield-Befestigung

Die kurzen PCB-Enden stehen auf zwei durchgehenden 5-mm-Schienen. Sie sind absichtlich **nicht vorgebohrt**, da das reale Lochbild des Clone-Shields noch nicht mit dem Messschieber aufgenommen wurde.

Vorgehen:

1. Base drucken.
2. Shield ohne Zellen trocken auflegen.
3. Ausrichten.
4. durch die realen Shield-Bohrungen die Schienen markieren.
5. Pilotloch passend zur gewählten M3-Befestigung bohren.
6. erst danach Elektronik montieren.

So bleibt der Druck unabhängig von unzuverlässigen Online-Lochmaßen nutzbar.

## Beta-Fenster

Die Rohrseite besitzt ein etwa **96 × 18 mm** großes Fenster. Eine dünne 25–50-µm-PET/Mylar-Membran wird dauerhaft abgedichtet. Darüber sitzt eine starre abnehmbare Schutzkappe.

## Spritzwasserschutz

- 2-mm-Silikonrundschnur
- Nut 2,45 × 1,55 mm
- acht M3-Anpresspunkte
- Polycarbonatfenster von innen
- abgedichtete SMA-Bulkhead-Durchführung
- M12-Schalteröffnung
- Beta-Fenster mit Membran + Schutzkappe

Das ist eine Konstruktionsmaßnahme für Spritzwasserschutz, **keine IP-Zertifizierung**.

## Kollisionsprüfung

Siehe `hardware/v2/field_case_v14/FIT_REPORT.md`.

Wichtige berechnete Abstände:

- Shield-Unterseitenbauteil → Gehäuseboden: **1,2 mm**
- Akkuoberseite → Service-Brücke: **ca. 4,1 mm**
- Akkuoberseite → Tracker-Pinspitzen: **ca. 5,0 mm**
- Tracker → Deckelebene: **ca. 9,4 mm**
- microSD → Deckelebene: **ca. 9,1 mm**
- GC-Verkäuferhülle → Deckelebene: **ca. 6,5 mm**

## GC-1602

Für den GC wird weiterhin die Händlerhülle **108 × 65 × 47 mm** verwendet. Weil das reale Lochbild noch nicht vermessen ist, verwendet v1.4 breite massive Eckpads. Nach Ankunft/Passprobe wird durch die echten GC-Bohrungen gebohrt; dadurch hängt die Verwendbarkeit dieses Drucks nicht von geschätzten Lochabständen ab.

v1.4 ist damit der aktuelle **Print Candidate** für den laufenden physischen Passformtest.
