$fn=400;
p = 0.05;
p2 = 2*p;
px = 1;

//45N
/*
a = 20; //diameter of magnet
b = 25; //height of magnet
c = 4.5; //hole for screw
cable_r = 2.5; //radius for cable hole
top_offset = 3.7; //inner radius for top (screw has to fit in)
//*/

//120N
/*
a = 25;
b = 29;
c = 4.5;
cable_r = 2.5;
top_offset = 3.7;
//*/

//180N
//*
a = 32;
b = 29;
c = 5.5;
cable_r = 3.5;
top_offset = 5.2;
//*/

//300N
/*
a = 35;
b = 29;
c = 5.5;
cable_r = 3.5;
top_offset = 5.2;
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

module cyl(h, r, addP2 = false) {
    translate([0, 0, h/2])
    cylinder(h + (addP2 ? p2 : 0), r=r, center=true);
}

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

module holder() {
    translate([0, 0, outer_h])
    rotate(-top_angle/2)
    for(i=[1:top_count]) {
        rotate(i*360/top_count)
        rotate_extrude(angle=top_angle)
        translate([top_offset, 0, 0])
        square([top_a, top_h]);
    }


    translate([0, 0, outer_h + top_hh])
    difference() {
        cyl(top_ring_h, top_ring_r2);
        cyl(top_ring_h, top_ring_r1, true);
    }
}

module holder_bottom() {
    translate([0, 0, outer_h])
    difference() {
        cyl(top_ring_h, top_ring_r2, false);
        cyl(top_ring_h+p, c/2, true);
    }
}

union() {
    magnet();
    holder();   
    //holder_bottom();
}

