# Sicherheitsregeln & Strahlungsgrundlagen

Dieses Dokument fasst alle Sicherheitsregeln für Bau und Betrieb an einer Stelle zusammen und erklärt die Einheiten/Grenzwerte, die beim Umgang mit einem selbstgebauten Geigerzähler relevant sind.

## Teil A: Sicherheitsregeln

### A1. Hochspannungsschaltung (~400V)

Die selbstgebaute HV-Schaltung (siehe [06-hv-circuit.md](06-hv-circuit.md)) erzeugt intern ca. 400V Gleichspannung.

- **Niemals** an Schaltungsteile fassen, während die Schaltung an Spannung liegt.
- Vor jeder Berührung/Messung/Umbau: Spannungsquelle trennen **und** den Speicherkondensator aktiv entladen (z.B. über einen Widerstand ~100 kΩ, nicht direkt kurzschließen – ein Kurzschluss kann den Kondensator beschädigen und erzeugt einen gefährlichen Funken).
- **Ein-Hand-Regel:** Beim Messen unter Spannung nur eine Hand verwenden, die andere in die Tasche – verhindert einen Stromfluss durch den Brustkorb, falls doch versehentlich Kontakt entsteht.
- Aufbau auf Lochrasterplatine mit ausreichend Kriechstrecke zwischen 400V-führenden Leiterbahnen, nicht auf offenem Steckbrett im Dauerbetrieb.
- Vor Anschluss der Röhre die HV-Ausgangsspannung mit einem Multimeter (Hochspannungstastkopf, min. 600V-Bereich) prüfen.
- Fertig aufgebautes Gerät im Gehäuse: keine berührbaren HV-Kontakte nach außen führen.

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

**Wichtig für dieses Projekt:** Der CPM→µSv/h-Umrechnungsfaktor ist **röhrenspezifisch**. Für die ursprünglich geplante J305/SBM-20-Röhre kursiert häufig ein Faktor von ca. 151–154 CPM = 1 µSv/h – dieser Wert gilt **nicht automatisch** für die jetzt geplante STS-6-Röhre (kein verifizierter Datenblattwert gefunden). Vor einer aussagekräftigen Anzeige in µSv/h sollte der Faktor entweder aus dem Datenblatt der tatsächlich verbauten Röhre entnommen oder durch Vergleich mit einem kalibrierten Referenzgerät ermittelt werden. Bis dahin zeigt das Gerät zuverlässig **CPM** an, die µSv/h-Umrechnung ist als vorläufig zu behandeln.

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
