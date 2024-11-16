$fa=3;
$fs=0.05;
p = 0.01;
p2 = 2*p;

sq_hole_a = 5.7;
sq_hole_h = 2.2;

m2_d = 2.2;
m3_d = 3.2;

h1 = 45;
wx = 9;
wy = 9;

h2 = 30;

h3 = 8;

inax = 7;
inay = 25;
inaz = 2;
ina_hole = 20;

h_hole = 2.0;

hole_x = 3;
hole_y = 3.3;

module hole(h, d) {
    cylinder(h+p2, d=d);
}

difference() {
    cylinder(10, d=3);
    cylinder(10, d=m2_d);
}


translate([50, 0, 0])
difference() {
    translate([0, -wy/2, 0])
    union() {
        difference() {
            cube([wx, wy, h1]);
            //translate([(wx-sq_hole_a)/2, (wy-sq_hole_a)/2, h_hole])
            translate([-p, wy - hole_y - sq_hole_a/2, h_hole])
            cube([hole_x + sq_hole_a/2 + p, sq_hole_a, sq_hole_h]);
            translate([hole_x, wy - hole_y, -p])
            hole(h3, m3_d);
        }
        
        translate([-h2+wx, 0, h1-wx/2])
        cube([h2, wy, wx/2]);
                
        difference() {
            translate([-h2+wx, -(inay-wy)/2, h1-inaz])
            cube([inax, inay, inaz]);   
        }   
    }    
    translate([-h2+wx+inax/2, ina_hole/2, h1-inaz-p])
    hole(inaz + p2, m2_d);
    translate([-h2+wx+inax/2, -ina_hole/2, h1-inaz-p])
    hole(inaz + p2, m2_d);  
}
