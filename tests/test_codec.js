const c=require('../integrations/chirpstack/codec.js');
const b=[1,0,0,0,7,0,123,0,250,28,172,129,0,6,234,207,192,9,12,0,0,0];
const d=c.decode(b); if(d.seq!==7||d.cpm!==123||Math.abs(d.usvh-.25)>.001)throw new Error('codec failed'); console.log('codec test: OK');
