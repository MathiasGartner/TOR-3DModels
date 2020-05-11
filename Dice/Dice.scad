$fa=2;
$fs=0.03;
p = 0.05;
p2 = 2*p;

dice_size = 18;
hole_d = 15;
hole_extra = 0.5;
sphere_factor = 1.35;

module half_dice() {
    rotate([180, 0, 0])
    difference() {
        intersection() {
            cube(dice_size, center=true);
            sphere(dice_size/2*sphere_factor);
        }
        sphere((hole_d + hole_extra)/2);
        translate([0, 0, dice_size/2])
        cube(dice_size + p2, center=true);
    }
}

half_dice();
translate([dice_size + 10, 0, 0])
half_dice();