$fa=3;
$fs=0.05;
p = 0.02;
p2 = 2*p;

a = 30.0;
b = 7.0;
c = 2.5;
m = 2.0;
s = 5.6;

cc = 1.5*c;
aa = a+5;
bb = b+5;

union() {    
    translate([0, 0, cc/2])
    cube([a, b, cc], center=true);    
    
    difference() {
        translate([0, 0, 5*c/2 + cc])
        cube([aa, bb, 5*c], center=true);
        translate([(aa-a)/2, 0, c/2 + cc + c/2])
        cube([a+(aa-a)/2+p+0.2, b+0.2, c+0.1], center=true);
        translate([aa/2 - s/2, 0, m/2 + 3.5*c])
        cube([s+p, s, m], center=true);
        translate([aa/2 - s/2, 0, 4*c/2 + cc + c])
        cylinder(d=3.1, h=4*c+p, center=true);
    }    
    
    translate([0, 0, 30/2 + 6 * c])
    cube([15, 1.5*b, 30], center=true);
}

translate([0, 30, 0])
difference() {
    translate([0, 0, cc/2])
    cube([3*a, 4*b, cc], center=true);
    translate([0, 0, cc/2])
    cube([a, b, cc+p]*1.05, center=true);
}