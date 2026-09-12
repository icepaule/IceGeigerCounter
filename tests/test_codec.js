const c=require('../integrations/chirpstack/codec.js');
// v1: version, seq=7, cpm=123, usvh=0.250, lat/lon, sats=9, hdop=1.2, battery=3700 mV
const b=[1,0,0,0,7,0,123,0,250,28,172,129,0,6,234,207,192,9,12,14,116];
if(b.length!==21) throw new Error('test payload length');
const d=c.decode(b);
if(d.seq!==7||d.cpm!==123||Math.abs(d.usvh-.25)>.001||d.battery_mv!==3700)throw new Error('codec failed');
console.log('codec test: OK');
