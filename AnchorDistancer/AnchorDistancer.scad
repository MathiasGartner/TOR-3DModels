$fa=3;
$fs=0.05;
p = 0.02;
p2 = 2*p;

da = 10.0;
a = 29.5;
c = 5.0;

points = [[0, da],
          [0, a],
          [a, 0],
          [da, 0]];
          
linear_extrude(c)
polygon(points);