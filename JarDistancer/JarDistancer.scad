$fa=6;
$fs=0.075;
p = 0.05;
p2 = 2*p;

bottom_d = 68; //diameter of bottom cylinder
bottom_h = 3; //height of bottom cylinder
hole_d = 3; //diameter of holes in bottom
hole_count = 5; //number of holes in one direction
rod_d = 5; //diameter of the rod
rod_h = 70 - bottom_h; //height of the rod

hole_spacing = bottom_d / (hole_count - 1);
rod_pos = (bottom_d / 2) / 3;

module hole(h, d = hole_d) {
    cylinder(h+p2, d=d, center=true);
}

union() {
    translate([0, 0, bottom_h/2])
    difference() {
        cylinder(bottom_h, d=bottom_d, center=true);
        translate([-(bottom_d)/2, -(bottom_d)/2, 0])
        for (i = [0:hole_count-1]) {
            for (j = [0:hole_count-1]) {
                translate([i * hole_spacing, j * hole_spacing, 0])
                hole(bottom_h);
            }
        }    
    }    
    translate([0, 0, rod_h/2]) {
        translate([-rod_pos, -rod_pos, 0])
        cylinder(rod_h, d=rod_d, center=true);
        translate([-rod_pos, rod_pos, 0])
        cylinder(rod_h, d=rod_d, center=true);
        translate([rod_pos, -rod_pos, 0])
        cylinder(rod_h, d=rod_d, center=true);
        translate([rod_pos, rod_pos, 0])
        cylinder(rod_h, d=rod_d, center=true);
    }
}