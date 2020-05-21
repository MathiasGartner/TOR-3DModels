$fa=3;
$fs=0.05;
p = 0.01;
p2 = 2*p;

//nema 11
/*
th = 3; //default thickness of areas
tht = 5; //default thickness of thick areas
md = 3; //default hole diameter for screws
sw_min = 6; //minimal needed spacing for mounting screws
sw = sw_min + 1; //spacing for mounting screws

m_w = 28.2; //motor width;
m_h = 28.2; //motor height;
m_t = 31.5; //motor thickness;
mount_distance = 23; //distance between mounting holes
mount_circle_inset = 2; //additional height of the circle around the motor shaft
mount_circle_inset_d = 22; //diameter of the circle around the motor shaft
mount_hole_d = 6;
//*/

//nema 14 flat
/*
th = 3;
tht = 5;
md = 3;
sw_min = 6;
sw = sw_min + 1;

m_w = 35.2;
m_h = 35.2;
m_t = 20;
mount_distance = 26;
mount_circle_inset = 2;
mount_circle_inset_d = 22;
mount_hole_d = 6;
//*/

//nema 17
//*
th = 3;
tht = 5;
md = 3;
sw_min = 6;
sw = sw_min + 1;

m_w = 42.3;
m_h = 42.3;
m_t = 39;
mount_distance = 31;
mount_circle_inset = 2.2;
mount_circle_inset_d = 22.5;
mount_hole_d = 6;
//*/

bottom_a = m_w + 2 * th + 2 * sw;
bottom_b = m_t + tht;
bottom_h = th;

bottom_hole_pad = sw / 2;
bha = bottom_a / 2 - bottom_hole_pad;
bhb = bottom_b / 2 - bottom_hole_pad;

holder_a = m_w;
holder_b = m_h;
holder_h = tht;

holder_hole_pad = (m_w - mount_distance) / 2;
hha = holder_a / 2 - holder_hole_pad;
hhb = holder_b / 2 - holder_hole_pad;

tr2_a = holder_a;
tr2_b = bottom_b - tht;
tr2_c = th;

//support for side triangles
tr1_a = (bottom_a - holder_a) / 2 - tr2_c;
tr1_b = tr2_a*0.65;
tr1_c = th;
tr1_position = bottom_b / 5;

sq_hole_a = 5.5;
sq_hole_h = 2;

module hole(h = th, d = md) {
    cylinder(h+p2, d=d, center=true);
}

module sq_hole(a = sq_hole_a, h = sq_hole_h) {
    cube([a, a, h+p2], center=true);
}

module triangle(a, b, h) {    
    linear_extrude(height=h)
    polygon(points=[[0,0],[a,0],[0,b]], paths=[[0,1,2]]);
}

module motorMount() {
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
        cylinder(h=tht+p2, d=mount_hole_d, center=true);
        translate([0, 0, -tht/2+mount_circle_inset/2-p])
        cylinder(h=mount_circle_inset, d=mount_circle_inset_d+0.5, center=true);
        hull_hole_distance = mount_distance/2 / sqrt(2);
        hull_angle = 180;
        nut_sq_m = 2;
        nut_sq_s = 5.6;
        rotate([0, 0, 180-20 + hull_angle/4*1])
        translate([hull_hole_distance, hull_hole_distance, -(holder_h/2+p)+nut_sq_m/2]) {        
            hole(h=holder_h*2);
            cube([nut_sq_s, nut_sq_s, nut_sq_m], center=true);
        }
        rotate([0, 0, 180-20 + hull_angle/4*3])
        translate([hull_hole_distance, hull_hole_distance, -(holder_h/2+p)+nut_sq_m/2]) {        
            hole(h=holder_h*2);
            cube([nut_sq_s, nut_sq_s, nut_sq_m], center=true);
        }
    };
}

module bracket(hasStabilizerLeft=true, hasStabilizerRight=true) {
    //bottom
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

    //support for side triangles
    translate([0, -tr1_position, 0]) {
        if (hasStabilizerLeft) {
            translate([bottom_a/2-tr1_a, tr1_c/2, bottom_h])
            rotate([90, 0, 0])
            triangle(tr1_a, tr1_b, tr1_c);
        }
        if (hasStabilizerRight) {
            mirror([1, 0, 0])
            translate([bottom_a/2-tr1_a, tr1_c/2, bottom_h])
            rotate([90, 0, 0])
            triangle(tr1_a, tr1_b, tr1_c);
        }
    }

    translate([bottom_a/2-tr1_a, -(tr2_b-tht)/2, bottom_h])
    rotate([0, -90, 0])
    union() {
        triangle(tr2_a, tr2_b, tr2_c);
        translate([0, -tht, 0])
        cube([tr2_a, tht, th]);
    }    
    mirror([1, 0, 0])
    translate([bottom_a/2-tr1_a, -(tr2_b-tht)/2, bottom_h])
    rotate([0, -90, 0])
    union() {
        triangle(tr2_a, tr2_b, tr2_c);
        translate([0, -tht, 0])
        cube([tr2_a, tht, th]);
    }

    //motor mount
    translate([0, -bottom_b/2+holder_h/2, holder_a/2+bottom_h])
    rotate([90, 0, 0])
    motorMount();
};

module bracketWihtoutSide() {
    //bottom
    bha = m_w / 2 - bottom_hole_pad;
    
    translate([0, 0, bottom_h/2])
    difference() {
        cube([m_w, bottom_b, bottom_h], center=true);
        translate([hha, hhb, 0]) {
            hole();
            translate([0, 0, sq_hole_h/2])
            sq_hole();
        }
        translate([-hha, hhb, 0]) {
            hole();
            translate([0, 0, sq_hole_h/2])
            sq_hole();
        }
        translate([hha, -hhb+tht, 0]) {
            hole();
            translate([0, 0, sq_hole_h/2])
            sq_hole();
        }
        translate([-hha, -hhb+tht, 0]) {
            hole();
            translate([0, 0, sq_hole_h/2])
            sq_hole();
        }
    };
    
    //motor mount
    translate([0, -bottom_b/2+holder_h/2, holder_a/2+bottom_h])
    rotate([90, 0, 0])
    motorMount();
}

*bracketWihtoutSide();

*union() {
    bracketWihtoutSide();
    translate([m_w, 0, 0])
    bracketWihtoutSide();
}

*bracket();

union() {
    bracket(false, true);
    translate([m_w+th, 0, 0])
    bracket(true, false);
}

*union() {
    bracket(true, true);
    translate([m_w+2*th+tr1_a, 0, 0])
    bracket(true, true);
}









