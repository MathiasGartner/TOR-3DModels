$fa=6;
$fs=0.05;
p = 0.01;
p2 = 2*p;

//45N
/*
a = 20; //diameter of magnet
b = 25; //height of magnet
c = 4.5; //hole for screw
cable_r = 2.5; //radius for cable hole
top_offset = 3.7; //inner radius for top (screw has to fit in)
screw_head_height = 5.0; //height of the screw head
//*/

//120N
/*
a = 25;
b = 29;
c = 4.5;
cable_r = 2.5;
top_offset = 3.7;
screw_head_height = 5.0;
//*/

//180N
//*
a = 32;
b = 29;
c = 5.5;
cable_r = 3.5;
top_offset = 5.2;
screw_head_height = 5.0;
//*/

//300N
/*
a = 35;
b = 29;
c = 5.5;
cable_r = 3.5;
top_offset = 5.2;
screw_head_height = 5.0;
//*/

inner_h = b;
inner_r = a/2+0.2;
t_side = 2;
t_top = 4;
outer_h = inner_h + t_top;
outer_r = inner_r + t_side;

top_count = 4;
top_angle = 80;
top_a = 2;
top_h = 8;
top_hh = 5;
top_ring_h = 2;
top_ring_r1 = top_offset;
top_ring_r2 = top_ring_r1 + top_a;
top_angle_t = 20;
top_h_t = 3;
top_down_angle = 1 * top_angle_t;
top_side_angle = 1 * top_angle_t;
top_up_angle = top_angle_t;
top_down_h = 3 * top_h_t;
top_side_h = top_h_t;
top_up_h = 1.5 * top_h_t;
top_fix_offset = screw_head_height + 0.5;
top_total_h = top_down_h + top_fix_offset;

cord_h = top_down_h;
cord_hole_r = 1.0;
angle_diff = 1;
h_diff = 0.5;

module cyl(h, r, addP2 = false) {
    translate([0, 0, h/2])
    cylinder(h + (addP2 ? p2 : 0), r=r, center=true);
}

//case for magnet
module magnet() {
    difference() { 
        translate([0, 0, inner_h])
        cyl(t_top, outer_r);
        translate([0, 0, inner_h])
        cyl(t_top, c/2, true);
        translate([inner_r, 0, inner_h])
        cyl(t_top, cable_r, true);
    }
    difference() {
        cyl(outer_h, outer_r);
        cyl(outer_h, inner_r, true);
    }
}

//mount that is fixed on magnet case with screw
module top_fix() {
    difference() {
        cyl(top_total_h, top_ring_r2);
        cyl(top_total_h, top_ring_r1, true);
        translate([0, 0, top_fix_offset])
        for(i=[1:top_count]) {
            rotate(i*360/top_count) {
                rotate_extrude(angle=top_down_angle)
                square([top_ring_r2+p2, top_down_h+p]);
                rotate(top_down_angle-p)
                rotate_extrude(angle=top_side_angle)
                square([top_ring_r2+p2, top_side_h]);
                rotate(top_down_angle + top_side_angle - p2)
                rotate_extrude(angle=top_up_angle)
                square([top_ring_r2+p2, top_up_h]);
            }
        }
    }
}

//bottom for top_fix if printed without magnet case
module top_bottom() {
    difference() {
        cyl(top_ring_h, top_ring_r2, false);
        cyl(top_ring_h+p, c/2, true);
    }
}

//holder for cords that is mounted in top fix
module top_cords() {
    difference() {
        union() {
            cyl(cord_h, top_ring_r1);
            for(i=[1:top_count]) {
                rotate(i*360/top_count) {
                    rotate_extrude(angle=top_up_angle-angle_diff)
                    square([top_ring_r2+p2, top_up_h-h_diff]);
                }
            }
        }
        cyl(top_total_h, cord_hole_r, true);
    }
}

translate([20, 0, 0])
top_cords();

translate([0, -30, 0])
magnet();

//magnet case with top fix
translate([0, 30, 0])
union() {
    magnet();
    translate([0, 0, outer_h])
    top_fix();   
}

union() {
    top_bottom();
    translate([0, 0, top_ring_h])
    top_fix();
}