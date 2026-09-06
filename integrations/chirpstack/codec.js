function u16(b,i){return (b[i]<<8)|b[i+1];}
function u32(b,i){return ((b[i]*0x1000000)+((b[i+1]<<16)|(b[i+2]<<8)|b[i+3]))>>>0;}
function i32(b,i){let v=u32(b,i);return v>0x7fffffff?v-0x100000000:v;}
function decode(bytes){if(!bytes||bytes.length<22)throw new Error('IceGeiger payload too short');if(bytes[0]!==1)throw new Error('Unsupported payload version');return {version:1,seq:u32(bytes,1),cpm:u16(bytes,5),usvh:u16(bytes,7)/1000,latitude:i32(bytes,9)/1e7,longitude:i32(bytes,13)/1e7,satellites:bytes[17],hdop:bytes[18]/10,battery_mv:u16(bytes,19)};}
function decodeUplink(input){try{return {data:decode(input.bytes)}}catch(e){return {errors:[String(e.message||e)]}}}
function Decoder(bytes,port){return decode(bytes);}
if(typeof module!=='undefined')module.exports={decode,decodeUplink,Decoder};
