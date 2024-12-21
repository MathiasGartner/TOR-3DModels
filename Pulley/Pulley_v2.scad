$fa=3;
$fs=0.05;
p = 0.01;
p2 = 2*p;

use_nut = true;
use_nut_hex = false;
add_hole_for_wire = true;

pulley_h = 11.5; //height of spindle
pulley_r = 13.5; //outer radius

ramp_flat_r = 7; //INFO: this is the diameter of the pully for the cords
ramp_before_flat_r = ramp_flat_r + 1.9;
ramp_r = pulley_r;
ramp_flat_width = 1.2; //width of the area for the wire
ramp_h_offset_top = 0.2;
ramp_h = 9;
ramp_h_offset_bottom = pulley_h - ramp_h - ramp_h_offset_top;
ramp_h_offset = pulley_h - ramp_h;

//trapezoid that gets rotation-extruded and subtracted from the pulley cylinder
ramp_poly = [[ramp_r + p, 0],
             [ramp_r + p, ramp_h],
             [ramp_before_flat_r, ramp_h/2+ramp_flat_width/2],
             [ramp_flat_r, ramp_h/2+ramp_flat_width/2],
             [ramp_flat_r, ramp_h/2-ramp_flat_width/2],
             [ramp_before_flat_r, ramp_h/2-ramp_flat_width/2]
            ];
             

echo(ramp_flat_r);
echo("u=", 2 * ramp_flat_r * PI);

fix_h = 5.5;
fix_r = 9.2;

hole_h = pulley_h + fix_h;
hole_d = 5.2; //for motor shaft
hole_cut = 0.5;

hole_screw_h = fix_r;
hole_screw_d = 3.3;

nut_h = 2.5;
nut_d = 6.2;
nut_h_in = (fix_r - hole_d/2)/2 + nut_h/2;
nut_sq_m = 2;
nut_sq_s = 5.6;

rope_hole_r = 1.1;

//hull
h_w = 1;
h_p = 0.4; //spacing between pulley and hull
h_wp = h_w + h_p;
h_r_inner = fix_r + 1;
h_r_outer = pulley_r + h_wp + 0.5;
h_bottom_extra = 0.0;
h_h1 = pulley_h + 2*h_wp + 3*h_p + 0.8;
//h_screw_length = 8+2;
h_h2 = pulley_h + fix_h + 2.5; echo("h_h2", h_h2);
h_wire_distance = 1.5;
h_ramp_outer = h_w + 2*h_p + ramp_h_offset/2;
h_ramp_inner = h_w + 2*h_p + ramp_h_offset;
r_screw_top = 5.5;
h_w_extra = 0.8*0;
h_screw_d = 3.3;

hull_poly = [[0, -h_w_extra], 
             [h_r_outer, -h_w_extra], 
             [h_r_outer, h_h2 - 1.4],
             [h_r_outer + r_screw_top + 0.5, h_h2 - 1.4],
             [h_r_outer + r_screw_top + 0.5, h_h2 + h_w + 1],
             [h_r_inner, h_h2 + h_w + 1],
             [h_r_inner, h_h2 + 1],
             [h_r_inner+2.2, h_h2 + 1],
             [h_r_inner+2.2, h_h2],
             [pulley_r + h_p + 0.3, h_h2],
             [pulley_r + h_p + 0.3, h_h1 - h_ramp_outer - 3*h_p],
             [ramp_before_flat_r + h_p + h_wire_distance, ramp_h_offset_bottom + ramp_h/2 + 2*h_p + h_wp],
             [ramp_before_flat_r + h_p + h_wire_distance, ramp_h_offset_bottom + ramp_h/2 + h_wp],
             [pulley_r + h_p + 0.3, h_ramp_outer + 2*h_p + 0.8],
             [pulley_r + h_p + 0.3, h_w - h_w_extra],
             [0, h_w - h_w_extra]
            ];

module hole(h, d) {
    cylinder(h+p2, d=d, center=true);
}

module hull(hullOnLeft=true) {
    echo("hull: ", h_r_outer + r_screw_top/2);
    hull_angle = 180;
    difference() {        
        translate([0, 0, -h_wp-h_p])
        rotate_extrude(angle=hull_angle)
        polygon(hull_poly);       
        // - (hullOnLeft ? 0.0 : 0.2): is an empiric value to fit the motor bracket        
        screw_center = 17.95;
        rotate([0, 0, hull_angle/4*1])
        //translate([h_r_outer + r_screw_top/2 - (hullOnLeft ? 0.0 : 0.2), 0, h_h2])
        translate([screw_center, 0, h_h2])
        hole(8, h_screw_d);
        rotate([0, 0, hull_angle/4*3])
        //translate([h_r_outer + r_screw_top/2 - (hullOnLeft ? 0.2 : 0.0), 0, h_h2])
        translate([screw_center, 0, h_h2])
        hole(8, h_screw_d);
        motor_hole_distance_from_center = 31 * sqrt(2) / 2;
        //holes in motor mount have to be left out
        rotate([0, 0, hullOnLeft ? -20 : 20]) {
            for (i = [0:3]) {
                //(i == 1 ? 2 : 0) * (hullOnLeft ? +1 : -1): is an empiric value to fit the motor bracket
                rotate([0, 0, i*90 + (i == 1 ? 0.8 : 0) * (hullOnLeft ? +1 : -1)])
                translate([motor_hole_distance_from_center, 0, h_h2])
                hole(8, r_screw_top+1.2);
            }
        }
    }
}

module pulley() {
    union() {
        difference() {
            union() {
                difference() {
                    translate([0, 0, pulley_h/2])
                    cylinder(pulley_h, r=pulley_r, center=true);
                            
                    translate([0, 0, ramp_h_offset_bottom])
                    rotate_extrude(angle=360)
                    polygon(ramp_poly);
                }

                difference() {
                    //fix on top
                    translate([0, 0, pulley_h + fix_h/2])
                    cylinder(fix_h, r=fix_r, center=true);
                                    
                    if (use_nut) {
                        if (use_nut_hex) {
                            translate([0, -nut_h/2-nut_h_in, pulley_h + fix_h/2 + nut_d/2])
                            cube([nut_d, nut_h, nut_d], center=true);
                            
                            translate([0, -nut_h/2-nut_h_in, pulley_h + fix_h/2])
                            rotate([90, 0, 0])
                            cylinder(nut_h, d=nut_d, center=true, $fn=4);
                        }
                        else {
                            translate([0, -nut_sq_m/2-nut_h_in, pulley_h + fix_h/2])
                            cube([nut_sq_s, nut_sq_m, nut_sq_s], center=true);
                            
                        }
                    }
                    //hole for screw
                    translate([0, -(hole_screw_h/2), pulley_h + fix_h/2])
                    rotate([90, 0, 0])
                    cylinder(hole_screw_h+p, d=hole_screw_d, center=true);
                }
            }
            //hole for motor mount
            translate([0, 0, hole_h/2])
            cylinder(hole_h+p2, d=hole_d, center=true);            
            //hole for wire
            //INFO: hard coded position
            if (add_hole_for_wire) {
                color("red")
                rotate([0, 0, 18])
                translate([0, -fix_r-rope_hole_r-0.05, pulley_h])
                rotate([19, 0, 0])
                cylinder(h=ramp_h+1, r=rope_hole_r, center=true);
            }
        }
        //top fill
        translate([0, 0, pulley_h])
        rotate([0, 0, -90+25])
        rotate_extrude(angle = 310) {
            translate([fix_r, 0, 0])
            square([pulley_r-fix_r, fix_h]);
        }
        
        //bottom
        cylinder(1, r=pulley_r/2);
        
        //D-shaft
        shaft_h = pulley_h + (fix_h - hole_screw_d)/2 - p;
        shaft_t = 0.5;
        translate([0, -hole_d/2, shaft_h/2])
        cube([hole_d, 2*shaft_t, shaft_h], center=true);
    }
}

cut_h = ramp_h_offset_bottom + ramp_h/2 + ramp_flat_width/2 - p;
in_h = 2.0;
in_diff = 0.05;
in_diff_angle = 0.8;
in_sq_h = 2;
in_sq_d = 2.2;
angleOffset = [-45, 225, 60];
angleWidth = [60, -60, 60];

*mirror([0, 0, 1])
translate([0, 0, -pulley_h-fix_h])
difference() {
    pulley();
    union() {
        translate([0, 0, -p])
        cylinder(cut_h+p2, r=pulley_r+p);
        translate([0, 0, cut_h])
        cylinder(in_h, r=ramp_flat_r+in_diff);
        translate([0, 0, cut_h + in_h - p])
        for (i = [0:2]) {
            rotate([0, 0, angleOffset[i]-in_diff_angle])
            rotate_extrude(angle=angleWidth[i]+in_diff_angle*2)
            translate([ramp_flat_r-in_sq_d-in_diff, 0, 0])
            square([in_sq_d+in_diff*2, in_sq_h+in_diff]);
        }
    }
}

*translate([40, 0, 0])
union() {
    difference() {    
        pulley();
        translate([0, 0, cut_h])
        cylinder(pulley_h+fix_h, r=pulley_r+p);
    }
    difference() {
        translate([0, 0, cut_h])
        cylinder(in_h, r=ramp_flat_r);
        //hole for motor mount
        translate([0, 0, hole_h/2])
        cylinder(hole_h+p2, d=hole_d, center=true);
    }
    //D-shaft
    shaft_h = cut_h + in_h;
    shaft_t = 0.5;
    translate([0, -hole_d/2, shaft_h/2])
    cube([hole_d, 2*shaft_t, shaft_h], center=true);
    
    translate([0, 0, cut_h + in_h - p])
    for (i = [0:2]) {
        rotate([0, 0, angleOffset[i]])
        rotate_extrude(angle=angleWidth[i])
        translate([ramp_flat_r-in_sq_d, 0, 0])
        square([in_sq_d, in_sq_h]);
    }
}

//Hull_L
color("red")
hull();

color("green", 0.5)
pulley();

//Hull_R
translate([0, 30, 0])
color("red")
hull(false);

