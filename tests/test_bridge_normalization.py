import importlib.util,pathlib,sys,types
paho=types.ModuleType('paho');paho.__path__=[];mqttpkg=types.ModuleType('paho.mqtt');mqttpkg.__path__=[];client=types.ModuleType('paho.mqtt.client');client.CallbackAPIVersion=types.SimpleNamespace(VERSION2=2);client.Client=object
sys.modules['paho']=paho;sys.modules['paho.mqtt']=mqttpkg;sys.modules['paho.mqtt.client']=client
p=pathlib.Path(__file__).parents[1]/'integrations/bridge/bridge.py';s=importlib.util.spec_from_file_location('bridge',p);m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
raw=bytes([1,0,0,0,7,0,123,0,250,28,172,129,0,6,234,207,192,9,12,0,0,0]);d=m.decode_binary(raw)
assert d['seq']==7 and d['cpm_60s']==123 and abs(d['usvh']-.25)<.001
print('bridge normalization test: OK')
