$fa=2;
$fs=0.03;
p = 0.05;
p2 = 2*p;

size = 20;
hole_d = 18;
hole_extra = 0.5;
sphere_factor = 1.35;

module infill_pattern() {
    t = 2.0; //thickness of lines
    s = 8.0; //spacing between lines
    w = t + s;
    c = size / w - (size / w) % 1;
    echo(c);
    d = (c + 1) * t + c * s; 
    translate(-[d/2, d/2, d/2])
    union() {
        for (i=[0:c]) {
            for (j=[0:c]) {
                translate([i*w, j*w, 0])
                cube([t, t, d]);            
                translate([i*w, 0, j*w])
                cube([t, d, t]);            
                translate([0, i*w, j*w])
                cube([d, t, t]);
            }
        }
    }
}

module dice(dice_size=20, half=false, hole=false) {
    rotate([180, 0, 0])
    difference() {
        intersection() {
            cube(dice_size, center=true);
            sphere(dice_size/2*sphere_factor);
        }
        if (hole) {
            sphere((hole_d + hole_extra)/2);
        }
        if (half) {
            translate([0, 0, dice_size/2])
            cube(dice_size + p2, center=true);
        }
    }
}

module dice_and_infill() {
    w = 2; //thickness of wall
    union() {
        intersection() {    
            $fn = 40;  
            dice(dice_size = size - 1);
            infill_pattern();
        }
        difference() {
            dice(dice_size = size, half=false);
            dice(dice_size = size - w);
        }
    }
}

*dice(half=true);
*translate([dice_size + 10, 0, 0])
dice(half=true);

*dice(half=false);

dice_and_infill();

*infill_pattern();
