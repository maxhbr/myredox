include <../libs/Round-Anything/polyround.scad>;

p = [[0,0,0], [-110.49,15.287,0], [-17.145,92.202,0], [-127.635,90.297,0]];

wall = 1.6;

module m3hole(t) {
    color("gray")
    translate(t) {
        cylinder(d=4, h=5.7*2, center=true);
    };
}

module m3base(t, cH) {
    cD = 8;
    translate(t) {
        translate([0,0,-1]) cylinder(d1=cD, d2=cD -1,h=1);
        translate([0,0,-cH]) cylinder(d=cD,h=cH-1);
    };
}

module B18650() {
    color("red")
        cylinder(d=18.5,h=65.2, center=true);
    color("black")
        difference() {
            intersection() {
                translate([0,0.5,0])
                cube([21,20,76], center=true);
                hull() {
                    cylinder(d=22,h=77, center=true);
                    translate([0,10,])
                    cylinder(d=22,h=77, center=true);
                }
            }
            hull() {
                cylinder(d=19,h=74, center=true);
            }
            translate([0,-7,0]) cube([22,10,18], center=true);
            translate([0,-7,33]) cube([22,10,6], center=true);
            translate([0,-7,-33]) cube([22,10,6], center=true);
            translate([0,7,34]) cube([9,10,3], center=true);
            translate([0,7,-34]) cube([9,10,3], center=true);
            translate([0,-7,0]) cube([10,10,72], center=true);
            cylinder(d=3,h=100,center=true);
            rotate([90,0,0]) cylinder(d=3,h=100,center=true);
        }
}

module L301030() {
    color("gray") {
        hull() {
            cube([30,9,1],center=true);
            cube([28,10,1],center=true);
            cube([28,9,3],center=true);
        };
    };
}
module L301230() {
    color("gray") {
        hull() {
            cube([30,12,1],center=true);
            cube([28,13,1],center=true);
            cube([28,12,3],center=true);
        };
    };
}
module L6536100() {
    //  65 · 36 · 10
    color("gray") {
        hull() {
            cube([65,34,8],center=true);
            cube([63,36,8],center=true);
            cube([63,34,10],center=true);
        };
    };
}

module edge() {
    bottomW = 2.5;
    sideW = 4;
    edgeH = 4;
    overH = 2.5;
    delta = 0.5;

    difference() {
        minkowski() {
            import("../assets/redox_rev1_contour.stl");
            translate([0,0,-(edgeH + bottomW)])
                hull() {
                    translate([0,0,2])
                    cylinder(r=delta+sideW, h=edgeH + bottomW + overH - 4);
                    cylinder(r=delta+sideW - 2, h=edgeH + bottomW + overH);
                }
        };
        minkowski() {
            import("../assets/redox_rev1_contour.stl");
            translate([0,0,-edgeH])
                cylinder(r=delta, h=edgeH + 0.5 + overH);
        };
        translate([0,60,-(edgeH + bottomW)] - [-213.35,144.3,-0.3])
            rotate([180,0,90])
            linear_extrude(0.31)
            text("github.com/maxhbr",
                    font = "Roboto Condensed:style=Light",
                    size = 4,
                    halign = "center");
    }
}

module plate() {
    translate([0,0,0.75 + 1.6 + 3.5]){
/*
                  l2
      +-------------------------+
      | * y1              y2  * |
      | x1                   x2 |
      |                         |
      |                         |
   l1 |                         |
      |                         +
      |  x3                       \
      |   *                         \
      |    y3                         +
      +------------------+     *    /
                           \      /
                             \  /  l3
                               +
*/
        l1=107.82;
        l2=142.5;
        l3=52.37;
        x1=7.15;
        y1=8.37;
        x2=23.83;
        y2=5.50;
        x3=25.85;
        y3=26.0;

        rotate([0,0,-30]) translate([-5,0,0]) cube([l3,l3,1.5],center=true);
        translate([-65,44,0]) cube([l2,l1,1.5],center=true);

        // radiiPoints=[[-4,0,1],[5,3,1.5],[0,7,0.1],[8,7,10]];
        // polygon(polyRound(radiiPoints,30));


    }
}


module case() {

    difference() {
        union() {
            m3base(p[0], 6);
            m3base(p[1], 6);
            hull() {
                m3base(p[2], 6);
                translate(p[2] + [0,6,-3])
                    cube([8,1,6],center=true);
            }
            hull() {
                m3base(p[3], 6);
                translate(p[3] + [-5,5,-3])
                    rotate([0,0,45])
                    cube([8,0.5,6],center=true);
            }
            translate([-213.35,144.3,0])
                edge();
        }

        m3hole(p[0]);
        m3hole(p[1]);
        m3hole(p[2]);
        m3hole(p[3]);

        translate([-62.25, 78.2,-2.75]) {
            cube([19,35,5.5],center=true);
            translate([7.5,0,-0.25]) cube([4,35,6],center=true);
            translate([-7.5,0,-0.25]) cube([4,35,6],center=true);

            translate([0,27,0])
                hull() {
                    translate([-3,0,0]) rotate([90,0,0]) cylinder(d=7, h=10);
                    translate([3,0,0]) rotate([90,0,0]) cylinder(d=7, h=10);
                    translate([-3,0,-10]) rotate([90,0,0]) cylinder(d=7, h=10);
                    translate([3,0,-10]) rotate([90,0,0]) cylinder(d=7, h=10);
                }
        }
        translate([-127.635+32.35,90.297+0.6,-2.5]) {
            cube([6.5+2,6.5+2,5], center=true);
            cylinder(d=3,h=20, center=true);
        }
        translate([-5.5,87.4,-2.5]) {
            cube([9,17,5], center=true);
        }
    }
}

$fs = 0.01;
case();

/*
translate([57,32,3]) {
    color("red", 0.2) import("../../submodules/Redox-neodox-Case/redox_rev1.0/Neodox_rev1.0-Top-Left_0.12.stl");
    color("yellow", 0.2) import("../../submodules/Redox-neodox-Case/redox_rev1.0/Neodox_rev1.0-Bottom-Left.stl");
}
*/


if($preview) {
    translate([200,0,0])
        intersection() {
            case();
            cube([100,100,100],center=true);
        }

    translate([-200,0,0]) {
        case();
        color("green", 1) import("../assets/redox_rev1.stl");
        /* color("black", 0.5) plate(); */
        translate([-15*cos(30),15*sin(30),-12])
        rotate([0,0,-30])
        L6536100();
    }
}

