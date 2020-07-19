$fa=3;
$fs=0.05;
p = 0.02;
p2 = 2*p;

//magnet
a = 20.0;
b = 4.0;
c = 3.0;

//nut
m = 2.0;
s = 5.6;

cc = 1.5*c;
aa = a + 2*m + 5;
bb = b+5;

union() {    
    translate([0, 0, cc/2])
    cube([a, b, cc], center=true);    
    
    difference() {
        translate([0, 0, 4*c/2 + cc])
        cube([aa, bb, 4*c], center=true);
        translate([(aa-a)/2, 0, c/2 + cc + c/2])
        cube([a+(aa-a)/2+p+0.2+4, b+0.2, c+0.1], center=true);
        translate([aa/2 - s/2, 0, m/2 + 3.5*c])
        cube([s+p, s, m], center=true);
        translate([aa/2 - s/2, 0, 4*c/2 + cc + c])
        cylinder(d=3.1, h=4*c+p, center=true);
    }    
    
    tool_height = 40;
    tool_width = 15;
    translate([0, 0, tool_height/2 + 5 * c])
    cube([tool_width, 2*b, tool_height], center=true);
}

translate([0, 30, 0])
difference() {
    translate([0, 0, c/2])
    cube([6*a, 12*b, c], center=true);
    translate([0, 0, c/2])
    cube([a, b, c+p]*1.05, center=true);
}