$fa=6;
$fs=0.075;
p = 0.05;
p2 = 2*p;

dice_size = 20;
sphere_factor = 1.4;
hole_d = 15;
hole_extra = 0.3;

difference() {
    intersection() {
        cube(dice_size, center=true);
        sphere(dice_size/2*sphere_factor);
    }
    sphere((hole_d + hole_extra)/2);
    translate([0, 0, dice_size/2])
    cube(dice_size + p2, center=true);
}