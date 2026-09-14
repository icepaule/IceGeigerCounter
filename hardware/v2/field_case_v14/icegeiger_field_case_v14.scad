/*
 IceGeiger V2 Field Case v1.4 - integrated 2x18650 Battery Shield
 Standalone OpenSCAD, no external libraries.

 Designed around:
 - GC-1602-NANO seller envelope: 108 x 65 x 47 mm (mount holes still generic pads)
 - HITT/Heltec Wireless Tracker V1.2: 65.84 x 28 x 14.71 mm
 - 2x18650 Battery Shield (measured): 100.2 x 48.0 mm
 - underside shield component clearance: 5 mm
 - user-requested 5 x 5 mm solid mounting rails on both short shield edges
 - 2x Samsung INR18650-25R cells
 - microSD SPI module envelope: 21 x 18 x 12 mm
 - removable beta window cap and 2 mm silicone cord lid seal

 part options:
 "assembly", "base", "lid", "service_bridge", "beta_cap", "gasket_jig", "printset", "layout"
*/
$fn=64;
part="assembly";

// ---------- Main enclosure ----------
case_l=130;
case_w=132;
base_h=58;
lid_t=4.2;
wall=2.6;
floor_t=2.8;
corner_r=5;

divider_y=72;
divider_t=2.2;

// Lid seal: 2 mm silicone cord, ~22.5% compression
seal_groove_w=2.45;
seal_groove_d=1.55;
seal_offset=4.4;

// Eight M3 lid fasteners / heat-set inserts
m3_clear=3.35;
insert_d=4.6;
insert_depth=5.2;
lug_r=5.2;
lug_centers=[
 [0,10],[0,122],[130,10],[130,122],
 [10,0],[120,0],[10,132],[120,132]
];

// ---------- GC-1602-NANO ----------
// Seller envelope / current design reference; exact delivered hole positions can be drilled into broad pads.
gc_l=108;
gc_w=65;
gc_h=47;
gc_x=11;
gc_y=4.5;
gc_z=4.5;

// broad 12 x 12 mm pads under the four PCB corners; no pre-drilled holes -> drill through actual PCB holes
gc_pad=12;

// display opening based on product geometry / previous v1.2 layout
gc_lcd_x=29;
gc_lcd_y=15;
gc_lcd_l=80;
gc_lcd_w=26;

// Geiger tube / beta window reservation
tube_l=90;
tube_d=10;
tube_x=20;
tube_y=7.2;
tube_z=13;

beta_x=17;
beta_l=96;
beta_z=6.5;
beta_h=18;
beta_frame=3;
beta_recess=1.1;
beta_cap_t=3;

// ---------- 2x18650 Battery Shield ----------
// Measured by user from actual module photos.
shield_l=100.2;
shield_w=48.0;
shield_pcb_t=1.6;
shield_bottom_component=5.0;

// 5 mm mounting rail on each short edge; board + rails are centered in case length.
shield_end_rail=5.0;
shield_mount_envelope=shield_l+2*shield_end_rail;
shield_rail_x=(case_l-shield_mount_envelope)/2;   // 9.9 mm
shield_x=shield_rail_x+shield_end_rail;            // 14.9 mm PCB start
shield_y=78.0;

// Board bottom at 9 mm gives 1.2 mm clearance below the 5 mm underside component above 2.8 mm floor.
shield_board_z=9.0;
shield_rail_h=5.0;
shield_rail_z=shield_board_z-shield_rail_h;
shield_plinth_h=shield_rail_z-floor_t;

// Approximate 18650 positions for collision / GNSS keepout visualization only.
cell_d=18.3;
cell_l=64.85;
cell_x=shield_x+15;
cell_y1=shield_y+13.2;
cell_y2=shield_y+34.8;
cell_z=shield_board_z+shield_pcb_t+cell_d/2;

// ---------- Removable service bridge ----------
// Bridge is supported at extreme left/right, outside the Battery Shield footprint.
bridge_x=5.5;
bridge_y=96.0;
bridge_l=119.0;
bridge_w=31.0;
bridge_z=33.0;
bridge_t=2.4;
bridge_post_r=2.7;
bridge_hole_d=3.2;
bridge_posts=[[6.2,100.5],[6.2,122.5],[123.8,100.5],[123.8,122.5]];

// ---------- HITT / Heltec Wireless Tracker V1.2 ----------
tracker_l=65.84;
tracker_w=28.0;
tracker_h=14.71;
tracker_pin_drop=6.10;
tracker_top_above_pcb=tracker_h-tracker_pin_drop;
tracker_x=54.0;
tracker_y=97.5;
tracker_pcb_z=40.0;

// Front geometry estimated from actual delivered board/photo.
tracker_display_rel_x=12.0;
tracker_display_rel_y=4.0;
tracker_display_l=32.0;
tracker_display_w=20.0;
tracker_display_x=tracker_x+tracker_display_rel_x;
tracker_display_y=tracker_y+tracker_display_rel_y;

// GNSS patch antenna is on the right-hand end of the delivered board.
gnss_rel_x=44.0;
gnss_rel_y=2.5;
gnss_l=21.5;
gnss_w=23.0;
gnss_x=tracker_x+gnss_rel_x;
gnss_y=tracker_y+gnss_rel_y;

// ---------- microSD ----------
microsd_l=21;
microsd_w=18;
microsd_h=12;
microsd_x=11;
microsd_y=100;
microsd_z=bridge_z+bridge_t+1.5;

// ---------- External interfaces ----------
sma_hole_d=6.5;
sma_x=103;
sma_z=45;
// SMA on rear wall (y = case_w)

switch_hole_d=12.2;
switch_x=28;
switch_z=40;
// M12 optional main switch on rear wall

// ---------- Helpers ----------
module rrect2(l,w,r){
    hull(){
        for(x=[r,l-r]) for(y=[r,w-r]) translate([x,y]) circle(r=r);
    }
}
module rbox(l,w,h,r){ linear_extrude(height=h) rrect2(l,w,r); }
module body_lugs(h){ for(c=lug_centers) translate([c[0],c[1],0]) cylinder(r=lug_r,h=h); }
module outer_body(h){ union(){ rbox(case_l,case_w,h,corner_r); body_lugs(h); } }
module inner_void(z0=0,h=100){
    translate([wall,wall,z0]) rbox(case_l-2*wall,case_w-2*wall,h,max(1,corner_r-wall));
}
module gasket_groove(){
    difference(){
        translate([seal_offset,seal_offset,base_h-seal_groove_d])
            rbox(case_l-2*seal_offset,case_w-2*seal_offset,seal_groove_d+0.2,corner_r-seal_offset/2);
        translate([seal_offset+seal_groove_w,seal_offset+seal_groove_w,base_h-seal_groove_d-0.1])
            rbox(case_l-2*(seal_offset+seal_groove_w),case_w-2*(seal_offset+seal_groove_w),seal_groove_d+0.4,max(0.8,corner_r-seal_offset/2-seal_groove_w));
    }
}
module base_insert_pockets(){
    for(c=lug_centers)
        translate([c[0],c[1],base_h-insert_depth]) cylinder(d=insert_d,h=insert_depth+0.5);
}
module lid_screw_holes(){
    for(c=lug_centers) translate([c[0],c[1],-0.5]) cylinder(d=m3_clear,h=lid_t+1);
}

// ---------- Mounting geometry ----------
module gc_support_pads(){
    // Broad solid pads. Place PCB, mark/drill pilot hole through actual PCB mounting holes.
    for(p=[
        [gc_x,gc_y],
        [gc_x+gc_l-gc_pad,gc_y],
        [gc_x,gc_y+gc_w-gc_pad],
        [gc_x+gc_l-gc_pad,gc_y+gc_w-gc_pad]
    ])
        translate([p[0],p[1],floor_t]) cube([gc_pad,gc_pad,max(0.8,gc_z-floor_t)]);
}

module shield_mount_rails(){
    // Thin connected plinth + requested 5 x 5 mm thread-bearing rail on each short edge.
    for(x=[shield_rail_x, shield_x+shield_l]){
        if(shield_plinth_h>0)
            translate([x-1.5,shield_y,floor_t]) cube([shield_end_rail+3,shield_w,shield_plinth_h]);
        translate([x,shield_y,shield_rail_z]) cube([shield_end_rail,shield_w,shield_rail_h]);
    }
}

module bridge_posts_base(){
    for(p=bridge_posts)
        translate([p[0],p[1],floor_t])
            difference(){
                cylinder(r=bridge_post_r,h=bridge_z-floor_t);
                translate([0,0,bridge_z-floor_t-7]) cylinder(d=2.6,h=7.5);
            }
}

module bridge_holes(){
    for(p=bridge_posts)
        translate([p[0]-bridge_x,p[1]-bridge_y,-0.4]) cylinder(d=bridge_hole_d,h=bridge_t+1);
}

// ---------- Beta window ----------
module beta_wall_opening(){ translate([beta_x,-1,beta_z]) cube([beta_l,wall+2,beta_h]); }
module beta_membrane_recess(){
    translate([beta_x-beta_frame,-0.05,beta_z-beta_frame])
        cube([beta_l+2*beta_frame,beta_recess+0.1,beta_h+2*beta_frame]);
}
module beta_insert_holes(){
    for(x=[beta_x-beta_frame+1.5,beta_x+beta_l+beta_frame-1.5])
        translate([x,wall+0.1,beta_z+beta_h/2]) rotate([90,0,0]) cylinder(d=insert_d,h=wall+0.2);
}

// ---------- Base ----------
module base(){
    difference(){
        union(){
            difference(){ outer_body(base_h); inner_void(floor_t,base_h+2); }
            translate([wall,divider_y,floor_t]) cube([case_l-2*wall,divider_t,base_h-floor_t-4]);
            gc_support_pads();
            shield_mount_rails();
            bridge_posts_base();
        }
        gasket_groove();
        base_insert_pockets();
        beta_wall_opening();
        beta_membrane_recess();
        beta_insert_holes();
        // rear-wall LoRa SMA bulkhead
        translate([sma_x,case_w+0.5,sma_z]) rotate([90,0,0]) cylinder(d=sma_hole_d,h=wall+2);
        // optional waterproof M12 switch on rear wall
        translate([switch_x,case_w+0.5,switch_z]) rotate([90,0,0]) cylinder(d=switch_hole_d,h=wall+2);
    }
}

// ---------- Lid ----------
module lid(){
    difference(){
        union(){
            outer_body(lid_t);
            // small sealing tongue entering the cord-gasket area
            translate([seal_offset+0.25,seal_offset+0.25,-0.4])
                difference(){
                    rbox(case_l-2*(seal_offset+0.25),case_w-2*(seal_offset+0.25),0.8,corner_r-seal_offset/2);
                    translate([seal_groove_w-0.15,seal_groove_w-0.15,-0.1])
                        rbox(case_l-2*(seal_offset+seal_groove_w+0.10),case_w-2*(seal_offset+seal_groove_w+0.10),1,max(0.8,corner_r-seal_offset/2-seal_groove_w));
                }
        }
        lid_screw_holes();
        // GC 1602 LCD window + internal rebate for 1 mm polycarbonate
        translate([gc_lcd_x,gc_lcd_y,-1]) cube([gc_lcd_l,gc_lcd_w,lid_t+2]);
        translate([gc_lcd_x-3,gc_lcd_y-3,-0.1]) cube([gc_lcd_l+6,gc_lcd_w+6,1.2]);
        // Tracker TFT window + rebate
        translate([tracker_display_x,tracker_display_y,-1]) cube([tracker_display_l,tracker_display_w,lid_t+2]);
        translate([tracker_display_x-3,tracker_display_y-3,-0.1]) cube([tracker_display_l+6,tracker_display_w+6,1.2]);
    }
}

// ---------- Removable service bridge ----------
module service_bridge(){
    difference(){
        union(){
            // lightweight perimeter frame
            difference(){
                rbox(bridge_l,bridge_w,bridge_t,2.2);
                translate([4,4,-0.2]) cube([bridge_l-8,bridge_w-8,bridge_t+0.4]);
            }
            // two transverse ribs connect the accessory mounts to the outer frame
            translate([4,6,0]) cube([bridge_l-8,3,bridge_t]);
            translate([4,bridge_w-9,0]) cube([bridge_l-8,3,bridge_t]);
            // tracker support ledges / pads (right side)
            translate([tracker_x-bridge_x-2,tracker_y-bridge_y-1,bridge_t]) cube([tracker_l+4,3,3.2]);
            translate([tracker_x-bridge_x-2,tracker_y-bridge_y+tracker_w-2,bridge_t]) cube([tracker_l+4,3,3.2]);
            // microSD tray (left side), tied into the ribs/frame
            translate([microsd_x-bridge_x-1,microsd_y-bridge_y-1,bridge_t]) cube([microsd_l+2,2.0,3.0]);
            translate([microsd_x-bridge_x-1,microsd_y-bridge_y+microsd_w-1,bridge_t]) cube([microsd_l+2,2.0,3.0]);
        }
        bridge_holes();
        // two long clearances for already-soldered tracker header pins
        translate([tracker_x-bridge_x-1,tracker_y-bridge_y-1,-0.2]) cube([tracker_l+2,4.0,bridge_t+0.4]);
        translate([tracker_x-bridge_x-1,tracker_y-bridge_y+tracker_w-3,-0.2]) cube([tracker_l+2,4.0,bridge_t+0.4]);
        // GNSS no-metal/open area beneath patch antenna
        translate([gnss_x-bridge_x-2,gnss_y-bridge_y-2,-0.2]) cube([gnss_l+4,gnss_w+4,bridge_t+0.4]);
    }
}

// ---------- Beta cap ----------
module beta_cap(){
    cap_l=beta_l+2*beta_frame+2;
    cap_h=beta_h+2*beta_frame+2;
    difference(){
        union(){
            cube([cap_l,beta_cap_t,cap_h]);
            translate([1,beta_cap_t,1]) cube([cap_l-2,1,cap_h-2]);
        }
        // fastener holes at each end
        for(x=[2.5,cap_l-2.5])
            translate([x,-0.5,cap_h/2]) rotate([-90,0,0]) cylinder(d=m3_clear,h=beta_cap_t+2);
    }
}

module gasket_jig(){
    difference(){
        cube([36,36,6]);
        translate([7,7,6-seal_groove_d])
            difference(){
                cube([22,22,seal_groove_d+0.2]);
                translate([seal_groove_w,seal_groove_w,-0.1])
                    cube([22-2*seal_groove_w,22-2*seal_groove_w,seal_groove_d+0.4]);
            }
    }
}

// ---------- Mock components for fit visualization ----------
module mock_gc(){
    color([0.05,0.35,0.65,0.40]) translate([gc_x,gc_y,gc_z]) cube([gc_l,gc_w,gc_h]);
    color("black") translate([gc_lcd_x,gc_lcd_y,gc_z+28]) cube([gc_lcd_l,gc_lcd_w,10]);
    color("dimgray") translate([tube_x,tube_y,tube_z]) rotate([0,90,0]) cylinder(d=tube_d,h=tube_l);
}
module mock_shield(){
    // 5 mm underside component envelope
    color([0.25,0.25,0.25,0.45]) translate([shield_x+55,shield_y+4,shield_board_z-shield_bottom_component]) cube([22,14,shield_bottom_component]);
    color([0.05,0.1,0.12,0.50]) translate([shield_x,shield_y,shield_board_z]) cube([shield_l,shield_w,shield_pcb_t]);
    for(yc=[cell_y1,cell_y2])
        color([0.1,0.55,0.25,0.72]) translate([cell_x,yc,cell_z]) rotate([0,90,0]) cylinder(d=cell_d,h=cell_l);
}
module mock_tracker(){
    color([0.04,0.04,0.04,0.70]) translate([tracker_x,tracker_y,tracker_pcb_z]) cube([tracker_l,tracker_w,1.6]);
    // header pins downward
    color([0.75,0.75,0.75,0.65]) translate([tracker_x,tracker_y,tracker_pcb_z-tracker_pin_drop]) cube([tracker_l,2,tracker_pin_drop]);
    color([0.75,0.75,0.75,0.65]) translate([tracker_x,tracker_y+tracker_w-2,tracker_pcb_z-tracker_pin_drop]) cube([tracker_l,2,tracker_pin_drop]);
    color("deepskyblue") translate([tracker_display_x,tracker_display_y,tracker_pcb_z+1.6]) cube([tracker_display_l,tracker_display_w,5]);
    color("lightgray") translate([gnss_x,gnss_y,tracker_pcb_z+1.6]) cube([gnss_l,gnss_w,7]);
}
module mock_sd(){ color("darkgreen") translate([microsd_x,microsd_y,microsd_z]) cube([microsd_l,microsd_w,microsd_h]); }
module mock_bridge(){ color([0.95,0.55,0.05,0.75]) translate([bridge_x,bridge_y,bridge_z]) service_bridge(); }

module assembly(lid_raise=0){
    color([0.76,0.78,0.80,0.40]) base();
    mock_gc();
    mock_shield();
    mock_bridge();
    mock_tracker();
    mock_sd();
    color([0.82,0.84,0.86,0.52]) translate([0,0,base_h+lid_raise]) lid();
    color([0.95,0.65,0.12,0.85]) translate([beta_x-beta_frame-1,-beta_cap_t-1,beta_z-beta_frame-1]) beta_cap();
}
module layout(){
    color([0.76,0.78,0.80,0.18]) base();
    mock_gc(); mock_shield(); mock_bridge(); mock_tracker(); mock_sd();
}

// One STL that places all printable parts on a ~270 x 250 mm plate.
// For smaller beds, export individual parts instead.
module printset(){
    base();
    translate([case_l+12,0,0]) lid();
    translate([4,case_w+12,0]) service_bridge();
    translate([case_l+20,case_w+12,0]) rotate([90,0,0]) beta_cap();
    translate([case_l+20,case_w+62,0]) gasket_jig();
}

if(part=="base") base();
else if(part=="lid") lid();
else if(part=="service_bridge") service_bridge();
else if(part=="beta_cap") beta_cap();
else if(part=="gasket_jig") gasket_jig();
else if(part=="printset") printset();
else if(part=="layout") layout();
else if(part=="exploded") assembly(28);
else assembly(0);
