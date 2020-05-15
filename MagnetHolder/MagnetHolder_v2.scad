$fa=3;
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
t_side = 3;
t_top = 3;
outer_h = inner_h + t_top;
outer_r = inner_r + t_side;
echo(outer_h);

top_count = 4;
top_angle = 80;
top_a = 2.5;
top_h = 8;
top_hh = 5;
top_ring_h = 2;
top_ring_r1 = top_offset;
top_ring_r2 = top_ring_r1 + top_a;
top_angle_t = 18;
top_h_t = 3;
top_down_angle = 1 * top_angle_t;
top_side_angle = 1 * top_angle_t;
top_up_angle = 1 * top_angle_t;
top_down_h = 2.5 * top_h_t;
top_side_h = top_h_t;
top_up_h = 1.3 * top_h_t;
top_fix_offset = screw_head_height + 1;
top_total_h = top_down_h + top_fix_offset;

cord_h = top_down_h - (top_up_h - top_side_h);
cord_hole_single_r = 1.0;
cord_hole_multi_r = 0.7;
angle_diff = 2;
h_diff = 0.5;
single_hole = false;
multi_hole_offset = 1.0;
mhs = multi_hole_offset;

top_bottom_h = 1.0;

module cyl(h, r, addP2 = false) {
    translate([0, 0, h/2])
    cylinder(h + (addP2 ? p2 : 0), r=r, center=true);
}

module magnet_fix_hole(d, t, angle) {
    extra = 1;
    translate([sin(angle), -cos(angle), 0]*(inner_r - extra))
    rotate([90, 0, angle])
    cyl(t + extra, d/2+0.1);
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
        h1 = 7;
        h2 = 25;
        for(i=[0:2]) {
            translate([0, 0, h1])
            magnet_fix_hole(6, 1, 270+(i-1)*22);
            translate([0, 0, h2])
            magnet_fix_hole(6, 1, 270+(i-1)*22);
        }
        translate([0, 0, h1])
        magnet_fix_hole(5, 1.5, 90);
        translate([0, 0, h2])
        magnet_fix_hole(5, 1.5, 90);
        translate([0, 0, h1])
        magnet_fix_hole(2, 5, 90);
        translate([0, 0, h2])
        magnet_fix_hole(2, 5, 90);
        translate([0, 0, h1])
        magnet_fix_hole(8, 1, 75);
        translate([0, 0, h2])
        magnet_fix_hole(8, 1, 75);
        *translate([0, 0, 10]) {
            for(i=[0:5]) {
                translate([0, 0, -5])
                magnet_fix_hole(3, 1, i*12);
            }
            for(i=[0:4]) {
                translate([0, 0, 5])
                magnet_fix_hole(4, 1, i*15+90);
            }
            for(i=[0:3]) {
                translate([0, 0, -5])
                magnet_fix_hole(5, 1, i*19+180);
            }
            for(i=[0:3]) {
                translate([0, 0, 5])
                magnet_fix_hole(6, 1, i*22+270);
            }
        }
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
        cyl(top_bottom_h, top_ring_r2, false);
        cyl(top_bottom_h+p, c/2, true);
    }
}

//holder for cords that is mounted in top fix
module top_cords() {
    difference() {
        union() {
            cyl(cord_h, top_ring_r1-0.1);
            rotate(-(top_up_angle-angle_diff) / 2)
            for(i=[1:top_count]) {
                rotate(i*360/top_count) {
                    rotate_extrude(angle=top_up_angle-angle_diff)
                    square([top_ring_r2+p2, top_side_h-h_diff]);
                }
            }
        }
        if (single_hole) {
            cyl(top_total_h, cord_hole_single_r * 2, true);
        }
        else {
            translate([mhs, mhs, 0])
            cyl(top_total_h, cord_hole_multi_r, true);
            translate([mhs, -mhs, 0])
            cyl(top_total_h, cord_hole_multi_r, true);
            translate([-mhs, mhs, 0])
            cyl(top_total_h, cord_hole_multi_r, true);
            translate([-mhs, -mhs, 0])
            cyl(top_total_h, cord_hole_multi_r, true);
        }
    }
}

*translate([20, 0, 0])
top_cords();

//translate([0, -30, 0])
magnet();

//magnet case with top fix
*translate([0, 30, 0])
union() {
    magnet();
    translate([0, 0, outer_h])
    top_fix();   
}

*union() {
    top_bottom();
    translate([0, 0, top_bottom_h])
    top_fix();
}