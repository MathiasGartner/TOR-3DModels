$fa=2;
$fs=0.03;
p = 0.05;
p2 = 2*p;

dice_size = 20;
hole_d = 15;
hole_extra = 0.5;
sphere_factor = 1.35;

module dice(half) {
    rotate([180, 0, 0])
    difference() {
        intersection() {
            cube(dice_size, center=true);
            sphere(dice_size/2*sphere_factor);
        }
        *sphere((hole_d + hole_extra)/2);
        if (half) {
            translate([0, 0, dice_size/2])
            cube(dice_size + p2, center=true);
        }
    }
}

*dice(half=true);
*translate([dice_size + 10, 0, 0])
dice(half=true);

dice(half=false);