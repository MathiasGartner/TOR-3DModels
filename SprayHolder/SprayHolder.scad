$fa=6;
$fs=0.05;
p = 0.01;
p2 = 2*p;

a = 80;
b = 80;
t = 2;

aa = a/3;

top_a = 10;
top_b = 10;
top_h = 50;

r = 1;
r_h = top_h * 2 / 3;

module holder() {
    difference() {
        translate([0, 0, top_h/2])
        cube([top_a, top_b, top_h], center=true);
        translate([0, 0, r_h])
        rotate([0, 90, 0])
        cylinder(h=top_a+p2, d=2*r, center=true);
    }
}

translate([0, 0, t/2])
cube([a, b, t], center=true);
translate([-aa, 0, 0])
holder();
translate([aa, 0, 0])
holder();