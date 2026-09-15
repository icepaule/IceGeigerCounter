#!/usr/bin/env python3
import sys
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
from matplotlib.patches import Circle

src,dst=sys.argv[1],sys.argv[2]
img=mpimg.imread(src)
fig=plt.figure(figsize=(18,10),dpi=100)
ax=fig.add_axes([0.00,0.00,0.72,1.00]); ax.imshow(img); ax.axis('off')
ax2=fig.add_axes([0.73,0.03,0.26,0.94]); ax2.axis('off')
ax2.text(0,0.98,'IceGeiger Field Case v1.5.1',fontsize=18,fontweight='bold',va='top')
ax2.text(0,0.93,'Explosionszeichnung / Dateizuordnung',fontsize=12,va='top')
entries=[
 ('1','BASE','IceGeiger_FieldCase_v1.5.1_BASE.*'),
 ('2','LID','IceGeiger_FieldCase_v1.5.1_LID.*'),
 ('3','SERVICE BRIDGE','IceGeiger_FieldCase_v1.5.1_SERVICE_BRIDGE.*'),
 ('4','BETA CAP','IceGeiger_FieldCase_v1.5.1_BETA_CAP.*'),
 ('5','REAR BADGE','IceGeiger_FieldCase_v1.5.1_REAR_BADGE.*'),
 ('6','GASKET JIG','IceGeiger_FieldCase_v1.5.1_GASKET_JIG.*')]
y=0.84
for n,title,fn in entries:
    ax2.text(0,y,f'{n}. {title}',fontsize=14,fontweight='bold',va='top')
    ax2.text(0.04,y-0.04,fn,fontsize=9,va='top')
    y-=0.13
ax2.text(0,0.03,'Hinweis: GASKET JIG ist ein separates Testteil und kein Bestandteil der montierten Einheit.',fontsize=9,wrap=True)
fig.savefig(dst,bbox_inches='tight',pad_inches=.05)
plt.close(fig)
