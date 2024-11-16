$fa=3;
$fs=0.05;
p = 0.01;
p2 = 2*p;

hole_x = 23;
hole_y = 58;
hole_diag = sqrt(hole_x*hole_x + hole_y*hole_y);

h_hole = 3.6;
h_cross = 1.8;

hole_d = 2.8;
hole_d_out = 6.5;

w = (hole_d_out - hole_d)/2;

phi_add = 4.27;
phi = acos(hole_x/hole_diag) + phi_add;
length_diag_add = 2.9;
length_diag = hole_diag - hole_d + length_diag_add ;

module mount() {    
    difference() {
        cylinder(h=h_hole, d=hole_d_out);
        translate([0, 0, -p])
        cylinder(h=h_hole+p2, d=hole_d);
    }
}

union() {
    translate([hole_x/2, hole_y/2, 0])
    mount();
    translate([hole_x/2, -hole_y/2, 0])
    mount();
    translate([-hole_x/2, hole_y/2, 0])
    mount();
    translate([-hole_x/2, -hole_y/2, 0])
    mount();
    
    rotate([0, 0, phi])
    translate([-length_diag/2, -w/2, 0])
    cube([length_diag, w, h_cross]);
    rotate([0, 0, -phi])
    translate([-length_diag/2, -w/2, 0])
    cube([length_diag, w, h_cross]);
}