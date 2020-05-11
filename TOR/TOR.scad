$fa=6;
$fs=0.05;
p = 0.05;
p2 = 2*p;

inplace = true;

lx = 290;
ly = 290;
lz = 290;
th = 5;

ramp_y = 145;

//top
cable_hole_d = 30;

anchor_x = 14;
anchor_y = 14;
anchor_d = 3;

cam_distance = 18;
cam_y = ly - (ly-ramp_y)/2;
cam_x1 = lx/2 - cam_distance/2;
cam_x2 = lx/2 + cam_distance/2;
cam_d = 2.1;

cam_cable_w = 18;
cam_cable_holder_w = 5;
cam_cable_holder_l = 10;
cam_cable_holder_h1 = 6;
cam_cable_holder_t = 3;
cam_cable_holder_depth = 1.5;
cam_cable_x1 = lx/2 - (cam_cable_w/2 + cam_cable_holder_w/2);
cam_cable_x2 = lx/2 + (cam_cable_w/2 + cam_cable_holder_w/2);
cam_cable_y_top_dy = 50;
cam_cable_y_top_y_start = 10 + cam_cable_holder_l/2;
cam_cable_y_top = [cam_cable_y_top_y_start,
                   cam_cable_y_top_y_start + 1 * cam_cable_y_top_dy,
                   cam_cable_y_top_y_start + 2 * cam_cable_y_top_dy,
                   cam_cable_y_top_y_start + 3 * cam_cable_y_top_dy]; 

//bottom
motor_mount_x = [25, 70];
motor_mount_y = [5, 60, 115];
motor_mount_d = 2.8;

//front
cam_cable_y_front_dy = 60;
cam_cable_y_front_y_start = 20 + cam_cable_holder_l/2;
cam_cable_y_front = [cam_cable_y_front_y_start,
                     cam_cable_y_front_y_start + 1 * cam_cable_y_front_dy,
                     cam_cable_y_front_y_start + 2 * cam_cable_y_front_dy,
                     cam_cable_y_front_y_start + 3 * cam_cable_y_front_dy,
                     cam_cable_y_front_y_start + 4 * cam_cable_y_front_dy]; 

magnet_l = 20;
magnet_w = 5;
magnet_h = 1;

magnet_y = lz - 30 - magnet_w;
magnet_x_spacing = 3;
magnet_count = 8;
magnet_x_start = (lx - magnet_count * (magnet_x_spacing + magnet_l) - magnet_x_spacing) / 2;

module hole(d, h=th+p2) {
    translate([0, 0, h/2-p])
    cylinder(h=h, d=d, center=true);
}

module engrave(a, b, c) {
    translate([0, 0, c/2])
    cube([a, b, c+p], center=true);    
}

module cable_holder_hole() {
    engrave(cam_cable_holder_w, cam_cable_holder_l, cam_cable_holder_depth);
}

module cable_holder() {
    union() {
        cube([cam_cable_holder_w, cam_cable_holder_l, cam_cable_holder_h1]);
        translate([cam_cable_w + cam_cable_holder_w, 0, 0])
        cube([cam_cable_holder_w, cam_cable_holder_l, cam_cable_holder_h1]);
        cube([cam_cable_w + 2 * cam_cable_holder_w, cam_cable_holder_l, cam_cable_holder_t]);
    }
}

module motor_mount_holes() {    
    for (i=motor_mount_x) {
        for(j=motor_mount_y) {
            translate([i, j, 0])
            hole(motor_mount_d);
        }
    }
}

module top_() {
    difference() {
        cube([lx, ly, th]);
        //cable_hole
        translate([lx/2, ly/2, 0])
        hole(cable_hole_d);
        //anchors
        translate([anchor_x, anchor_y, 0])
        hole(anchor_d);
        translate([lx - anchor_x, anchor_y, 0])
        hole(anchor_d);
        translate([anchor_x, ly - anchor_y, 0])
        hole(anchor_d);
        translate([lx - anchor_x, ly - anchor_y, 0])
        hole(anchor_d);
        //cam        
        translate([cam_x1, cam_y, 0])
        hole(cam_d);
        translate([cam_x2, cam_y, 0])
        hole(cam_d);
        //cam_cable
        for (i=cam_cable_y_top) {
            translate([cam_cable_x1, i, 0])
            cable_holder_hole();
            translate([cam_cable_x2, i, 0])
            cable_holder_hole();
        }
    }    
}

module bottom_() {
    difference() {
        cube([lx, ly, th]);
        //cable_hole
        translate([lx/2, ly/2, 0])
        hole(cable_hole_d);
        //motor mount
        motor_mount_holes();
        mirror([1, 0, 0])
        translate([-lx, 0, 0])
        motor_mount_holes();
    }    
}

module left_() {
    difference() {
        cube([lx, ly, th]);
        //cable_hole
        translate([lx/2, ly/2, 0])
        hole(cable_hole_d);
    }    
}

module right_() {
    difference() {
        cube([lx, ly, th]);
        //cable_hole
        translate([lx/2, ly/2, 0])
        hole(cable_hole_d);
    }    
}

module front_() {
    difference() {
        cube([lx, ly, th]);
        //cam_cable
        for (i=cam_cable_y_front) {
            translate([cam_cable_x1, i, 0])
            cable_holder_hole();
            translate([cam_cable_x2, i, 0])
            cable_holder_hole();
        }
        //magnets
        for(i=[0:magnet_count-1]) {
            translate([magnet_x_start + magnet_l + i * (magnet_l + magnet_x_spacing), magnet_y, 0])
            engrave(magnet_l, magnet_w, magnet_h);
        }
    }    
}

module back_() {
    difference() {
        cube([lx, ly, th]);
        //cable_hole
        translate([lx/2, ly/2, 0])
        hole(cable_hole_d);
    }    
}

module top() {
    if (inplace) {
        translate([0, 0, lz])
        top_();
    }
    else {
        top_();
    }
}
module bottom() {
    if (inplace) {        
        bottom_();
    }
    else {
        bottom_();
    }
}
module left() {
    if (inplace) {
        rotate([0, -90, 0])
        left_();
    }
    else {
        left_();
    }
}
module right() {
    if (inplace) {
        translate([lx, 0, lz])
        rotate([0, 90, 0])
        right_();
    }
    else {
        right_();
    }
}
module front() {
    if (inplace) {
        rotate([90, 0, 0])
        front_();
    }
    else {
        front_();
    }
}
module back() {
    if (inplace) {
        translate([0, ly, lz])
        rotate([-90, 0, 0])
        back_();
    }
    else {
        back_();
    }
}


//faces
*top();
*bottom();
*left();
*right();
front();
*back();
*cable_holder();
