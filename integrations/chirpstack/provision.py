#!/usr/bin/env python3
"""One-shot ChirpStack provisioning for IceGeiger. Run once after `docker compose up -d`.

Creates two device profiles (ABP test / OTAA), the application, the gateway, an ABP test device and sets a new
random admin password. Generated secrets are written to geiger_device.json (mode 600) next to this script and
never printed. Environment: GATEWAY_ID (16 hex chars, required), CHIRPSTACK_DIR (default: this directory).
The REST API must be reachable on 127.0.0.1:8191 (see docker-compose.yml). Authentication uses a temporary
admin API key that is inserted into the database and removed again at the end."""
import json, os, hmac, hashlib, base64, uuid, secrets, subprocess, urllib.request, urllib.error
HERE=os.path.dirname(os.path.abspath(__file__)); WORK=os.environ.get('CHIRPSTACK_DIR',HERE)
GW_ID=os.environ['GATEWAY_ID'].lower()
BASE='http://127.0.0.1:8191'
env=dict(l.strip().split('=',1) for l in open(os.path.join(WORK,'.env')) if '=' in l and not l.startswith('#'))
def b64(b): return base64.urlsafe_b64encode(b).rstrip(b'=').decode()
def jwt(sub):
    h=b64(json.dumps({'alg':'HS256','typ':'JWT'}).encode()); p=b64(json.dumps({'aud':'chirpstack','iss':'chirpstack','sub':sub,'typ':'key'}).encode())
    sig=hmac.new(env['API_SECRET'].encode(),f'{h}.{p}'.encode(),hashlib.sha256).digest(); return f'{h}.{p}.{b64(sig)}'
def sql(q): return subprocess.run(['docker','compose','exec','-T','postgres','psql','-U','chirpstack','-d','chirpstack','-tA','-c',q],capture_output=True,text=True,cwd=WORK)
key_id=str(uuid.uuid4())
r=sql(f"insert into api_key(id,created_at,name,is_admin,is_read_only) values ('{key_id}',now(),'bootstrap-provisioning',true,false);"); assert r.returncode==0,r.stderr
TOKEN=jwt(key_id)
def call(method,path,body=None):
    req=urllib.request.Request(BASE+path,method=method,data=json.dumps(body).encode() if body is not None else None,headers={'Content-Type':'application/json','Grpc-Metadata-Authorization':'Bearer '+TOKEN})
    try:
        with urllib.request.urlopen(req,timeout=20) as resp: t=resp.read().decode(); return json.loads(t) if t else {}
    except urllib.error.HTTPError as e: raise SystemExit(f'{method} {path} -> {e.code} {e.read().decode()[:300]}')
try:
    tenants=call('GET','/api/tenants?limit=10')['result']; tenant=tenants[0]['id']; print('tenant',tenants[0]['name'])
    codec=open(os.path.join(HERE,'codec.js')).read()
    common=dict(tenantId=tenant,region='EU868',macVersion='LORAWAN_1_0_3',regParamsRevision='A',adrAlgorithmId='default',payloadCodecRuntime='JS',payloadCodecScript=codec,flushQueueOnActivate=True,uplinkInterval=900,deviceStatusReqInterval=0,supportsClassB=False,supportsClassC=False,autoDetectMeasurements=True)
    abp=call('POST','/api/device-profiles',{'deviceProfile':dict(common,name='IceGeiger EU868 ABP (Test)',description='ABP test profile for a single-channel gateway',supportsOtaa=False,abpRx1Delay=1,abpRx1DrOffset=0,abpRx2Dr=0,abpRx2Freq=869525000)})['id']
    otaa=call('POST','/api/device-profiles',{'deviceProfile':dict(common,name='IceGeiger EU868 OTAA',description='OTAA profile for a real multi-channel gateway',supportsOtaa=True)})['id']
    app=call('POST','/api/applications',{'application':{'name':'IceGeiger','description':'IceGeiger V2 telemetry','tenantId':tenant}})['id']
    gw_id=GW_ID
    call('POST','/api/gateways',{'gateway':{'gatewayId':gw_id,'name':'IceGeiger test gateway','description':'Single-channel test gateway (868.1 MHz, Semtech UDP) - replace by a real multi-channel gateway','tenantId':tenant,'statsInterval':30}})
    dev=dict(devEui=secrets.token_hex(8),devAddr='00'+secrets.token_hex(3),appSKey=secrets.token_hex(16),nwkSKey=secrets.token_hex(16))
    call('POST','/api/devices',{'device':{'devEui':dev['devEui'],'name':'icegeiger-v2','description':'IceGeiger V2 (ABP test)','applicationId':app,'deviceProfileId':abp,'skipFcntCheck':True,'isDisabled':False}})
    call('POST',f"/api/devices/{dev['devEui']}/activate",{'deviceActivation':{'devEui':dev['devEui'],'devAddr':dev['devAddr'],'appSKey':dev['appSKey'],'nwkSEncKey':dev['nwkSKey'],'fNwkSIntKey':dev['nwkSKey'],'sNwkSIntKey':dev['nwkSKey'],'fCntUp':0,'nFCntDown':0,'aFCntDown':0}})
    admin=sql("select id from \"user\" where email='admin';").stdout.strip()
    newpw=secrets.token_urlsafe(18)
    call('POST',f'/api/users/{admin}/password',{'password':newpw})
    json.dump(dict(dev,application_id=app,profile_abp=abp,profile_otaa=otaa,gateway_id=gw_id,tenant=tenant,admin_password=newpw),open(os.path.join(WORK,'geiger_device.json'),'w'),indent=1)
    print('provisioned: application',app,'device',dev['devEui'],'gateway',gw_id)
finally:
    sql(f"delete from api_key where id='{key_id}';")
