// IceGeiger rear badge v1.5.2 - ACE two-color version
// Standalone OpenSCAD, no external libraries.
$fn=72;
part=is_undef(part)?"two_color_preview":part;

badge_l=78;
badge_h=24;
badge_t=1.20;
badge_raise=0.90;
badge_embed=0.40;

function ap(r,a1,a2,n=18)=[for(i=[0:n])[r*cos(a1+(a2-a1)*i/n),r*sin(a1+(a2-a1)*i/n)]];
module sector(r1,r2,a1,a2,n=18){
 polygon(concat(ap(r2,a1,a2,n),[for(i=[n:-1:0])[r1*cos(a1+(a2-a1)*i/n),r1*sin(a1+(a2-a1)*i/n)]]));
}
module trefoil(){
 union(){
  circle(r=2.7);
  for(a=[90,210,330])rotate(a)sector(5.3,11.2,-28,28);
 }
}
module artwork_2d(){
 union(){
  translate([-badge_l/2+15,0])trefoil();
  translate([10,0])text("IceDrone",size=7.2,halign="center",valign="center",font="Liberation Sans:style=Bold");
 }
}
module badge_outline_2d(){offset(r=1.2)square([badge_l-2.4,badge_h-2.4],center=true);}

// ACE color 1, recommended black. The top contains a 0.40 mm artwork pocket.
module badge_base(){
 difference(){
  linear_extrude(height=badge_t)badge_outline_2d();
  translate([0,0,badge_t-badge_embed])linear_extrude(height=badge_embed+0.05)artwork_2d();
 }
}

// ACE color 2, recommended yellow. Bottom 0.40 mm keys into the base;
// the remaining 0.90 mm is visibly raised above the base.
module badge_logo_text(){
 translate([0,0,badge_t-badge_embed])linear_extrude(height=badge_embed+badge_raise)artwork_2d();
}

module badge_one_color(){union(){badge_base();badge_logo_text();}}
module two_color_preview(){
 color([0.05,0.05,0.05])badge_base();
 color([1.0,0.78,0.0])badge_logo_text();
}

if(part=="base")badge_base();
else if(part=="logo_text")badge_logo_text();
else if(part=="one_color")badge_one_color();
else two_color_preview();
