# V2 – Validierungsstatus

## Real verifiziert

- [x] gelieferter Tracker trägt `HITT-Tracker V1.2`
- [x] SX1262 auf realer Platine ablesbar
- [x] UC6580 auf realer Platine ablesbar
- [x] Tracker-Display und Werksfirmware laufen per USB
- [x] Tracker-Hülle aus Maßzeichnung: 65,84 × 28,00 × ca. 14,71 mm
- [x] Stiftleisten sind bereits verlötet; CAD berücksichtigt 6,1-mm-Pinunterstand

## Aus Hersteller-/Projektunterlagen verifiziert

- [x] Heltec-V1.1-Familie: ESP32-S3FN8 + SX1262 + UC6580
- [x] GPIO33/34 = GNSS UART, GPIO3 HIGH schaltet GNSS-Versorgung bei V1.1
- [x] LoRa belegt GPIO8–14; TFT GPIO38–42
- [x] Joy-IT COM-MSD = 3,3-V-SPI, 18 × 21 × 12 mm
- [x] Pololu S13V10F5 = 5 V, typisch 1 A, 8,9 × 12,1 × 4,2 mm
- [x] Parallelhalter = 76 × 40,5 × 20 mm

## CAD / statisch geprüft

- [x] neuer Field-Case-SCAD ohne externe Bibliotheken
- [x] Base/Lid/Shelf/Beta-Cap + Test-Jigs lokal erzeugt
- [x] lokal erzeugte STL-Meshes watertight und jeweils eine zusammenhängende Komponente
- [x] konservative Hüllprüfung ohne Kollision
- [x] GNSS-Patch besitzt metallfreie Keepout-Säule
- [x] Beta-Fenster mit Membran + Schutzkappe vorgesehen
- [x] umlaufende 2-mm-Silikondichtung und acht M3-Anpresspunkte

## Noch offen bis GC-1602 geliefert ist

- [ ] reale PCB-Länge/Breite
- [ ] Lochabstände und Lochdurchmesser
- [ ] reale Bauhöhe / LCD-Position
- [ ] Zählrohr-Aufschrift und Rohrmittelpunkt
- [ ] realer INT-Ruhe-/Pulspegel
- [ ] CPM→µSv/h-Faktor
- [ ] physischer Fit-Jig-Test

## Danach

- [ ] FINAL-STLs erzeugen
- [ ] Batterie-/Lade-/Stromtest
- [ ] GNSS-Fix im geschlossenen Gehäuse
- [ ] LoRaWAN-Uplink / Reichweite
- [ ] Spritzwassertest ohne Elektronik, danach mit Dummy-Gewicht
