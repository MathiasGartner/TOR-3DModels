//$fn=100;
$fa=6;
$fs=0.075;
p = 0.05;
p2 = 2*p;
px = 1;

numX = 2;
numY = 2;

dice_size = 16;
dice_extra = 0.75; //extra spacing on each side (mask size is dice_size + 2 * dice_extra)
height = 1;
spacing = 3;
spacing_h = 5;
dot_d1 = 5;
dot_d2 = 3; //diameter of the dot

h2_in = 0.25;
h3_in = h2_in;
h4_in = h2_in;
h5_in = h2_in;
h6_in_x = h2_in;
h6_in_y = 0.2;

h1 = [[0.5, 0.5]];
h2 = [[h2_in, 1-h2_in], [1-h2_in, h2_in]];
h3 = [[h3_in, 1-h3_in], [1-h3_in, h3_in], [0.5, 0.5]];
h4 = [[h4_in, 1-h4_in], [1-h4_in, h4_in], [h4_in, h4_in], [1-h4_in, 1-h4_in]];
h5 = [[h5_in, 1-h5_in], [1-h5_in, h5_in], [h5_in, h5_in], [1-h5_in, 1-h5_in], [0.5, 0.5]];
h6 = [[h6_in_x, h6_in_y], [h6_in_x, 0.5], [h6_in_x, 1-h6_in_y], [1-h6_in_x, h6_in_y], [1-h6_in_x, 0.5], [1-h6_in_x, 1-h6_in_y]];

holes = [h1, h2, h3, h4, h5, h6];

d_size = (dice_size + 2 * dice_extra);
a = d_size * numX + spacing * (numX + 1);
b = d_size * numY + spacing * (numY + 1);

module hole(h = height, d = dot_d) {
    cylinder(h+p2, d=d, center=true);
}

module conical_hole(h = height, d1 = dot_d1, d2 = dot_d2) {
    cylinder(h+p2, d1=d1, d2=d2, center=true);
}

module mask(face, withSpacing=true) {
    difference() {
        cube([a, b, height + (withSpacing ? spacing_h : 0)]);
        for(i = [1:numX]) {
            for(j = [1:numY]) {
                dx = i * (spacing + d_size) - d_size;
                dy = j * (spacing + d_size) - d_size;
                if (withSpacing) {
                    translate([dx, dy, height-p])
                    cube([d_size, d_size, spacing_h + p2]);
                }
                for(n = [0:face-1]) {
                    translate([dx + dice_extra, dy + dice_extra, height/2])
                    translate([holes[face-1][n][0], holes[face-1][n][1], 0] * dice_size)
                    conical_hole();
                }
            }
        }
    }
}

*mask(1);
*mask(2);
*mask(3);
*mask(4);
*mask(5);
*mask(6);

for(f = [1:6]) {
    translate([ceil(f / 2 - 1) * (a + 5), (f % 2 - 1) * (b + 5), 0])
    mask(f);
}