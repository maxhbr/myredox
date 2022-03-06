include <../libs/Round-Anything/polyround.scad>;

p = [[0,0,0], [-110.49,15.287,0], [-17.145,92.202,0], [-127.635,90.297,0]];

wall = 1.6;

module tent() {
    /* translate(-(-p[3] + [5,-5,0])) */
    /* rotate([-2,-8,0]) */
    /* translate(-p[3] + [5,-5,6]) */
    children();
}

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

module pcbContour() {
    translate([-213.35,144.3,0])
        import("../assets/redox_rev1_contour.stl");
}

module case() {
    bottomW = 2.5;
    sideW = 4;
    edgeH = 4;
    overH = 2.5;
    delta = 0.5;

    tent()
    difference() {
        minkowski() {
            pcbContour();
            translate([0,0,-(edgeH + bottomW)])
                hull() {
                    translate([0,0,2])
                    cylinder(r=delta+sideW, h=edgeH + bottomW + overH - 4);
                    cylinder(r=delta+sideW - 2, h=edgeH + bottomW + overH);
                    cylinder(r=delta+sideW - 1, h=edgeH + bottomW + overH);
                }
        };
        m3hole(p[0]);
        m3hole(p[1]);
        m3hole(p[2]);
        m3hole(p[3]);
        difference() {
            minkowski() {
                pcbContour();
                translate([0,0,-edgeH])
                    cylinder(r=delta, h=edgeH + 0.5 + overH);
            };
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
            color("red")
            for(t=[[-50,-5,0]
                  ,[-111,-9,0]
                  ,[-80,97,0]
                  ,[6,28,0]
                  ,[-135,50,0]
                  ]) {
                translate([0,0,-6]+t)
                hull() {
                    cylinder(d=7,h=6);
                    cylinder(d=8,h=5);
                }
            }
        }

        // MCU
        color("blue")
        translate([-62.25, 78.2,-3]) {
            hull() {
                translate([0,1,0]) cube([19,35+2,6],center=true);
                translate([0,16,6])
                translate([0,1,0]) cube([19,1,6],center=true);
            }
            translate([0,17,6])
            translate([0,1,0]) cube([19,1,6],center=true);

            translate([0,27,0])
                hull() {
                    translate([-3,0,0]) rotate([90,0,0]) cylinder(d=7, h=10);
                    translate([3,0,0]) rotate([90,0,0]) cylinder(d=7, h=10);
                    translate([-3,0,-10]) rotate([90,0,0]) cylinder(d=7, h=10);
                    translate([3,0,-10]) rotate([90,0,0]) cylinder(d=7, h=10);
                }
        }
        // reset switch
        color("blue")
        translate([-127.635+32.35,90.297+0.6,-2.5]) {
            cube([6.5+2,6.5+2,5], center=true);
            cylinder(d=3,h=20, center=true);
        }
        // trrs jack
        color("blue")
        translate([-7,87.4,-3]) {
            cube([13,17.26,6], center=true);
        }
        color("red")
        translate([-5,60,-(edgeH + bottomW)+0.3])
            rotate([180,0,90])
            linear_extrude(0.31)
            text("github.com/maxhbr",
                    font = "Roboto Condensed:style=Light",
                    size = 6,
                    halign = "center");
    }
}

$fs = 0.01;
case();

/*
########################################################################################################################################################
########################################################################################################################################################
########################################################################################################################################################
*/

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


if($preview) {
    translate([200,0,0])
        intersection() {
            case();
            union() {
                cube([100,100,100],center=true);
                translate([-100,100,0])
                    cube([100,100,100],center=true);
            }
        }

    translate([-200,0,0]) {
        case();
        tent() {
            color("green", 1) import("../assets/redox_rev1.stl");
        }
        /* color("black", 0.5) plate(); */
        /* translate([-40*cos(30),40*sin(30),6]) */
        /*     rotate([0,0,-30]) */
        /*     L6536100(); */
    }
}else{
    translate([0,202,0])
    mirror([0,1,0])
        case();
}

