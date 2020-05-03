$fn=400;
p = 0.05;
p2 = 2*p;
px = 1;

a = 25;
b = 20;

hole_a = 3;
hole_h = 10;

neo_a = 10;
neo_h = 3.7;
neo_n = 3;
neo_hh = neo_n * neo_h;

module hole(h, d) {
    cylinder(h+p2, d=d, center=true);
}

difference() {
    translate([0, 0, b/2])
    cylinder(b, d=a, center=true);
    translate([0, 0, a-hole_h])
    cylinder(hole_h+p2, d=hole_a, center=true);
    translate([0, 0, neo_hh/2])
    cube([neo_a, neo_a, neo_hh+p2], center=true);
};