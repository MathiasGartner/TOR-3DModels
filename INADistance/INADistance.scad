$fa=3;
$fs=0.05;
p = 0.01;
p2 = 2*p;

h = 6;
d1 = 2.3;
d2 = 4.0;

difference() {
    cylinder(h, d=d2);
    translate([0, 0, -p])
    cylinder(h + p2, d=d1);
}
