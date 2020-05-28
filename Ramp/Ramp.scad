$fa=3;
$fs=0.05;
p = 0.01;
p2 = 2*p;

acryl_h = 3;

a = 288;
b = 189;
h = 30;
angle = 40;

hole_d = 10;
hole_dx = 10;
hole_x = a/2 - hole_dx;
hole_dy = 30;
hole_y = hole_dy;

flex_a = 18;
flex_b = 0.5;
cable_a = 6;
cable_b = 6;
cable_r = 12;
//cable_x = (a-cable_a)/2+p;
cable_x = a/2;

holder_a = 20;
holder_b = 10;
holder_h = 1.5;
holder_x = (a-holder_a)/2 - 20;
holder_y = (b-holder_b/2) - 20;

top_h = acryl_h + h;
top_b = top_h * tan(angle);

outer_border = 10;
outer_a = a + 2 * outer_border;
outer_b = b + top_b + 2 * outer_border;
outer_h = h + outer_border - p;
outer_aa = outer_a + 2 * outer_border;
outer_bb = outer_b + 2 * outer_border;
outer_hh = 1.5*outer_h + outer_border - p;

module form()  {
    difference() {
        translate([0, 0, -acryl_h])
        difference() {
            translate([0, -top_b, 0])
            difference() {
                translate([-a/2, 0, 0])
                cube([a, b + top_b, top_h]);
                translate([0, 0, top_h])
                rotate([angle, 0, 0])
                translate([-(a/2+p), -top_b, -top_h*2])
                cube([a+p2, top_b, top_h*2]);
            }
            translate([-(a/2+p), 0, -p])
            cube([a+p2, b+p2, acryl_h+p]);
        }
        //cord holes
        translate([-hole_x, hole_y, h/2])
        rotate([angle, 0, 0])
        cylinder(3*h, d=hole_d, center=true);
        translate([hole_x, hole_y, h/2])
        rotate([angle, 0, 0])
        cylinder(3*h, d=hole_d, center=true);        
        
        //flex cable
        translate([0, -top_b-p, 0])
        translate([0, 0, h])
        rotate([angle, 0, 0])
        translate([-(flex_a/2), 0, -h*2])
        cube([flex_a, flex_b+p, h*2]);
        
        //cable
        translate([cable_x, -top_b-p, 0])
        //translate([cable_x, -top_b-p+flex_b/cos(angle), 0])
        translate([0, 0, h])
        rotate([angle, 0, 0])
        translate([0, 0, -h*2])
        //cube([cable_a, cable_b+p, h*2]);    
        cylinder(3*h, r=cable_r);
    }    
    //holder
    translate([holder_x, holder_y, -holder_h/2])
    cube([holder_a, holder_b, holder_h+p], center=true);
    translate([-holder_x, holder_y, -holder_h/2])
    cube([holder_a, holder_b, holder_h+p], center=true);   
}

module mold_form() {
    union() {
        translate([0, -(b-top_b)/2, 0])
        translate([0, 0, h])
        rotate([0, 180, 0])
        form();

        translate([0, 0, -outer_border*2])
        union() {
            difference() {
                translate([0, 0, outer_hh/2])
                cube([outer_aa, outer_bb, outer_hh], center=true);    
                translate([0, 0, -outer_h/2+outer_hh+p])
                cube([outer_a, outer_b, outer_h*2], center=true);
            }
            translate([0, 0, outer_border/2+outer_border-p])
            cube([a, b+top_b, outer_border+p2], center=true);
        }
    }
}

*difference() {    
    translate([-outer_a/2, -(top_b + outer_border), -outer_border])
    cube([outer_a, outer_b, outer_h]);
    form();
}

//form
//rotate([-angle, 0, 0])
*translate([0, -(b-top_b)/2, 0])
translate([0, 0, h])
rotate([0, 180, 0])
form();

//mold_form
mold_form();

//right part
translate([0, 0, outer_hh*2])
difference() {
    mold_form();
    translate([outer_aa/2, 0, 0])
    cube([outer_aa+p2, outer_bb*2, outer_hh*2], center=true);
}

//left part
translate([0, 0, outer_hh*4])
difference() {
    mold_form();
    translate([-outer_aa/2, 0, 0])
    cube([outer_aa+p2, outer_bb*2, outer_hh*2], center=true);
}

//part1
translate([0, 0, outer_hh*6])
difference() {
    mold_form();
    translate([-outer_aa/2, 0, 0])
    cube([outer_aa+p2, outer_bb*2, outer_hh*2], center=true);
    translate([0, -outer_bb/2, 0])
    cube([outer_aa*2, outer_bb+p2, outer_hh*2], center=true);
}

//part2
translate([0, 0, outer_hh*8])
difference() {
    mold_form();
    translate([-outer_aa/2, 0, 0])
    cube([outer_aa+p2, outer_bb*2, outer_hh*2], center=true);
    translate([0, outer_bb/2, 0])
    cube([outer_aa*2, outer_bb+p2, outer_hh*2], center=true);
}

//part3
translate([0, 0, outer_hh*10])
difference() {
    mold_form();
    translate([outer_aa/2, 0, 0])
    cube([outer_aa+p2, outer_bb*2, outer_hh*2], center=true);
    translate([0, -outer_bb/2, 0])
    cube([outer_aa*2, outer_bb+p2, outer_hh*2], center=true);
}

//part4
translate([0, 0, outer_hh*12])
difference() {
    mold_form();
    translate([outer_aa/2, 0, 0])
    cube([outer_aa+p2, outer_bb*2, outer_hh*2], center=true);
    translate([0, outer_bb/2, 0])
    cube([outer_aa*2, outer_bb+p2, outer_hh*2], center=true);
}