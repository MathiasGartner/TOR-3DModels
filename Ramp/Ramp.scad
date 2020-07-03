$fa=3;
$fs=0.05;
p = 0.02;
p2 = 2*p;

acryl_h = 3;

a = 288;
b = 189;
h = 16;
angle = 40;

acryl_form_diff = 1; //form is 1 mm smaller than acryl on each side

acryl_a = 290;
acryl_b = 189;

flex_a = 16;
flex_b = 5.5;//0.5;

cable_x1_acryl = 253.3;
cable_x2_acryl = 260.2;
cable_a = cable_x2_acryl - cable_x1_acryl + 1;
cable_b = 10;
cable_x = cable_x1_acryl - acryl_a/2 + cable_a/2;

//cable_a = 6;
//cable_b = 6;
//cable_r = 12;
//cable_x = (a-cable_a)/2+p;
//cable_x = a/2;

holder_a = 20;
holder_b = 10;
holder_h = 1.5;
holder_x = (a-holder_a)/2 - 20;
holder_y = (b-holder_b/2) - 20;
echo(holder_x, holder_y);

top_h = acryl_h + h;
top_b = top_h * tan(angle);

outer_border = 10;
outer_a = a + 2 * outer_border;
outer_b = b + top_b + 2 * outer_border;
outer_h = h + outer_border;
outer_aa = outer_a + 1.0 * outer_border;
outer_bb = outer_b + 1.0 * outer_border;
outer_hh = outer_h + 0.5 * outer_border - p;

cord_hole_d = 9;
cord_hole_dx = 11.5; //left spacing to center of hole
cord_hole_dy = 31.59;
cord_hole_x = a/2 - cord_hole_dx + acryl_form_diff;
cord_hole_y = cord_hole_dy;

steel_hole_d = 3.5;
steel_hole_dx = 4;
steel_hole_dy = 2.7;
steel_hole_x = a/2 - steel_hole_dx + acryl_form_diff;
steel_hole_y = steel_hole_dy;

screw_x_arcyl = 11.5;
screw_y_arcyl = 11.5;
screw_x = a/2 - screw_x_arcyl + acryl_form_diff;
screw_y = 11.5;
screw_s = 6.0;
screw_h = 2.0;

module form_hole(x, y, d) {
    translate([x, y, 0])
    rotate([angle, 0, 0])
    cylinder(4*h, d=d, center=true);    
}

module form_hole_rect(x, y, a, b) {
    translate([x, y, 0])
    rotate([angle, 0, 0])
    cube([a, b, 4*h], center=true);    
}

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
        form_hole(-cord_hole_x, cord_hole_y, cord_hole_d);
        form_hole(cord_hole_x, cord_hole_y, cord_hole_d);
        
        //steel holes
        form_hole(-steel_hole_x, steel_hole_y, steel_hole_d);
        form_hole_rect(-steel_hole_x - steel_hole_d, steel_hole_y, steel_hole_d*2, steel_hole_d);
        form_hole(steel_hole_x, steel_hole_y, steel_hole_d);       
        form_hole_rect(steel_hole_x + steel_hole_d, steel_hole_y, steel_hole_d*2, steel_hole_d);       
        
        //flex cable (+led)
        translate([0, -top_b-p, 0])
        translate([0, 0, h])
        rotate([angle, 0, 0])
        translate([-(flex_a/2), 0, -h*3])
        cube([flex_a, flex_b+p, h*6]);
        
        //cable
        translate([0, -top_b-p, 0])
        translate([cable_x, 0, h])
        rotate([angle, 0, 0])
        translate([-(cable_a/2), 0, -h*3])
        cube([cable_a, cable_b+p, h*6]);
        
        //cable
        /*translate([cable_x, -top_b-p, 0])
        //translate([cable_x, -top_b-p+flex_b/cos(angle), 0])
        translate([0, 0, h])
        rotate([angle, 0, 0])
        translate([0, 0, -h*3])
        //cube([cable_a, cable_b+p, h*2]);    
        cylinder(6*h, r=cable_r);*/
        
        //screws
        translate([screw_x, screw_y, screw_h/2])
        cube([screw_s, screw_s, screw_h+p], center=true);
        translate([-screw_x, screw_y, screw_h/2])
        cube([screw_s, screw_s, screw_h+p], center=true);
        translate([screw_x, b - screw_y, screw_h/2])
        cube([screw_s, screw_s, screw_h+p], center=true);
        translate([-screw_x, b - screw_y, screw_h/2])
        cube([screw_s, screw_s, screw_h+p], center=true);
    }    
    //holder
    //translate([holder_x, holder_y, -holder_h/2])
    //cube([holder_a, holder_b, holder_h+p], center=true);
    //translate([-holder_x, holder_y, -holder_h/2])
    //cube([holder_a, holder_b, holder_h+p], center=true);   
}

module mold_form() {
    union() {
        translate([0, -(b-top_b)/2, 0]) //now upper part is on z=0
        translate([0, 0, top_b]) //now lower part is on z=0
        translate([0, 0, outer_border/2]) // now lower part is in mold form
        rotate([0, 180, 0])
        form();

        //translate([0, 0, -outer_border*2])
        union() {
            difference() {
                translate([0, 0, outer_hh/2])
                cube([outer_aa, outer_bb, outer_hh], center=true);    
                translate([0, 0, outer_h/2 + 0.5 * outer_border])
                cube([outer_a, outer_b, outer_h], center=true);
            }
            *translate([0, 0, outer_border/2+outer_border-p])
            cube([a, b+top_b, outer_border+p2], center=true);
        }
    }
}

module acryl() {
    difference() {
        translate([0, 0, acryl_h/2])
        cube([acryl_a, acryl_b, acryl_h], center=true);
        translate([acryl_a/2, -acryl_b/2, 0]) {
            translate([-7.7, 26.59, 0])
            scale([8, 12.96, 1])
            cylinder(acryl_h*3, d=1, center=true);
            translate([-4, 2.7, 0])
            scale([3.2, 6.7, 1])
            cylinder(acryl_h*3, d=1, center=true);
        }
        translate([-acryl_a/2, -acryl_b/2, 0]) {
            translate([7.7, 26.59, 0])
            scale([8, 12.96, 1])
            cylinder(acryl_h*3, d=1, center=true);
            translate([4, 2.7, 0])
            scale([3.2, 6.7, 1])
            cylinder(acryl_h*3, d=1, center=true);
            //translate([4+cable_a/2, 0, 0])
            translate([cable_a/2 + 8, cable_b/2, 0])
            cube([cable_a, cable_b+p2, acryl_h*3], center=true);
        }
    }
}

module dummy() {
    d_a = 50;
    d_b = 30;
    d_h_bottom = 3;
    d_h_middle = 5;
    d_h_top = 3;
    d_h = d_h_bottom + d_h_middle + d_h_top;
    d_t = 5;
    union() {
        difference() {
            translate([0, 0, d_h/2])
            cube([d_a, d_b, d_h], center=true);
            translate([0, 0, (d_h+d_h_bottom)/2])
            cube([d_a-d_t, d_b-d_t, d_h - d_h_bottom +p], center=true);
        }
        translate([0, 0, (d_h)/2])
        cube([d_a-2*d_t, d_b-2*d_t, d_h - d_h_top], center=true);
    }
}

*dummy();

*difference() {    
    translate([-outer_a/2, -(top_b + outer_border), -outer_border])
    cube([outer_a, outer_b, outer_h]);
    form();
}

//acryl + ramp
*rotate([180+angle, 0, 0]) {
    color("red")
    translate([0, top_b/2, 0])
    acryl();

    //form
    //rotate([-angle, 0, 0])
    translate([0, 0, -h-p2])
    translate([0, -(b-top_b)/2, 0])
    translate([0, 0, h])
    rotate([0, 180, 0])
    form();    
}

//part 2 of form
*difference() {
    translate([0, 0, -h-p2])
    translate([0, -(b-top_b)/2, 0])
    form();
    translate([-outer_aa/2, 0, 0])
    cube([outer_aa+p2, outer_bb*2, outer_hh*2], center=true);
    translate([0, outer_bb/2, 0])
    cube([outer_aa*2, outer_bb+p2, outer_hh*2], center=true);
}

*form();

//mold_form
mold_form();

translate([0, 0, 0]) {

//right part
*translate([0, 0, outer_hh*2])
difference() {
    mold_form();
    translate([outer_aa/2, 0, 0])
    cube([outer_aa+p2, outer_bb*2, outer_hh*3], center=true);
}

//left part
*translate([0, 0, outer_hh*4])
difference() {
    mold_form();
    translate([-outer_aa/2, 0, 0])
    cube([outer_aa+p2, outer_bb*2, outer_hh*3], center=true);
}

//part1
*translate([0, 0, outer_hh*6])
difference() {
    mold_form();
    translate([-outer_aa/2, 0, 0])
    cube([outer_aa+p2, outer_bb*2, outer_hh*3], center=true);
    translate([0, -outer_bb/2, 0])
    cube([outer_aa*2, outer_bb+p2, outer_hh*3], center=true);
}

//part2
*translate([0, 0, outer_hh*8])
difference() {
    mold_form();
    translate([-outer_aa/2, 0, 0])
    cube([outer_aa+p2, outer_bb*2, outer_hh*3], center=true);
    translate([0, outer_bb/2, 0])
    cube([outer_aa*2, outer_bb+p2, outer_hh*3], center=true);
}

//part3
*translate([0, 0, outer_hh*10])
difference() {
    mold_form();
    translate([outer_aa/2, 0, 0])
    cube([outer_aa+p2, outer_bb*2, outer_hh*3], center=true);
    translate([0, -outer_bb/2, 0])
    cube([outer_aa*2, outer_bb+p2, outer_hh*3], center=true);
}

//part4
*translate([0, 0, outer_hh*12])
difference() {
    mold_form();
    translate([outer_aa/2, 0, 0])
    cube([outer_aa+p2, outer_bb*2, outer_hh*3], center=true);
    translate([0, outer_bb/2, 0])
    cube([outer_aa*2, outer_bb+p2, outer_hh*3], center=true);
}

}