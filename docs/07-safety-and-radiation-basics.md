# Sicherheitsregeln & Strahlungsgrundlagen

Dieses Dokument fasst alle Sicherheitsregeln für Bau und Betrieb an einer Stelle zusammen und erklärt die Einheiten/Grenzwerte, die beim Umgang mit einem selbstgebauten Geigerzähler relevant sind.

## Teil A: Sicherheitsregeln

### A1. Hochspannung (GC-1602-Board bzw. Eigenbau-HV-Schaltung)

Das GC-1602-NANO-Board (CAJOE-Typ) erzeugt für die Röhre mehrere hundert Volt Gleichspannung (Anbieterangabe für J305: Anodenspannung 350–480 V, Upstream-Doku: "500 V+"). Die Energie ist gering, ein Schlag ist trotzdem schmerzhaft und kann Schreckreaktionen mit Folgeunfällen auslösen. Das gilt ebenso für die frühere Eigenbau-Schaltung ([06-hv-circuit.md](06-hv-circuit.md), nicht Teil von V2).

**Grundsatz: Erden ist hier nicht die Schutzmaßnahme.** Das Gerät ist ein potentialfreies Niederspannungsgerät (USB oder Akku). Geschützt wird durch **Trennen, Warten und Entladen**, nicht durch Erdung:

- Weder das Board noch den eigenen Körper an Schutzleiter, Heizkörper, PC-Gehäuse o. Ä. legen. Das würde einen Strompfad von den HV-Knoten durch den Körper zur Erde schaffen.
- Bei angestecktem USB liegt die Masse des Boards über den PC und dessen Netzteil meist auf Erdpotenzial. Deshalb nie am Board arbeiten, solange USB angeschlossen ist.
- Ein ESD-Armband ist nur für Niederspannungsteile im stromlosen Zustand gedacht und nur mit 1 MΩ Serienwiderstand. Nie bei Arbeiten an den HV-Knoten tragen.

**Ablauf vor jedem Berühren, Messen oder Umbauen:**

1. Alle Quellen trennen: USB (Nano, Tracker), Battery Shield und Akkus.
2. Mindestens 1 Minute warten. Die reale Entladezeit dieses Boards ist nicht gemessen.
3. Board auf isolierende Unterlage legen (Holz oder Kunststoff, keine Metallfläche).
4. Aktiv entladen mit einer Entladeprüfspitze: 1 MΩ, aufgebaut aus zwei 470-kΩ-Widerständen (0,5 W) in Reihe, weil ein einzelner 0,25-W-Widerstand oft nur für etwa 250 V spezifiziert ist, an isoliertem Griff. Ein Ende zuerst per Krokoklemme an die **Board-Masse (GND) des Geräts** klemmen, dann einhändig mit dem anderen Ende den Röhrenanschluss (Anode) und die HV-Knoten berühren. Nicht mit einem Schraubendreher kurzschließen (Funke, Bauteilschaden).
5. Nachmessen: Multimeter auf DC, Bereich mindestens 600 V, zwischen Anodenanschluss und Board-GND. Erst wenn etwa 0 V angezeigt werden, weiterarbeiten.
6. Röhre und Lötseite auch danach nur an isolierten Stellen anfassen.

**Im Betrieb:**

- Nichts an Röhrenanschlüssen, Lötseite oder HV-Bereich berühren.
- **Ein-Hand-Regel:** Wenn unter Spannung gemessen werden muss, nur eine Hand verwenden, die andere in die Tasche. Das verhindert einen Stromfluss durch den Brustkorb.
- Im Gehäuse keine berührbaren HV-Kontakte nach außen führen.

Empfohlene Messung für den Testplan: Restspannung am Röhrenanschluss nach dem Abschalten in festen Abständen (z. B. nach 5, 15, 30, 60 s) protokollieren. Damit wird die reale Entladezeit dokumentiert.

### A2. Akku (18650 Li-Ion)

- Nur Zellen mit eingebauter Schutzschaltung ("protected") verwenden.
- Auf richtige Polarität beim Einlegen achten (siehe auch die LED-Diagnose in diesem Projekt: falsch erkannter/fehlender Akku zeigt sich über die Status-LEDs des Lademoduls).
- Nicht kurzschließen, nicht mechanisch beschädigen (quetschen, durchbohren), nicht über 60°C erwärmen.
- Beim Löten in der Nähe des Akkufachs: Akku vorher entnehmen.

### A3. Elektrostatische Entladung (ESD)

- ESP8266, OLED-Display und die TO-92-Transistoren sind empfindlich gegenüber statischer Entladung. Vor dem Anfassen ungeladenes Metall berühren (z.B. Heizungsrohr), besonders bei trockener Luft/Teppichböden.

### A4. Radioaktive Prüfquellen (nur falls verwendet)

Für dieses Projekt ist **keine radioaktive Prüfquelle nötig** – natürliche Hintergrundstrahlung reicht zum Funktionstest. Die GM-Röhre selbst enthält kein radioaktives Material.

Falls trotzdem eine Prüfquelle zum Testen verwendet werden soll (z.B. ein altes Americium-241-Präparat aus einem Rauchmelder, ein thorierter Schweißstab, oder Uranglas):

- In Deutschland gilt das Strahlenschutzgesetz (StrlSchG) – die meisten haushaltsüblichen "Prüfstrahler" liegen zwar unterhalb der Freigrenzen, dennoch: **keine Quelle öffnen, keine Quelle verschlucken/einatmen-Risiko schaffen, keine Quelle direkt am Körper tragen.**
- Abstand halten (Dosisleistung nimmt quadratisch mit der Entfernung ab) und Kontaktzeit minimieren.
- Im Zweifel: keine Prüfquelle verwenden, sondern nur die Hintergrundstrahlung messen.

## Teil B: Einheiten der Strahlung

| Größe | SI-Einheit | Veraltete Einheit | Umrechnung | Bedeutung |
|---|---|---|---|---|
| Aktivität (wie viele Zerfälle pro Zeit) | Becquerel (Bq) = 1 Zerfall/Sekunde | Curie (Ci) | 1 Ci = 3,7 × 10¹⁰ Bq | Eigenschaft der radioaktiven Quelle selbst, unabhängig vom Messgerät |
| Energiedosis (absorbierte Energie pro Masse) | Gray (Gy) = 1 J/kg | Rad | 1 Gy = 100 rad | Wie viel Energie im Material tatsächlich ankommt |
| Äquivalent-/effektive Dosis (biologische Wirkung) | Sievert (Sv) | Rem | 1 Sv = 100 rem | Energiedosis gewichtet mit einem Faktor je Strahlungsart (α, β, γ wirken biologisch unterschiedlich stark) |
| **CPM** (Counts Per Minute) | – (kein SI, Rohmesswert) | – | geräte-/röhrenspezifischer Kalibrierfaktor nötig | Reine Impulszählrate der GM-Röhre; erst mit einem Umrechnungsfaktor (CPM pro µSv/h) in eine Dosisleistung umrechenbar |

**Wichtig für dieses Projekt:** Der CPM→µSv/h-Umrechnungsfaktor ist **röhrenspezifisch**. Das GC-1602-NANO verwendet laut Upstream-Beschreibung eine J305-Röhre; die Upstream-Firmware rechnet mit **151 CPM = 1 µSv/h**. Für J305/SBM-20-Röhren kursieren Faktoren von etwa 151–154. Das ist ein Standardwert und **keine Kalibrierung dieser Einheit**: Die Empfindlichkeit hängt von Röhre, Strahlungsart und -energie ab. Für eine belastbare Anzeige in µSv/h muss der Faktor durch Vergleich mit einem kalibrierten Referenzgerät ermittelt werden (siehe [10-calibration-data-quality.md](v2/10-calibration-data-quality.md)). Bis dahin ist **CPM** der Primärmesswert, die µSv/h-Umrechnung ist vorläufig. (Die frühere Planung mit einer STS-6-Röhre ist mit V2 entfallen; für diese Röhre wurde kein Datenblattfaktor gefunden.)

Am gebräuchlichsten in der Praxis: **µSv/h** (mikrosievert pro Stunde) für die aktuelle Dosisleistung, **mSv/Jahr** (millisievert pro Jahr) für die Langzeit-/Jahresdosis.

## Teil C: Internationale und nationale Schwellwerte

### Natürliche Hintergrundstrahlung (Referenzwerte)

| Wert | Größe | Quelle |
|---|---|---|
| 0,05–0,2 µSv/h | typische Gamma-Ortsdosisleistung in Deutschland (ODL-Messnetz, 1.700 Stationen) | [BfS ODL-Info](https://odlinfo.bfs.de/ODL/DE/themen/was-ist-odl/einfuehrung/einfuehrung.html) |
| Ø 2,1 mSv/Jahr (Bereich 1–10 mSv/Jahr) | gesamte natürliche Strahlenbelastung pro Person in Deutschland (inkl. Radon, je nach Wohnort/Lebensstil) | [BfS](https://www.bfs.de/DE/themen/ion/umwelt/natuerliche-strahlung/natuerliche-strahlung_node.html) |
| davon ~0,7 mSv/Jahr | externe natürliche Strahlung (kosmisch + terrestrisch) | BfS |
| davon ~1,1 mSv/Jahr (Bereich 1–6) | Radon-Exposition (Einatmen, nicht mit einem Geigerzähler direkt als externe Dosisleistung messbar) | BfS |

**Hinweis:** Ein Geigerzähler misst die **externe** Gamma-/Beta-Dosisleistung am Aufstellort (vergleichbar mit der ODL). Radon- und Ingestionsdosis (Nahrung) sind darin **nicht** enthalten, obwohl sie einen großen Teil der Jahresdosis ausmachen.

### Gesetzliche Grenzwerte (Deutschland, Strahlenschutzgesetz/-verordnung)

| Personengruppe | Grenzwert effektive Dosis | Anmerkung |
|---|---|---|
| Allgemeine Bevölkerung | **1 mSv/Jahr** (aus künstlichen Quellen) | Gilt zusätzlich zur natürlichen Hintergrundstrahlung |
| Beruflich exponierte Personen | **20 mSv/Jahr** | Ausnahmsweise bis 50 mSv in einem Einzeljahr zulässig, aber max. 100 mSv über 5 aufeinanderfolgende Jahre |
| Beruflich exponierte Personen unter 18 Jahren (z.B. Azubis) | **1 mSv/Jahr** | |

Quelle: [§78 StrlSchG](https://www.buzer.de/78_StrlSchG_Strahlenschutzgesetz.htm), [BfS – Grenzwerte für beruflich exponierte Personen](https://www.bfs.de/DE/themen/ion/strahlenschutz/beruf/grenzwerte/grenzwerte_node.html)

### Internationale Empfehlung (ICRP)

Die International Commission on Radiological Protection (ICRP) empfiehlt in ihrer Publikation 60 (Basis der deutschen Grenzwerte) ebenfalls **20 mSv/Jahr für beruflich exponierte Personen** und **1 mSv/Jahr für die Bevölkerung** – Deutschland folgt hier direkt der internationalen Empfehlung.

### Praktische Vergleichswerte (effektive Dosis, Einzelereignis)

| Ereignis | Dosis | Quelle |
|---|---|---|
| Röntgen Thorax (Lunge) | 0,01–0,03 mSv | BfS/MSD Manual |
| Interkontinentalflug (z.B. Deutschland–Japan, kosmische Strahlung) | ca. 0,1 mSv | BfS |
| CT Thorax | ca. 5,9–6,1 mSv | BfS |

Zum Vergleich: Der gesetzliche Jahresgrenzwert für die Bevölkerung (1 mSv aus künstlichen Quellen) entspricht überschlägig einer Dauerbelastung von ca. **0,11 µSv/h**, wenn man ihn gleichmäßig auf ein Jahr (8.760 Stunden) verteilt – ein rein rechnerischer Vergleichswert, keine reale kontinuierliche Exposition.

## Einordnung für dieses Projekt

Ein funktionierender DIY-Geigerzähler wird im Alltag üblicherweise Werte im Bereich der natürlichen Ortsdosisleistung (**0,05–0,2 µSv/h**) anzeigen. Deutlich und dauerhaft höhere Werte sind ungewöhnlich und sollten Anlass sein, die Messung mit einem zweiten Gerät zu verifizieren, bevor man von einer echten Strahlenquelle in der Umgebung ausgeht (häufigere Ursache: Kalibrierfehler, elektromagnetische Störeinstrahlung auf die Pulserfassung, oder ein Defekt der Schaltung).
