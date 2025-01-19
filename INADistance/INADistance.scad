$fa=3;
$fs=0.05;
p = 0.01;
p2 = 2*p;

h = 6;
h_no_epoxy = 6.5;
d1 = 2.3;
d2 = 4.0;

*difference() {
    cylinder(h, d=d2);
    translate([0, 0, -p])
    cylinder(h + p2, d=d1);
}

//no epoxy
difference() {
    cylinder(h_no_epoxy , d=d2);
    translate([0, 0, -p])
    cylinder(h_no_epoxy  + p2, d=d1);
}

