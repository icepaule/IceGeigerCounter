#!/usr/bin/env python3
from pathlib import Path
OUT=Path(__file__).resolve().parents[1]/'docs/v2/images';OUT.mkdir(parents=True,exist_ok=True)
def svg(title,boxes,arrows):
 s=['<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="700" viewBox="0 0 1200 700"><defs><marker id="a" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto"><path d="M0,0 L0,6 L9,3 z" fill="#333"/></marker></defs><rect width="100%" height="100%" fill="white"/><text x="600" y="45" text-anchor="middle" font-family="sans-serif" font-size="28" font-weight="bold">'+title+'</text>']
 for x,y,w,h,t in boxes:s+= [f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="12" fill="#eef6ff" stroke="#333" stroke-width="2"/><text x="{x+w/2}" y="{y+h/2}" text-anchor="middle" dominant-baseline="middle" font-family="sans-serif" font-size="18">{t}</text>']
 for x1,y1,x2,y2,label in arrows:s += [f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="#333" stroke-width="2" marker-end="url(#a)"/><text x="{(x1+x2)/2}" y="{(y1+y2)/2-8}" text-anchor="middle" font-family="sans-serif" font-size="14">{label}</text>']
 return ''.join(s)+'</svg>'
arch=[(40,150,210,120,'GC-1602-NANO'),(330,140,250,140,'Heltec Tracker V2'),(360,390,180,100,'microSD / Offline'),(690,100,180,100,'WLAN / MQTT'),(680,270,190,100,'EU868 LoRaWAN'),(950,270,190,100,'Gateway + ChirpStack'),(690,500,180,100,'Home Assistant'),(950,500,190,100,'InfluxDB / Grafana')]
arr=[(250,210,330,210,'P3 INT / 10k+20k'),(455,280,450,390,'10-s Log'),(580,180,690,150,'WiFi'),(580,230,680,320,'LoRaWAN'),(870,320,950,320,'RF'),(780,200,780,500,'MQTT'),(1040,370,1040,500,'History')]
(OUT/'v2_architecture.svg').write_text(svg('IceGeiger V2 – Architektur',arch,arr))
wire=[(40,150,250,150,'GC-1602 P3'),(370,160,180,130,'10k / 20k Pegelteiler'),(680,120,300,210,'Heltec Tracker V2'),(700,430,220,120,'microSD 3.3 V'),(60,450,220,110,'2×18650 1S2P'),(380,450,180,110,'5-V Boost')]
warr=[(290,220,370,220,'INT'),(550,220,680,220,'GPIO47 ≤3.3V'),(800,330,800,430,'SPI 4/5/6/7'),(280,500,380,500,'3–4.2V'),(470,450,170,300,'5V GC'),(280,480,680,300,'Akku Heltec')]
(OUT/'v2_wiring.svg').write_text(svg('IceGeiger V2 – Verdrahtung',wire,warr))
