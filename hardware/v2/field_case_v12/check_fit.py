#!/usr/bin/env python3
from dataclasses import dataclass

@dataclass(frozen=True)
class Box:
    name: str; x: float; y: float; z: float; l: float; w: float; h: float
    @property
    def x2(self): return self.x+self.l
    @property
    def y2(self): return self.y+self.w
    @property
    def z2(self): return self.z+self.h

def overlap(a,b):
    return (min(a.x2,b.x2)-max(a.x,b.x), min(a.y2,b.y2)-max(a.y,b.y), min(a.z2,b.z2)-max(a.z,b.z))
def collides(a,b):
    o=overlap(a,b); return all(v>0 for v in o),o

case_l=120; case_w=120; base_h=54; floor=2.8; wall=2.6; divider_y=71; divider_t=2.2
boxes=[
 Box('GC-1602 envelope',6,4,4.3,108,65,47),
 Box('battery holder',39,75.5,3,76,40.5,20),
 Box('tracker full envelope',6,80,31.1,65.84,28,14.71),
 Box('GNSS no-metal column',6,80,floor,22,24,base_h-floor),
 Box('microSD vertical',78,114,26,21,4,18),
 Box('BMS',46,72.8,27,32,4,8),
 Box('5V regulator',83,72.8,27,12.5,5,9.5),
]
by={b.name:b for b in boxes}
checks=[]
for a_name,b_name in [
 ('GC-1602 envelope','battery holder'),('GC-1602 envelope','tracker full envelope'),
 ('GC-1602 envelope','microSD vertical'),('battery holder','tracker full envelope'),
 ('battery holder','microSD vertical'),('GNSS no-metal column','battery holder'),
 ('GNSS no-metal column','microSD vertical'),('GNSS no-metal column','BMS'),
 ('GNSS no-metal column','5V regulator')]:
    a,b=by[a_name],by[b_name]; c,o=collides(a,b); checks.append((a_name,b_name,c,o))

print('IceGeiger Field Case V1.2 envelope check')
print('Body: %.1f x %.1f x %.1f mm + %.1f mm lid' % (case_l,case_w,base_h,4.2))
failed=False
for a,b,c,o in checks:
    print(f'{a:24s} vs {b:24s}: '+('COLLISION' if c else 'OK')+f' overlap={tuple(round(v,2) for v in o)}')
    failed |= c
clearances={
 'GC top -> lid underside': base_h-by['GC-1602 envelope'].z2,
 'battery top -> tracker pin tips': (31.1-6.1)-by['battery holder'].z2,
 'tracker top -> lid underside': base_h-by['tracker full envelope'].z2,
 'GC right edge -> case inner wall': (case_l-wall)-by['GC-1602 envelope'].x2,
 'battery right edge -> case inner wall': (case_l-wall)-by['battery holder'].x2,
 'battery outer-Y edge -> case inner wall': (case_w-wall)-by['battery holder'].y2,
 'GC outer-Y edge -> divider': divider_y-by['GC-1602 envelope'].y2,
}
print('\nKey clearances:')
for k,v in clearances.items(): print(f'  {k:38s}: {v:5.2f} mm')
for k,v in clearances.items():
    req=0.8 if 'battery' in k and 'wall' in k else 1.5
    if v < req: print(f'FAIL: {k} below {req:.1f} mm'); failed=True
if failed: raise SystemExit(1)
print('\nPASS: no conservative envelope collisions detected.')
