// IceGeiger Field Case v1.5.1 - standalone OpenSCAD, no external libs
$fn=64;
part=is_undef(part)?"assembly":part;

// enclosure
L=130; W=132; H=58; lid_t=4.2; wall=2.6; floor=2.8; cr=5;
div_y=72; div_t=2.2; div_hole=10; div_z=14; div_x=[35,86];
seal_w=2.45; seal_d=1.55; seal_o=4.4;
m3=3.35; insert_d=4.6; insert_dep=5.2; lug_r=5.2;
lugs=[[0,10],[0,122],[130,10],[130,122],[10,0],[120,0],[10,132],[120,132]];

// GC-1602 seller envelope
gc_l=108; gc_w=65; gc_h=47; gc_x=11; gc_y=4.5; gc_z=4.5; gc_pad=12;
lcd_x=29; lcd_y=15; lcd_l=80; lcd_w=26;
tube_l=90; tube_d=10; tube_x=20; tube_y=7.2; tube_z=13;
beta_x=17; beta_l=96; beta_z=6.5; beta_h=18; beta_f=3; beta_t=3;

// Battery Shield measured
sh_l=100.2; sh_w=48; sh_x=(L-sh_l)/2; sh_y=78; sh_z=9; sh_pcb=1.6; sh_under=5;
sh_holes=97; sh_edge=(sh_l-sh_holes)/2; sh_hx=[sh_x+sh_edge,sh_x+sh_edge+sh_holes];
rail_len=90; rail_w=5; rail_h=5; rail_x=sh_x+(sh_l-rail_len)/2;
rail_y=[sh_y+4,sh_y+sh_w-4-rail_w]; rail_z=sh_z-rail_h;
pad=10; pad_y=[sh_y+4,sh_y+sh_w-4];
feed_d=11; feed_y=102; feed_z=21;

// cells
cell_d=18.3; cell_l=64.85; cell_x=sh_x+15; cell_y=[sh_y+13.2,sh_y+34.8];
cell_z=sh_z+sh_pcb+cell_d/2;

// service bridge / tracker / SD
bx=5.5; by=96; bl=119; bw=31; bz=33; bt=2.4;
bposts=[[6.2,100.5],[6.2,122.5],[123.8,100.5],[123.8,122.5]];
tr_l=65.84; tr_w=28; tr_h=14.71; tr_pin=6.1; tr_x=54; tr_y=97.5; tr_z=40;
td_x=tr_x+12; td_y=tr_y+4; td_l=32; td_w=20;
gn_x=tr_x+44; gn_y=tr_y+2.5; gn_l=21.5; gn_w=23;
sd_l=21; sd_w=18; sd_h=12; sd_x=11; sd_y=100; sd_z=bz+bt+1.5;

// rear interfaces
sma_d=6.5; sma_x=105; sma_z=45; sw_d=12.2; sw_x=25; sw_z=43;
eye_x=65; eye_z=46; eye_od=30; eye_id=12; eye_dep=9; eye_nw=34; eye_nh=16;
badge_l=78; badge_h=24; badge_t=1.2; badge_raise=.9; badge_dep=.85; badge_x=(L-badge_l)/2; badge_z=7.5;

module rr(l,w,r){hull(){for(x=[r,l-r])for(y=[r,w-r])translate([x,y])circle(r=r);}}
module rb(l,w,h,r){linear_extrude(h)rr(l,w,r);}
module body(h){union(){rb(L,W,h,cr);for(c=lugs)translate(c)cylinder(r=lug_r,h=h);}}
module cavity(z=0,h=100){translate([wall,wall,z])rb(L-2*wall,W-2*wall,h,max(1,cr-wall));}
module gasket(){
 difference(){
  translate([seal_o,seal_o,H-seal_d])rb(L-2*seal_o,W-2*seal_o,seal_d+.2,2.8);
  translate([seal_o+seal_w,seal_o+seal_w,H-seal_d-.1])rb(L-2*(seal_o+seal_w),W-2*(seal_o+seal_w),seal_d+.4,1);
 }
}
module gc_pads(){
 for(p=[[gc_x,gc_y],[gc_x+gc_l-gc_pad,gc_y],[gc_x,gc_y+gc_w-gc_pad],[gc_x+gc_l-gc_pad,gc_y+gc_w-gc_pad]])
  translate([p[0],p[1],floor-.3])cube([gc_pad,gc_pad,max(1.1,gc_z-floor+.3)]);
}
module shield_mount(){
 // actual print-test correction: rails exactly 90 mm long
 for(y=rail_y){
  translate([rail_x,y,floor-.3])cube([rail_len,rail_w+2,max(.3,rail_z-floor+.3)]);
  translate([rail_x,y,rail_z])cube([rail_len,rail_w,rail_h]);
 }
 // 10x10 insert lands at measured 97 mm X axes, Y intentionally tolerant
 for(x=sh_hx)for(y=pad_y)translate([x-pad/2,y-pad/2,floor-.3])cube([pad,pad,sh_z-floor+.3]);
}
module bridge_posts(){
 for(p=bposts)translate([p[0],p[1],floor-.3])difference(){
  cylinder(r=2.7,h=bz-floor+.3);
  translate([0,0,bz-floor-6.7])cylinder(d=2.6,h=7.5);
 }
}
module eye(){
 union(){
  translate([eye_x,W+eye_dep,eye_z])rotate([90,0,0])cylinder(d=eye_od,h=eye_dep+wall);
  translate([eye_x-eye_nw/2,W-wall,eye_z-eye_od/2])cube([eye_nw,eye_dep+wall,eye_nh]);
 }
}
module beta_open(){translate([beta_x,-1,beta_z])cube([beta_l,wall+2,beta_h]);}
module base(){
 difference(){
  union(){
   difference(){body(H);cavity(floor,H+2);}
   translate([wall,div_y,floor])cube([L-2*wall,div_t,H-floor-4]);
   gc_pads();shield_mount();bridge_posts();eye();
  }
  gasket();
  for(c=lugs)translate([c[0],c[1],H-insert_dep])cylinder(d=insert_d,h=insert_dep+.5);
  for(x=div_x)translate([x,div_y-.5,div_z])cube([div_hole,div_t+1,div_hole]);
  beta_open();
  translate([beta_x-beta_f,-.05,beta_z-beta_f])cube([beta_l+2*beta_f,1.2,beta_h+2*beta_f]);
  translate([eye_x,W+eye_dep+1,eye_z])rotate([90,0,0])cylinder(d=eye_id,h=eye_dep+wall+2);
  translate([badge_x,W-badge_dep,badge_z])cube([badge_l,badge_dep+.2,badge_h]);
  translate([sma_x,W+.5,sma_z])rotate([90,0,0])cylinder(d=sma_d,h=wall+2);
  translate([sw_x,W+.5,sw_z])rotate([90,0,0])cylinder(d=sw_d,h=wall+2);
  translate([L+.5,feed_y,feed_z])rotate([0,90,0])cylinder(d=feed_d,h=wall+2);
 }
}
module lid(){
 difference(){
  body(lid_t);
  for(c=lugs)translate([c[0],c[1],-.5])cylinder(d=m3,h=lid_t+1);
  translate([lcd_x,lcd_y,-1])cube([lcd_l,lcd_w,lid_t+2]);
  translate([lcd_x-3,lcd_y-3,-.1])cube([lcd_l+6,lcd_w+6,1.2]);
  translate([td_x,td_y,-1])cube([td_l,td_w,lid_t+2]);
  translate([td_x-3,td_y-3,-.1])cube([td_l+6,td_w+6,1.2]);
 }
}
module bridge(){
 difference(){
  union(){
   difference(){rb(bl,bw,bt,2.2);translate([4,4,-.2])cube([bl-8,bw-8,bt+.4]);}
   translate([4,6,0])cube([bl-8,3,bt]);translate([4,bw-9,0])cube([bl-8,3,bt]);
   translate([tr_x-bx-2,tr_y-by-1,bt])cube([tr_l+4,3,3.2]);
   translate([tr_x-bx-2,tr_y-by+tr_w-2,bt])cube([tr_l+4,3,3.2]);
   translate([sd_x-bx-1,sd_y-by-1,bt])cube([sd_l+2,2,3]);
   translate([sd_x-bx-1,sd_y-by+sd_w-1,bt])cube([sd_l+2,2,3]);
  }
  for(p=bposts)translate([p[0]-bx,p[1]-by,-.4])cylinder(d=3.2,h=bt+1);
  translate([tr_x-bx-1,tr_y-by-1,-.2])cube([tr_l+2,4,bt+.4]);
  translate([tr_x-bx-1,tr_y-by+tr_w-3,-.2])cube([tr_l+2,4,bt+.4]);
  translate([gn_x-bx-2,gn_y-by-2,-.2])cube([gn_l+4,gn_w+4,bt+.4]);
 }
}
module beta_cap(){
 cl=beta_l+2*beta_f+2; ch=beta_h+2*beta_f+2;
 difference(){union(){cube([cl,beta_t,ch]);translate([1,beta_t,1])cube([cl-2,1,ch-2]);}
  for(x=[2.5,cl-2.5])translate([x,-.5,ch/2])rotate([-90,0,0])cylinder(d=m3,h=beta_t+2);
 }
}
function ap(r,a1,a2,n=16)=[for(i=[0:n])[r*cos(a1+(a2-a1)*i/n),r*sin(a1+(a2-a1)*i/n)]];
module sector(r1,r2,a1,a2){polygon(concat(ap(r2,a1,a2),[for(i=[16:-1:0])[r1*cos(a1+(a2-a1)*i/16),r1*sin(a1+(a2-a1)*i/16)]]));}
module trefoil(){union(){circle(r=2.7);for(a=[90,210,330])rotate(a)sector(5.3,11.2,-28,28);}}
module badge(){
 union(){
  linear_extrude(badge_t)offset(r=1.2)square([badge_l-2.4,badge_h-2.4],center=true);
  translate([-badge_l/2+15,0,badge_t])linear_extrude(badge_raise)trefoil();
  translate([-11,-4.8,badge_t])linear_extrude(badge_raise)text("IceDrone",size=9,font="Liberation Sans:style=Bold");
 }
}
module gasket_jig(){difference(){cube([36,36,6]);translate([7,7,6-seal_d])difference(){cube([22,22,seal_d+.2]);translate([seal_w,seal_w,-.1])cube([22-2*seal_w,22-2*seal_w,seal_d+.4]);}}}

// mocks for documentation
module mocks(){
 color([.05,.35,.65,.35])translate([gc_x,gc_y,gc_z])cube([gc_l,gc_w,gc_h]);
 color([.05,.1,.12,.5])translate([sh_x,sh_y,sh_z])cube([sh_l,sh_w,sh_pcb]);
 for(y=cell_y)color([.1,.55,.25,.7])translate([cell_x,y,cell_z])rotate([0,90,0])cylinder(d=cell_d,h=cell_l);
 color([.95,.55,.05,.75])translate([bx,by,bz])bridge();
 color([.04,.04,.04,.7])translate([tr_x,tr_y,tr_z])cube([tr_l,tr_w,1.6]);
 color("lightgray")translate([gn_x,gn_y,tr_z+1.6])cube([gn_l,gn_w,7]);
 color("darkgreen")translate([sd_x,sd_y,sd_z])cube([sd_l,sd_w,sd_h]);
}
module assembly(z=0){color([.76,.78,.8,.4])base();mocks();color([.82,.84,.86,.55])translate([0,0,H+z])lid();color([1,.7,.1,.9])translate([beta_x-beta_f-1,-beta_t-1,beta_z-beta_f-1])beta_cap();}
module exploded(){color([.76,.78,.8,.75])base();color([.82,.84,.86,.85])translate([0,0,92])lid();color([.95,.55,.05,.9])translate([145,10,28])bridge();color([.95,.65,.12,.9])translate([-115,25,18])rotate([90,0,0])beta_cap();color([1,.82,0,.95])translate([150,85,12])badge();color([.45,.65,.95,.9])translate([-70,110,8])gasket_jig();}
module layout(){color([.76,.78,.8,.18])base();mocks();}
module printset(){base();translate([L+12,0,0])lid();translate([4,W+12,0])bridge();translate([L+20,W+12,0])rotate([90,0,0])beta_cap();translate([L+20,W+62,0])gasket_jig();translate([4,W+58,0])badge();}

if(part=="base")base();
else if(part=="lid")lid();
else if(part=="service_bridge")bridge();
else if(part=="beta_cap")beta_cap();
else if(part=="rear_badge")badge();
else if(part=="gasket_jig")gasket_jig();
else if(part=="exploded")exploded();
else if(part=="layout")layout();
else if(part=="printset")printset();
else assembly();
