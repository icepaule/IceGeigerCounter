#!/usr/bin/env python3
import os,json,base64,struct,datetime
import paho.mqtt.client as mqtt
try:
 from influxdb_client import InfluxDBClient,Point,WritePrecision
except Exception:
 InfluxDBClient=Point=WritePrecision=None
HOST=os.getenv('MQTT_HOST','localhost'); PORT=int(os.getenv('MQTT_PORT','1883')); USER=os.getenv('MQTT_USER',''); PASSWORD=os.getenv('MQTT_PASSWORD',''); HA=os.getenv('HA_PREFIX','homeassistant')
IU=os.getenv('INFLUX_URL',''); IT=os.getenv('INFLUX_TOKEN',''); IO=os.getenv('INFLUX_ORG',''); IB=os.getenv('INFLUX_BUCKET','')
seen=set(); influx=None; write_api=None

def decode_binary(raw):
 if len(raw)<22 or raw[0]!=1: raise ValueError('invalid IceGeiger v1 payload')
 seq=struct.unpack('>I',raw[1:5])[0]; cpm=struct.unpack('>H',raw[5:7])[0]; usvh=struct.unpack('>H',raw[7:9])[0]/1000.0
 lat=struct.unpack('>i',raw[9:13])[0]/1e7; lon=struct.unpack('>i',raw[13:17])[0]/1e7
 return {'version':1,'seq':seq,'cpm_60s':cpm,'usvh':usvh,'lat':lat,'lon':lon,'satellites':raw[17],'hdop':raw[18]/10,'battery_mv':struct.unpack('>H',raw[19:21])[0]}

def normalize_direct(topic,p):
 d=json.loads(p.decode()); device=d.get('device') or topic.split('/')[1]; return device,d

def normalize_chirp(p):
 e=json.loads(p.decode()); info=e.get('deviceInfo') or e.get('device_info') or {}; device=info.get('deviceName') or info.get('device_name') or info.get('devEui') or 'icegeiger-lora'
 d=e.get('object') or e.get('decodedPayload') or e.get('decoded_payload')
 if not isinstance(d,dict): d=decode_binary(base64.b64decode(e.get('data','')))
 if 'cpm' in d and 'cpm_60s' not in d:d['cpm_60s']=d['cpm']
 if 'latitude' in d and 'lat' not in d:d['lat']=d['latitude']
 if 'longitude' in d and 'lon' not in d:d['lon']=d['longitude']
 return device,d

def discovery(c,dev):
 if dev in seen:return
 seen.add(dev); ident=dev.replace('-','_')
 sensors=[('cpm','CPM','cpm_60s','cpm'),('usvh','Dose rate','usvh','µSv/h'),('satellites','GNSS satellites','satellites',None)]
 for suffix,name,key,unit in sensors:
  cfg={'name':f'IceGeiger {name}','unique_id':f'{ident}_{suffix}','state_topic':f'icegeiger_ha/{dev}/state','value_template':f'{{{{ value_json.{key} }}}}','device':{'identifiers':[dev],'name':f'IceGeiger {dev}','manufacturer':'DIY','model':'IceGeiger V2'}}
  if unit:cfg['unit_of_measurement']=unit
  c.publish(f'{HA}/sensor/{ident}_{suffix}/config',json.dumps(cfg),qos=1,retain=True)
 tr={'name':f'IceGeiger {dev}','unique_id':f'{ident}_tracker','json_attributes_topic':f'icegeiger_ha/{dev}/location','source_type':'gps','device':{'identifiers':[dev],'name':f'IceGeiger {dev}'}}
 c.publish(f'{HA}/device_tracker/{ident}/config',json.dumps(tr),qos=1,retain=True)

def write_influx(dev,d,transport):
 if not write_api or Point is None:return
 p=Point('radiation').tag('device',dev).field('transport',transport)
 for k in ('seq','counts_10s','cpm_60s','usvh','lat','lon','satellites','hdop','battery_mv'):
  if k in d and d[k] is not None:p=p.field(k,d[k])
 ts=d.get('ts')
 if ts:
  try:p=p.time(datetime.datetime.fromtimestamp(int(ts),datetime.timezone.utc),WritePrecision.S)
  except Exception:pass
 write_api.write(bucket=IB,org=IO,record=p)

def on_connect(c,u,flags,reason,props=None):
 c.subscribe('icegeiger/+/live',qos=1);c.subscribe('icegeiger/+/history',qos=1);c.subscribe('application/+/device/+/event/up',qos=1)

def on_message(c,u,m):
 try:
  if m.topic.startswith('application/'):
   dev,d=normalize_chirp(m.payload);transport='lorawan';live=True
  else:
   dev,d=normalize_direct(m.topic,m.payload);transport='wifi-history' if '/history' in m.topic else 'wifi-live';live=transport=='wifi-live'
  discovery(c,dev);write_influx(dev,d,transport)
  if live:
   c.publish(f'icegeiger_ha/{dev}/state',json.dumps(d),qos=1,retain=True)
   if d.get('lat') is not None and d.get('lon') is not None:
    loc={'latitude':d['lat'],'longitude':d['lon'],'gps_accuracy':max(1,int(float(d.get('hdop',1))*5))};c.publish(f'icegeiger_ha/{dev}/location',json.dumps(loc),qos=1,retain=True)
 except Exception as e: print('bridge error',m.topic,e,flush=True)

def main():
 global influx,write_api
 if IU and IT and IO and IB and InfluxDBClient:
  influx=InfluxDBClient(url=IU,token=IT,org=IO);write_api=influx.write_api()
 c=mqtt.Client(mqtt.CallbackAPIVersion.VERSION2,client_id='icegeiger-bridge');
 if USER:c.username_pw_set(USER,PASSWORD)
 c.on_connect=on_connect;c.on_message=on_message;c.connect(HOST,PORT,60);c.loop_forever()
if __name__=='__main__':main()
