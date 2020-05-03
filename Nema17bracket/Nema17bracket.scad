$fn=400;
p = 0.05;
p2 = 2*p;
px = 1;

th = 3;
md = 3;
bottom_a = 65;
bottom_b = 50;
bottom_h = th;

bottom_hole_pad = 4;
bha = bottom_a / 2 - bottom_hole_pad;
bhb = bottom_b / 2 - bottom_hole_pad;

holder_a = 42;
holder_b = 42;
holder_h = th*2;
holder_spacing = 22;

holder_hole_pad = 5;
hha = holder_a / 2 - holder_hole_pad;
hhb = holder_b / 2 - holder_hole_pad;

tr2_a = holder_a;
tr2_b = bottom_b;
tr2_c = th;

tr1_a = (bottom_a - holder_a) / 2 - tr2_c;
tr1_b = tr2_a*0.65;
tr1_c = th;

module hole(h = th, d = md) {
    cylinder(h+p2, d=d, center=true);
}

module triangle(a, b, h) {    
    linear_extrude(height=h)
    polygon(points=[[0,0],[a,0],[0,b]], paths=[[0,1,2]]);
}

module bracket() {
    translate([0, 0, bottom_h/2])
    difference() {
        cube([bottom_a, bottom_b, bottom_h], center=true);
        translate([bha, bhb, 0])
        hole();
        translate([-bha, bhb, 0])
        hole();
        translate([bha, -bhb, 0])
        hole();
        translate([-bha, -bhb, 0])
        hole();
    };

    translate([0, -10, 0]) {
        translate([bottom_a/2-tr1_a, tr1_c/2, bottom_h])
        rotate([90, 0, 0])
        triangle(tr1_a, tr1_b, tr1_c);
        mirror([1, 0, 0])
        translate([bottom_a/2-tr1_a, tr1_c/2, bottom_h])
        rotate([90, 0, 0])
        triangle(tr1_a, tr1_b, tr1_c);
    }

    translate([bottom_a/2-tr1_a, -tr2_b/2, bottom_h])
    rotate([0, -90, 0])
    triangle(tr2_a, tr2_b, tr2_c);
    mirror([1, 0, 0])
    translate([bottom_a/2-tr1_a, -tr2_b/2, bottom_h])
    rotate([0, -90, 0])
    triangle(tr2_a, tr2_b, tr2_c);


    translate([0, -bottom_b/2+holder_h/2, holder_a/2+bottom_h])
    rotate([90, 0, 0])
    difference() {
        cube([holder_a, holder_b, holder_h], center=true);
        translate([hha, hhb, 0])
        hole(h=holder_h);
        translate([-hha, hhb, 0])
        hole(h=holder_h);
        translate([hha, -hhb, 0])
        hole(h=holder_h);
        translate([-hha, -hhb, 0])
        hole(h=holder_h);
        translate([0, holder_spacing/2+p, 0])
        cube([holder_spacing, 2*holder_spacing, holder_h+p2], center=true);
    };
};

union() {
    bracket();
    translate([1*(bottom_a-2*bottom_hole_pad), 0, 0])
    bracket();
    translate([2*(bottom_a-2*bottom_hole_pad), 0, 0])
    bracket();
    translate([3*(bottom_a-2*bottom_hole_pad), 0, 0])
    bracket();
};










