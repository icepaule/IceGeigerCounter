# IceGeiger Field Case v1.5.1

Aktueller Print-Candidate für den mobilen IceGeiger-Aufbau.

## Änderungen gegenüber v1.4/v1.5

- reales Dual-18650 Battery Shield: **100,2 × 48,0 mm**
- gemessener Lochmittenabstand des Shields in Längsrichtung: **97,0 mm**
- Auflageschienen nach realem Testdruck auf **90,0 mm** gekürzt; dadurch bleiben etwa **5,1 mm** pro Platinenende frei
- vier separate **10 × 10 mm** Auflageflächen für M3-Gewindeeinsätze an den 97-mm-Lochachsen; Y-Position bewusst tolerant, damit das reale Shield als Bohr-/Insert-Schablone dient
- zwei **10 × 10 mm** Kabelöffnungen durch die Zwischenwand
- **11-mm** Kabel-/Stromdurchführung beim Battery Shield
- verstärkte Aufhängeöse mit **12-mm** Öffnung für dickes Seil / Drone-Sling
- separates `REAR_BADGE` für eine Kontrastfarbe mit Radioaktivsymbol und `IceDrone`
- umlaufende 2-mm-Silikon-Rundschnurdichtung, Beta-Fenster mit Schutzkappe und beide Displays bleiben erhalten

## OpenSCAD

`IceGeiger_FieldCase_v1.5.1_COMPLETE.scad` enthält das gesamte Modell. Für jedes Druckteil gibt es zusätzlich eine eigene OpenSCAD-Wrapperdatei:

- `IceGeiger_FieldCase_v1.5.1_BASE.scad`
- `IceGeiger_FieldCase_v1.5.1_LID.scad`
- `IceGeiger_FieldCase_v1.5.1_SERVICE_BRIDGE.scad`
- `IceGeiger_FieldCase_v1.5.1_BETA_CAP.scad`
- `IceGeiger_FieldCase_v1.5.1_REAR_BADGE.scad`
- `IceGeiger_FieldCase_v1.5.1_GASKET_JIG.scad`

Die Wrapper erwarten die COMPLETE-Datei im selben Ordner. Das verhindert sechs voneinander abweichende Kopien des Master-CADs.

## Erzeugte Artefakte

GitHub Actions erzeugt und committed nach Änderungen automatisch:

- einzelne STL-Dateien unter `stl/`
- PNG-Vorschau jedes Druckteils
- Komplettansicht
- internes Layout
- Explosionsansicht
- beschriftete Explosionsansicht mit Dateinamen

## Validierte Abstände

`check_fit.py` prüft u. a.:

- Shield-Lochmitten 97 mm
- Schienenlänge 90 mm
- ca. 5,1 mm Endfreiheit pro Shield-Seite
- mindestens 1,2 mm Luft unter dem 5-mm-Unterseitenbauteil
- ca. 4,1 mm Zellen → Service Bridge
- ca. 5,0 mm Zellen → Tracker-Pinspitzen
- ca. 9,4 mm Tracker → Deckelebene

## Druck

Empfohlener Startwert für den Kobra S1:

- PETG oder ASA für Base/Lid/Bridge/Beta-Cap
- 0,20 mm Layer
- 4 Wände
- 25–35 % Infill
- `REAR_BADGE` separat in einer Kontrastfarbe drucken

Die Drone-Öse ist ein FDM-Bauteil. Vor Flugtests mit Mehrfachlast prüfen und bei den ersten Tests ein unabhängiges Sicherungsseil verwenden.

## Elektrischer Hinweis zum Battery Shield

Die 11-mm-Durchführung ist mechanisch vorgesehen. Solange die konkrete Clone-Schaltung nicht elektrisch vermessen ist, externe 5 V **nicht** blind auf die mit `5V` beschrifteten Ausgangspads einspeisen. Für den ersten Aufbau den vorgesehenen USB-C-/Micro-USB-Ladeeingang des Shields verwenden und Lade-/Ausgangsverhalten mit dem Multimeter prüfen.
