/* IceGeiger V2 Field Case for GC-1602-NANO + HITT/Heltec Wireless Tracker V1.2
   PRELIMINARY GC-1602 geometry. No external libraries. */
$fn=64; part="assembly";

// GC-1602 seller envelope; exact holes/tube centre pending delivery
gc_l=108; gc_w=65; gc_h=47; gc_pcb_t=1.6; gc_x=6; gc_y=4; gc_z=4.3;
gc_lcd_x=24; gc_lcd_y=15; gc_lcd_l=80; gc_lcd_w=26;
tube_l=90; tube_d=10; tube_x=15; tube_z=13;

// Delivered HITT-Tracker V1.2 drawing/photo envelope
tracker_l=65.84; tracker_w=28; tracker_h=14.71; tracker_x=6; tracker_y=80;
tracker_shelf_z=28.5; tracker_pcb_z=tracker_shelf_z+2.6;
tracker_display_x=29; tracker_display_y=83; tracker_display_l=34; tracker_display_w=20;
gnss_keepout_x=6; gnss_keepout_y=80; gnss_keepout_l=22; gnss_keepout_w=24;

// 2x INR18650-25R parallel holder
battery_holder_l=76; battery_holder_w=40.5; battery_holder_h=20;
battery_x=39; battery_y=75.5; battery_z=3;

// service-module envelopes
microsd_l=21; microsd_w=4; microsd_h=18; microsd_x=78; microsd_y=114; microsd_z=26;
boost_l=12.5; boost_w=5; boost_h=9.5; boost_x=83; boost_y=72.8; boost_z=27;
bms_l=32; bms_w=4; bms_h=8; bms_x=46; bms_y=72.8; bms_z=27;

case_l=120; case_w=120; base_h=54; lid_t=4.2; wall=2.6; floor_t=2.8; corner_r=5;
divider_y=71; divider_t=2.2;
seal_groove_w=2.45; seal_groove_d=1.55; seal_offset=4.4;
m3_clear=3.35; insert_d=4.6; insert_depth=5.2; lug_r=5.2;
lug_centers=[[0,10],[0,110],[120,10],[120,110],[10,0],[110,0],[10,120],[110,120]];

// beta window + removable cap
beta_x=11; beta_l=98; beta_z=6.5; beta_h=18; beta_recess=1.1; beta_frame=3;
beta_cap_t=3; beta_cap_screw_dx=4.5;

sma_hole_d=6.5; sma_y=96; sma_z=42;
switch_hole_d=12.2; switch_x=104; switch_z=36;

module rrect2(l,w,r){hull(){for(x=[r,l-r])for(y=[r,w-r])translate([x,y])circle(r=r);}}
module rbox(l,w,h,r){linear_extrude(height=h)rrect2(l,w,r);}
module body_lugs(h){for(c=lug_centers)translate([c[0],c[1],0])cylinder(r=lug_r,h=h);}
module outer_body(h){union(){rbox(case_l,case_w,h,corner_r);body_lugs(h);}}
module inner_void(z0=0,h=100){translate([wall,wall,z0])rbox(case_l-2*wall,case_w-2*wall,h,max(1,corner_r-wall));}
module gasket_groove(){difference(){translate([seal_offset,seal_offset,base_h-seal_groove_d])rbox(case_l-2*seal_offset,case_w-2*seal_offset,seal_groove_d+0.2,corner_r-seal_offset/2);translate([seal_offset+seal_groove_w,seal_offset+seal_groove_w,base_h-seal_groove_d-0.1])rbox(case_l-2*(seal_offset+seal_groove_w),case_w-2*(seal_offset+seal_groove_w),seal_groove_d+0.4,max(0.8,corner_r-seal_offset/2-seal_groove_w));}}
module base_insert_pockets(){for(c=lug_centers)translate([c[0],c[1],base_h-insert_depth])cylinder(d=insert_d,h=insert_depth+0.5);}
module lid_screw_holes(){for(c=lug_centers)translate([c[0],c[1],-0.5])cylinder(d=m3_clear,h=lid_t+1);}

module gc_posts(){post_h=gc_z-floor_t;for(p=[[gc_x+3.8,gc_y+3.8],[gc_x+gc_l-3.8,gc_y+3.8],[gc_x+3.8,gc_y+gc_w-3.8],[gc_x+gc_l-3.8,gc_y+gc_w-3.8]])translate([p[0],p[1],floor_t-0.25])difference(){cylinder(d=7,h=post_h+0.25);translate([0,0,-0.2])cylinder(d=2.7,h=post_h+0.7);}}
module tracker_support_posts(){for(p=[[tracker_x,tracker_y],[tracker_x+tracker_l+3,tracker_y],[tracker_x,tracker_y+tracker_w+3],[tracker_x+tracker_l+3,tracker_y+tracker_w+3]])translate([p[0],p[1],floor_t])cube([3.2,3.2,tracker_shelf_z-floor_t]);}
module service_mounts(){translate([microsd_x-1.8,microsd_y-2,microsd_z-2])cube([microsd_l+3.6,2,3]);translate([bms_x-1,divider_y+divider_t,bms_z-1])cube([bms_l+2,2,2.5]);translate([boost_x-1,divider_y+divider_t,boost_z-1])cube([boost_l+2,2,2.5]);}

module beta_wall_opening(){translate([beta_x,-1,beta_z])cube([beta_l,wall+2,beta_h]);}
module beta_membrane_recess(){translate([beta_x-beta_frame,-0.05,beta_z-beta_frame])cube([beta_l+2*beta_frame,beta_recess+0.1,beta_h+2*beta_frame]);}
module beta_insert_holes(){for(x=[beta_x-beta_cap_screw_dx,beta_x+beta_l+beta_cap_screw_dx])translate([x,wall+0.1,beta_z+beta_h/2])rotate([90,0,0])cylinder(d=insert_d,h=wall+0.2);}

module base(){difference(){union(){difference(){outer_body(base_h);inner_void(floor_t,base_h+2);}translate([wall,divider_y,floor_t])cube([case_l-2*wall,divider_t,base_h-floor_t-4]);gc_posts();tracker_support_posts();service_mounts();}gasket_groove();base_insert_pockets();beta_wall_opening();beta_membrane_recess();beta_insert_holes();translate([case_l+0.5,sma_y,sma_z])rotate([0,90,0])cylinder(d=sma_hole_d,h=wall+2);translate([switch_x,case_w+0.5,switch_z])rotate([90,0,0])cylinder(d=switch_hole_d,h=wall+2);}}

module lid(){difference(){union(){outer_body(lid_t);translate([seal_offset+0.25,seal_offset+0.25,-0.4])difference(){rbox(case_l-2*(seal_offset+0.25),case_w-2*(seal_offset+0.25),0.8,corner_r-seal_offset/2);translate([seal_groove_w-0.15,seal_groove_w-0.15,-0.1])rbox(case_l-2*(seal_offset+seal_groove_w+0.10),case_w-2*(seal_offset+seal_groove_w+0.10),1,max(0.8,corner_r-seal_offset/2-seal_groove_w));}}lid_screw_holes();translate([gc_lcd_x,gc_lcd_y,-1])cube([gc_lcd_l,gc_lcd_w,lid_t+2]);translate([gc_lcd_x-3,gc_lcd_y-3,-0.1])cube([gc_lcd_l+6,gc_lcd_w+6,1.2]);translate([tracker_display_x,tracker_display_y,-1])cube([tracker_display_l,tracker_display_w,lid_t+2]);translate([tracker_display_x-3,tracker_display_y-3,-0.1])cube([tracker_display_l+6,tracker_display_w+6,1.2]);}}

module tracker_shelf(){ol=tracker_l+4.8;ow=tracker_w+4.8;rail=2.6;difference(){rbox(ol,ow,2.4,2);translate([rail,rail,-0.2])cube([ol-2*rail,ow-2*rail,3]);}translate([0,0,2.4])cube([ol,1.5,2]);translate([0,ow-1.5,2.4])cube([ol,1.5,2]);translate([0,0,2.4])cube([1.5,ow,2]);}
module beta_cap(){cap_l=beta_l+2*beta_frame+2;cap_h=beta_h+2*beta_frame+2;difference(){union(){cube([cap_l,beta_cap_t,cap_h]);translate([1,beta_cap_t,1])cube([cap_l-2,1,cap_h-2]);}for(x=[beta_frame-beta_cap_screw_dx+1,cap_l-beta_frame+beta_cap_screw_dx-1])translate([x,-0.5,cap_h/2])rotate([-90,0,0])cylinder(d=m3_clear,h=beta_cap_t+2);}}
module gasket_jig(){difference(){cube([36,36,6]);translate([7,7,6-seal_groove_d])difference(){cube([22,22,seal_groove_d+0.2]);translate([seal_groove_w,seal_groove_w,-0.1])cube([22-2*seal_groove_w,22-2*seal_groove_w,seal_groove_d+0.4]);}}}
module fit_jig(){difference(){cube([84,48,33]);translate([3,3,3])cube([78,42,32]);}translate([3,3,3])cube([76,2,20]);translate([3,43,3])cube([76,2,20]);translate([3,4,25])cube([70,2,2.4]);}

module mock_gc(){color("steelblue")translate([gc_x,gc_y,gc_z])cube([gc_l,gc_w,gc_pcb_t]);color("green")translate([gc_lcd_x-1,gc_lcd_y-1,gc_z+18])cube([84,30,1.6]);color("black")translate([gc_lcd_x+1,gc_lcd_y+1,gc_z+20])cube([80,26,10]);color("dimgray")translate([tube_x,gc_y+3,tube_z])rotate([0,90,0])cylinder(d=tube_d,h=tube_l);}
module mock_batteries(){for(i=[0:1])color("seagreen")translate([battery_x+4,battery_y+10+i*19,battery_z+9.2])rotate([0,90,0])cylinder(d=18.3,h=64.85);color([.1,.1,.1,.35])translate([battery_x,battery_y,battery_z])cube([battery_holder_l,battery_holder_w,battery_holder_h]);}
module mock_tracker(){color("black")translate([tracker_x,tracker_y,tracker_pcb_z])cube([tracker_l,tracker_w,1.6]);color("deepskyblue")translate([tracker_display_x,tracker_display_y,tracker_pcb_z+1.6])cube([tracker_display_l,tracker_display_w,5]);color("lightgray")translate([gnss_keepout_x+1,gnss_keepout_y+1,tracker_pcb_z+1.6])cube([20,20,6.5]);color([.65,.65,.65,.4])translate([tracker_x,tracker_y,tracker_pcb_z-6.1])cube([tracker_l,2,6.1]);color([.65,.65,.65,.4])translate([tracker_x,tracker_y+tracker_w-2,tracker_pcb_z-6.1])cube([tracker_l,2,6.1]);}
module mock_service(){mock_batteries();mock_tracker();color("darkgreen")translate([microsd_x,microsd_y,microsd_z])cube([microsd_l,microsd_w,microsd_h]);color("darkorange")translate([boost_x,boost_y,boost_z])cube([boost_l,boost_w,boost_h]);color("gray")translate([bms_x,bms_y,bms_z])cube([bms_l,bms_w,bms_h]);color([.2,.8,.8,.12])translate([gnss_keepout_x,gnss_keepout_y,floor_t])cube([gnss_keepout_l,gnss_keepout_w,base_h-floor_t]);}
module mock_shelf_in_place(){color("orange")translate([tracker_x-2.4,tracker_y-2.4,tracker_shelf_z])tracker_shelf();}
module assembly(lid_raise=0){color([.76,.78,.80,.45])base();mock_gc();mock_service();mock_shelf_in_place();color([.82,.84,.86,.55])translate([0,0,base_h+lid_raise])lid();color([.9,.65,.15,.8])translate([beta_x-beta_frame-1,-beta_cap_t-1,beta_z-beta_frame-1])beta_cap();}
module layout(){color([.76,.78,.80,.20])base();mock_gc();mock_service();mock_shelf_in_place();}
module beta_detail(){color([.76,.78,.80,.35])base();color("dimgray")translate([tube_x,gc_y+3,tube_z])rotate([0,90,0])cylinder(d=tube_d,h=tube_l);color([.9,.65,.15,.85])translate([beta_x-beta_frame-1,-beta_cap_t-5,beta_z-beta_frame-1])beta_cap();}

if(part=="base")base();else if(part=="lid")lid();else if(part=="tracker_shelf")tracker_shelf();else if(part=="beta_cap")beta_cap();else if(part=="gasket_jig")gasket_jig();else if(part=="fit_jig")fit_jig();else if(part=="exploded")assembly(28);else if(part=="layout")layout();else if(part=="beta_detail")beta_detail();else assembly(0);
