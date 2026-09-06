/* IceGeiger V2 enclosure — PRELIMINARY, no external libraries.
   Verify all dimensions after delivery before final print. */
$fn=48; part="assembly"; // base|lid|service_cover|fit_jig|assembly|exploded|layout
// Measurements to verify
gc_l=108; gc_w=65; gc_t=1.6; gc_clear_below=13; lcd_x=19; lcd_y=17; lcd_l=80; lcd_w=26;
heltec_l=65.5; heltec_w=28.5; cell_d=18.8; cell_l=70;
wall=2.4; floor_t=2.6; lid_t=2.4; case_l=172; case_w=82; base_h=52; corner_r=5; service_x=120;
module r2(l,w,r){hull(){for(x=[r,l-r])for(y=[r,w-r])translate([x,y])circle(r=r);}}
module rb(l,w,h,r){linear_extrude(h)r2(l,w,r);}
module shell(){difference(){rb(case_l,case_w,base_h,corner_r);translate([wall,wall,floor_t])rb(case_l-2*wall,case_w-2*wall,base_h+2,max(1,corner_r-wall));}}
module gc_supports(){for(x=[7,107])for(y=[7,71])translate([x,y,floor_t])cube([8,4,gc_clear_below-floor_t]);}
module batteries(){for(cx=[132,154]){translate([cx-cell_d/2-1.5,5,floor_t])cube([3,cell_l,9]);translate([cx+cell_d/2-1.5,5,floor_t])cube([3,cell_l,9]);}}
module controller_posts(){for(p=[[128,8],[152,8],[128,69],[152,69]])translate([p[0],p[1],floor_t])cube([4,4,31]);}
module base(){union(){shell();gc_supports();batteries();controller_posts();translate([service_x,wall,floor_t])cube([2.4,case_w-2*wall,base_h-7]);}}
module lid(){difference(){rb(case_l,case_w,lid_t,corner_r);translate([23,20,-1])cube([lcd_l+6,lcd_w+6,lid_t+2]);translate([service_x+4,6,-1])cube([43,70,lid_t+2]);for(yy=[10:5:30])translate([92,yy,-1])cube([17,2,lid_t+2]);}}
module service_cover(){difference(){cube([43,70,lid_t]);translate([28,-1,-1])cube([12,7,5]);for(y=[12:8:60])translate([6,y,-1])cube([31,2,5]);}}
module fit_jig(){difference(){cube([30,gc_w+8,10]);translate([3,4,3])cube([30,gc_w,3]);}}
module mock(){color("blue")translate([7,7,17])cube([gc_l,gc_w,gc_t]);color("green")translate([26,24,22])cube([80,26,3]);for(cx=[132,154])color("seagreen")translate([cx,6,13])rotate([-90,0,0])cylinder(d=cell_d,h=cell_l);color("navy")translate([128,8,34])cube([heltec_w,heltec_l,2]);}
module assembly(z=0){color([.75,.75,.78,.55])base();mock();color([.8,.8,.83,.55])translate([0,0,base_h+z])lid();color([.85,.85,.87,.7])translate([0,0,base_h+z+0.2])service_cover();}
if(part=="base")base(); else if(part=="lid")lid(); else if(part=="service_cover")service_cover(); else if(part=="fit_jig")fit_jig(); else if(part=="exploded")assembly(30); else if(part=="layout"){base();mock();} else assembly();
