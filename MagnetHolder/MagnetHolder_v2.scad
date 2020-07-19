$fa=3;
$fs=0.05;
p = 0.01;
p2 = 2*p;

//45N
/*
a = 20; //diameter of magnet
b = 25; //height of magnet
c = 4.5; //hole for screw
cable_r = 2.5; //radius for cable hole
top_offset = 3.7; //inner radius for top (screw has to fit in)
screw_head_height = 5.0; //height of the screw head
//*/

//120N
/*
a = 25;
b = 29;
c = 4.5;
cable_r = 2.5;
top_offset = 3.7;
screw_head_height = 5.0;
//*/

//180N
//*
a = 32;
b = 29;
c = 5.5;
cable_r = 4.0;
top_offset = 5.2;
screw_head_height = 3.0;
//*/

//300N
/*
a = 35;
b = 29;
c = 5.5;
cable_r = 3.5;
top_offset = 5.2;
screw_head_height = 5.0;
//*/

inner_h = b;
inner_r = a/2+0.2;
t_side = 3.5;
t_top = 2;
top_bottom_h = 1.0;
cap_cable_thickness = 2.0;
cap_t = 1.0 * top_bottom_h;
cap_h = cap_t + cap_cable_thickness;
outer_h = inner_h + t_top + cap_h - cap_t;
outer_r = inner_r + t_side;
echo(outer_h);

top_count = 4;
top_angle = 80;
top_a = 3.0;
top_h = 8;
top_hh = 5;
top_ring_h = 2;
top_ring_r1 = top_offset;
top_ring_r2 = top_ring_r1 + top_a;
top_angle_t = 18;
top_h_t = 3;
top_down_angle = 1 * top_angle_t;
top_side_angle = 1 * top_angle_t;
top_up_angle = 1 * top_angle_t;
top_down_h = 2.5 * top_h_t;
top_side_h = top_h_t;
top_up_h = 1.3 * top_h_t;
top_fix_offset = screw_head_height + 1.5;
top_total_h = top_down_h + top_fix_offset;

cord_h = top_down_h - (top_up_h - top_side_h);
cord_hole_single_r = 1.0;
cord_hole_multi_r = 0.6;
angle_diff = 2;
h_diff = 0.5;
single_hole = false;
multi_hole_offset = 2.0;
mhs = multi_hole_offset;

magnet_center_spacing = 14;
h1 = 6.5;
h2 = h1 + magnet_center_spacing;
h_case1 = h1 + magnet_center_spacing / 2;
h_case2 = h1 + magnet_center_spacing / 2 * 3;
case_screw_angle = 17;

spring_outer_angle = 60;
spring_w = 2.5;
spring_d = 1.3;
spring_r = outer_r + spring_w;
    
module cyl(h, r, addP2 = false) {
    translate([0, 0, h/2])
    cylinder(h + (addP2 ? p2 : 0), r=r, center=true);
}

module magnet_fix_hole(d, t, angle) {
    extra = 1;
    translate([sin(angle), -cos(angle), 0]*(inner_r - extra))
    rotate([90, 0, angle])
    cyl(t + extra, d/2+0.1);
}

module magnet_fix_hole_rect(a, b, t, angle, outside=false) {
    extra = 1+(outside ? t_side : 0);
    translate([sin(angle), -cos(angle), 0]*(inner_r+extra))
    rotate([90, 0, angle])    
    translate([0, 0, -1])
    cube([a, b, t+2], center=true);
}

//magnet holder
module magnet() {    
    cable_tunnel_h1 = inner_h - h1;
    cable_tunnel_h2 = inner_h - h2;
    cable_tunnel_r = outer_r - (outer_r - inner_r)/2 - 0.4;
    cable_tunnel_t = 1.2;
    cable_tunnel_angle = 30;
    difference() {
        union() {
            difference() { 
                translate([0, 0, inner_h])
                cyl(t_top, outer_r);
                translate([0, 0, inner_h])
                cyl(t_top, c/2, true);
                translate([inner_r, 0, inner_h])
                cyl(t_top, cable_r, true);
            }     
            difference() {
                cyl(outer_h, outer_r);
                cyl(outer_h, inner_r, true);                               
                //M2 screws
                m2_nut_depth = 1.2;
                m2_nut_d = m2_nut_depth + 0.4;
                m2_nut_d_extra = m2_nut_depth + 1.9;
                rotate([0, 0, 180]) {
                    translate([0, 0, h1]) {
                        magnet_fix_hole_rect(4, 4, m2_nut_d, 270);
                        magnet_fix_hole(2, 10, 270);
                    }
                    translate([0, 0, h2]) {
                        magnet_fix_hole_rect(4, 4, m2_nut_d, 270);                
                        magnet_fix_hole(2, 10, 270);
                    }
                    rotate([0, 0, case_screw_angle])
                    translate([0, 0, h_case1]) {
                        //magnet_fix_hole_rect(4.2, 4.2, m2_nut_d, 270, true); //outside
                        magnet_fix_hole_rect(4, 4, m2_nut_d_extra, 270); //inside
                        magnet_fix_hole(2, 10, 270);
                    }
                    rotate([0, 0, -case_screw_angle])
                    translate([0, 0, h_case1]) {
                        //magnet_fix_hole_rect(4.2, 4.2, m2_nut_d, 270, true);                
                        magnet_fix_hole_rect(4, 4, m2_nut_d_extra, 270);               
                        magnet_fix_hole(2, 10, 270);
                    }
                }
                //single rect
                *color("red")
                for(i=[1:1]) {
                    translate([0, 0, h1])
                    magnet_fix_hole_rect(10, 5, 1, 270+(i-1)*30);
                    translate([0, 0, h2])
                    magnet_fix_hole_rect(10, 5, 1, 270+(i-1)*30);
                } 
                //double rect
                *color("red")
                for(i=[0:1]) {
                    translate([0, 0, h1])
                    magnet_fix_hole_rect(10, 5, 1, 270+(i-0.5)*43);
                    translate([0, 0, h2])
                    magnet_fix_hole_rect(10, 5, 1, 270+(i-0.5)*43);
                } 
                //single rect up
                *color("red")
                rotate([0, 0, 180])
                for(i=[1:1]) {
                    translate([0, 0, h1])
                    magnet_fix_hole_rect(5, 10, 1, 270+(i-1)*23);
                    translate([0, 0, h2])
                    magnet_fix_hole_rect(5, 10, 1, 270+(i-1)*23);
                } 
                //double rect up
                *color("red")
                for(i=[0:1]) {
                    translate([0, 0, h1])
                    magnet_fix_hole_rect(5, 10, 1, 270+(i-0.5)*23);
                    translate([0, 0, h2])
                    magnet_fix_hole_rect(5, 10, 1, 270+(i-0.5)*23);
                }
            }
        }
        //cable tunnel
        rotate([0, 0, -90]) {
            //1
            color("red")
            translate([0, 0, h1+2])
            translate([0, 0, cable_tunnel_h1/2])
            translate([sin(cable_tunnel_angle), cos(cable_tunnel_angle), 0]*cable_tunnel_r)
            cylinder(r=cable_tunnel_t, h=cable_tunnel_h1+p, center=true);
            
            color("grey")
            rotate([0, 0, -cable_tunnel_angle])
            translate([0, cable_tunnel_r-cable_tunnel_t/2+0.3, 0])
            translate([0, 0, h1+7])
            difference() {
                rotate([30, 0, 0])
                translate([0, 0, -cable_tunnel_h1/2])
                cylinder(r=cable_tunnel_t*1.1, h=cable_tunnel_h1, center=true);
                translate([0, 0, 9.5])
                cube([20, 20, 20], center=true);
            }
            
            color("blue")
            rotate([0, 0, -cable_tunnel_angle])
            translate([0, cable_tunnel_r-cable_tunnel_t/2+0.3, 0])
            translate([0, 0, inner_h])    
            rotate([180, 0, 0])
            translate([0, 0, 0.5+p])    
            difference() {
                rotate([40, 0, 0])
                translate([0, 0, -cable_tunnel_h1/2])
                cylinder(r=cable_tunnel_t*1.5, h=cable_tunnel_h1, center=true);
                translate([0, 0, 9.5])
                cube([20, 20, 20], center=true);
            }
                       
            color("white")
            translate([0, 0, -2])
            rotate([0, 0, 90])
            rotate([0, 0, -cable_tunnel_angle])
            translate([0, 0, cable_tunnel_h2 + 2*cable_tunnel_t])
            rotate_extrude(angle=cable_tunnel_angle/3*2)
            translate([outer_r, 0, 0])            
            scale([0.8, 1.5, 1])
            circle(cable_tunnel_t*1.5);
            
            color("orange")
            translate([0, 0, inner_h+cap_h])
            translate([sin(cable_tunnel_angle), cos(cable_tunnel_angle), 0]*(cable_tunnel_r-0.5))
            cylinder(r=cable_tunnel_t*1.5, h=cap_h, center=true);
                             
            color("green")
            rotate([0, 0, 90])
            translate([0, 0, cable_tunnel_h2 + 2*cable_tunnel_t])
            translate([cos(-cable_tunnel_angle), sin(-cable_tunnel_angle), 0]*(cable_tunnel_r-0.5))
            rotate([0, 0, -cable_tunnel_angle])
            rotate([90, 0, 90])
            cylinder(r=1, h=t_side*2, center=true);
            
            //2
            color("red")
            translate([0, 0, h2+2])
            translate([0, 0, cable_tunnel_h2/2])
            translate([sin(-cable_tunnel_angle), cos(-cable_tunnel_angle), 0]*cable_tunnel_r)
            cylinder(r=cable_tunnel_t, h=cable_tunnel_h2+p, center=true);
            
            color("grey")
            rotate([0, 0, cable_tunnel_angle])
            translate([0, cable_tunnel_r-cable_tunnel_t/2+0.3, 0])
            translate([0, 0, h2+7])
            difference() {
                rotate([30, 0, 0])
                translate([0, 0, -cable_tunnel_h2/2])
                cylinder(r=cable_tunnel_t*1.1, h=2*cable_tunnel_h2, center=true);
                translate([0, 0, 9.5])
                cube([20, 20, 20], center=true);
            }
            
            color("blue")
            rotate([0, 0, cable_tunnel_angle])
            translate([0, cable_tunnel_r-cable_tunnel_t/2+0.3, 0])
            translate([0, 0, inner_h])    
            rotate([180, 0, 0])
            translate([0, 0, 0.5+p])    
            difference() {
                rotate([40, 0, 0])
                translate([0, 0, -cable_tunnel_h2/2])
                cylinder(r=cable_tunnel_t*1.5, h=2*cable_tunnel_h2, center=true);
                translate([0, 0, 9.5])
                cube([20, 20, 20], center=true);
            }
            
            color("white")
            translate([0, 0, -2])
            rotate([0, 0, 90])
            rotate([0, 0, cable_tunnel_angle])
            translate([0, 0, cable_tunnel_h1 + 2*cable_tunnel_t])
            rotate_extrude(angle=-cable_tunnel_angle/3*2)
            translate([outer_r, 0, 0])        
            scale([0.8, 1.5, 1])
            circle(cable_tunnel_t*1.5);
            
            color("orange")
            translate([0, 0, inner_h+cap_h])
            translate([sin(-cable_tunnel_angle), cos(-cable_tunnel_angle), 0]*(cable_tunnel_r-0.5))
            cylinder(r=cable_tunnel_t*1.5, h=cap_h, center=true);
                             
            color("green")
            rotate([0, 0, 90])
            translate([0, 0, cable_tunnel_h1 + 2*cable_tunnel_t])
            translate([cos(cable_tunnel_angle), sin(cable_tunnel_angle), 0]*(cable_tunnel_r-0.5))
            rotate([0, 0, cable_tunnel_angle])
            rotate([90, 0, 90])
            cylinder(r=1, h=t_side*2, center=true);
        }
    }    
}

//mount that is fixed on magnet case with screw
module top_fix() {
    difference() {
        cyl(top_total_h, top_ring_r2);
        cyl(top_total_h, top_ring_r1, true);
        translate([0, 0, top_fix_offset])
        for(i=[1:top_count]) {
            rotate(i*360/top_count) {
                rotate_extrude(angle=top_down_angle)
                square([top_ring_r2+p2, top_down_h+p]);
                rotate(top_down_angle-p)
                rotate_extrude(angle=top_side_angle)
                square([top_ring_r2+p2, top_side_h]);
                rotate(top_down_angle + top_side_angle - p2)
                rotate_extrude(angle=top_up_angle)
                square([top_ring_r2+p2, top_up_h]);
            }
        }
    }
}

//bottom for top_fix if printed without magnet case
module top_bottom() {
    difference() {
        cyl(top_bottom_h, top_ring_r2, false);
        cyl(2*top_bottom_h+p, c/2, true);
    }
}

module top_cap() {    
    difference() {
        union() {
            cyl(cap_t, outer_r);
            cyl(cap_h, c);
        }
        cyl(cap_h, c/2, true);
    }
    hull()
    spring_case(spring_outer_angle, spring_r, spring_d, 2*spring_w, cap_t);
}

//holder for cords that is mounted in top fix
module top_cords() {
    difference() {
        union() {
            cyl(cord_h, top_ring_r1-0.1);
            rotate(-(top_up_angle-angle_diff) / 2)
            rotate([0, 0, 45])
            for(i=[1:top_count]) {
                rotate(i*360/top_count) {
                    rotate_extrude(angle=top_up_angle-angle_diff)
                    square([top_ring_r2+p2, top_side_h-h_diff]);
                }
            }
        }
        if (single_hole) {
            cyl(top_total_h, cord_hole_single_r * 2, true);
        }
        else {
            translate([mhs, mhs, 0])
            cyl(top_total_h, cord_hole_multi_r, true);
            translate([mhs, -mhs, 0])
            cyl(top_total_h, cord_hole_multi_r, true);
            translate([-mhs, mhs, 0])
            cyl(top_total_h, cord_hole_multi_r, true);
            translate([-mhs, -mhs, 0])
            cyl(top_total_h, cord_hole_multi_r, true);
        }
    }
}

module spring_case(angle, r, d, w, h) {
    union() {
        rotate([0, 0, -angle/2])
        rotate_extrude(angle=angle)
        translate([r, 0, 0])
        square([d, h]);    
        
        translate([cos(angle/2)*r, sin(angle/2)*r, 0])
        translate([-w/2, d/2, h/2])
        cube([w, d, h], center=true);    
        
        translate([cos(angle/2)*r, -sin(angle/2)*r, 0])
        translate([-w/2, -d/2, h/2])
        cube([w, d, h], center=true);    
    } 
}

module spring_contact_case() {    
    difference() {
        hull()
        spring_case(spring_outer_angle, spring_r, spring_d, 2*spring_w, outer_h);
        hull()
        translate([0, 0, spring_d + p])
        spring_case(spring_outer_angle-5, spring_r-spring_d, spring_d, 2*spring_w, outer_h - spring_d + p);
        cyl(outer_h, outer_r, true);
     
        screw_case_d = 2;
        rotate([0, 0, case_screw_angle])
        translate([0, 0, h_case1])
        rotate([0, 90, 0])
        cyl(spring_r+spring_d, screw_case_d/2);  
        rotate([0, 0, -case_screw_angle])
        translate([0, 0, h_case1])
        rotate([0, 90, 0])
        cyl(spring_r+spring_d+2, screw_case_d/2); 
      
        spring_hole_d = 7;
        translate([0, 0, h1])
        rotate([0, 90, 0])
        cyl(spring_r+spring_d, spring_hole_d/2);  
        translate([0, 0, h2])
        rotate([0, 90, 0])
        cyl(spring_r+spring_d, spring_hole_d/2);       
    }
}

translate([20, 0, 0])
spring_contact_case();

translate([20, 0, 0])
top_cords();

translate([0, -30, 0])
magnet();

union() {
    top_bottom();
    translate([0, 0, top_bottom_h])
    top_fix();
}

translate([0, 30, 0])
top_cap();

//magnet case with top fix
*translate([0, 30, 0])
union() {
    magnet();
    translate([0, 0, outer_h])
    top_fix();   
}