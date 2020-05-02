$fn=400;
p = 0.05;
p2 = 2*p;
px = 1;

numX = 3;
numY = 3;

dice_size = 20;
height = 3;
spacing = 3;
spacing_h = 5;
dot_d = 3;

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

a = dice_size * numX + spacing * (numX + 1);
b = dice_size * numY + spacing * (numY + 1);

module hole(h = height, d = dot_d) {
    cylinder(h+p2, d=d, center=true);
}

module mask(face, withSpacing=true) {
    difference() {
        cube([a, b, height + (withSpacing ? spacing_h : 0)]);
        for(i = [1:numX]) {
            for(j = [1:numY]) {
                dx = i * (spacing + dice_size) - dice_size;
                dy = j * (spacing + dice_size) - dice_size;
                if (withSpacing) {
                    translate([dx, dy, height-p])
                    cube([dice_size, dice_size, spacing_h + p2]);
                }
                for(n = [0:face-1]) {
                    translate([dx, dy, height/2])
                    translate([holes[face-1][n][0], holes[face-1][n][1], 0] * dice_size)
                    hole();
                }
            }
        }
    }
}

*for(f = [1:6]) {
    translate([ceil(f / 2 - 1) * (a + 5), (f % 2 - 1) * (b + 5), 0])
    union() {
        mask(f);
        spacing();
    }
}

for(f = [1:4]) {
    translate([ceil(f / 2 - 1) * (a + 5), (f % 2 - 1) * (b + 5), 0])
    union() {
        mask(f);
    }
}

*for(f = [5:6]) {
    translate([ceil(f / 2 - 1) * (a + 5), (f % 2 - 1) * (b + 5), 0])
    union() {
        mask(f);
    }
}