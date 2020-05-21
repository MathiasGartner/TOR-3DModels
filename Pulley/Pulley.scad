$fa=3;
$fs=0.05;
p = 0.01;
p2 = 2*p;

hole_flat = false;
use_hex = true;
add_hole_for_wire = false;

pulley_h = 11.5; //height of spindle
pulley_r = 14; //outer radius

ramp_flat_r = 7; //INFO: this is the diameter of the pully
ramp_r = pulley_r;
ramp_h_offset = 2;
ramp_flat_width = 3.0; //width of the area for the wire
ramp_h = pulley_h - ramp_h_offset;
ramp_poly = [[ramp_r + p,0],
             [ramp_r + p, ramp_h],
             [ramp_flat_r, ramp_h/2+ramp_flat_width/2],
             [ramp_flat_r, ramp_h/2-ramp_flat_width/2]];
             //trapezoid that gets rotation-extruded and subtracted from the pulley cylinder

echo(ramp_flat_r);
echo("u=", 2 * ramp_flat_r * PI);

fix_h = 5.5;
fix_r = 9;

hole_h = pulley_h + (hole_flat ? 0 : fix_h);
hole_d = 5.2;
hole_cut = 0.5;

hole_screw_h = fix_r;
hole_screw_d = 3;

hex_h = 2.5;
hex_d = 6.2;
hex_h_in = (fix_r - hole_d/2)/2 + hex_h/2;

rope_hole_r = 0.4;

//hull
h_w = 1;
h_p = 0.2; //spacing between pulley and hull
h_wp = h_w + h_p;
h_r_inner = fix_r + 1;
h_r_outer = pulley_r + h_wp;
h_h1 = pulley_h + 2*h_wp;
//h_screw_length = 8+2;
h_h2 = pulley_h + fix_h + 1;
h_wire_distance = 2;
h_ramp_outer = h_w + 2*h_p + ramp_h_offset/2;
h_ramp_inner = h_w + 2*h_p + ramp_h_offset;
r_screw_top = 5.5;

hull_poly = [[0, 0], 
             [h_r_outer, 0], 
             [h_r_outer, h_h1], 
             //[h_r_inner + h_w, h_h1],
             //[h_r_inner + h_w, h_h2],
             [h_r_outer, h_h2 - 2],
             [h_r_outer + r_screw_top, h_h2 - 2],
             [h_r_outer + r_screw_top, h_h2 + h_w],
             //[h_r_outer, h_h2],
             [h_r_outer, h_h2 + h_w],
             [h_r_inner, h_h2 + h_w],
             [h_r_inner, h_h1 - h_w],
             [pulley_r + h_p, h_h1 - h_w],
             [pulley_r + h_p, h_h1 - h_ramp_outer],
             [ramp_flat_r + h_wire_distance, ramp_h/2+ramp_flat_width+1.2],
             [ramp_flat_r + h_wire_distance, ramp_h/2+0.1],
             [pulley_r + h_p, h_ramp_outer],
             [pulley_r + h_p, h_w],
             [0, h_w]
            ];

module hole(h, d) {
    cylinder(h+p2, d=d, center=true);
}

module hull() {
    hull_angle = 180;
    difference() {        
        translate([0, 0, -h_wp])
        rotate_extrude(angle=hull_angle)
        polygon(hull_poly);       
        rotate([0, 0, hull_angle/4*1])
        translate([h_r_outer + r_screw_top/2, 0, h_h2])
        hole(8, 3); 
        rotate([0, 0, hull_angle/4*3])
        translate([h_r_outer + r_screw_top/2, 0, h_h2])
        hole(8, 3);
        motor_hole_distance_from_center = 31 * sqrt(2) / 2;
        //holes in motor mount have to be left out
        rotate([0, 0, -20]) {
            for (i = [0:3]) {
                rotate([0, 0, i*90])
                translate([motor_hole_distance_from_center, 0, h_h2])
                hole(8, 5);
            }
        }
    }
}

module pulley() {
    difference() {
        union() {
            difference() {
                translate([0, 0, pulley_h/2])
                cylinder(pulley_h, r=pulley_r, center=true);
                        
                translate([0, 0, ramp_h_offset/2])
                rotate_extrude(angle=360)
                polygon(ramp_poly);
            }

            if (!hole_flat) {
                difference() {
                    translate([0, 0, pulley_h + fix_h/2])
                    cylinder(fix_h, r=fix_r, center=true);
                                    
                    if (use_hex) {
                        translate([0, -hex_h/2-hex_h_in, pulley_h + fix_h/2 + hex_d/2])
                        cube([hex_d, hex_h, hex_d], center=true);
                        
                        translate([0, -hex_h/2-hex_h_in, pulley_h + fix_h/2])
                        rotate([90, 0, 0])
                        cylinder(hex_h, d=hex_d, center=true, $fn=6);
                    }

                    translate([0, -(hole_screw_h/2), pulley_h + fix_h/2])
                    rotate([90, 0, 0])
                    cylinder(hole_screw_h+p, d=hole_screw_d, center=true);
                }
            }
        }
        //hole for motor mount
        difference() {
            translate([0, 0, hole_h/2])
            cylinder(hole_h+p2, d=hole_d, center=true);
            if (hole_flat) {
                translate([hole_d-hole_cut, 0, pulley_h/2])
                cube([hole_d, hole_d, pulley_h+2*p2], center=true);
            }
        }
        //INFO: hard coded position
        if (add_hole_for_wire) {
            translate([0, -5, 0])
            rotate([42, 0, 0])
            cylinder(h=2*pulley_h+p2-2, r=rope_hole_r, center=true);
        }
    }
}

*pulley();

color("red")
hull();

*union() {
    pulley();
    translate([0, 0, 0.5])
    cylinder(1, r=pulley_r, center=true);
}