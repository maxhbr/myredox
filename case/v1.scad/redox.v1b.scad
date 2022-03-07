include <../libs/Round-Anything/polyround.scad>;

p = [[0,0,0], [-110.49,15.287,0], [-17.145,92.202,0], [-127.635,90.297,0]];

wall = 1.6;

tentA=8;
tentP=-p[3] + [0,0,0];

module tent(tentA=0) {
    if (tentA==0) {
        children();
    } else {
        translate(-tentP)
        rotate([0,-tentA,0])
        translate(tentP)
        children();
    }
}
module untent(tentA=0) {
    if (tentA==0) {
        children();
    } else {
        translate(-tentP)
        rotate([0,tentA,0])
        translate(tentP)
        children();
    }
}

module counterTent(tentA=0) {
    if (tentA==0) {
        children();
    } else {
        for (a=[0:tentA]) {
            translate(-tentP)
                rotate([0,a,0])
                translate(tentP)
                children();
        }
    }
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

module L472878() {
    // 47 · 28 · 7.8 mm
    color("gray") {
        hull() {
            cube([47,26,5.8],center=true);
            cube([45,28,5.8],center=true);
            cube([45,26,7.8],center=true);
        };
    };
}

module pcbContour() {
    translate([-213.35,144.3,0])
        import("../assets/redox_rev1_contour.stl");
}

module case(tentA=0,right=0) {
    bottomW = 2.5;
    sideW = 4;
    edgeH = 4;
    overH = 2.5;
    delta = 0.5;

    mirror(right==0 ? [0,0,0] : [1,0,0])
    tent(tentA)
    difference() {
        counterTent(tentA)
            minkowski() {
                union() {
                    pcbContour();
                    translate([-50,0,0.8])
                    cube([80,14,1.6], center=true);
                }
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
            difference() {
                hull() {
                    translate([0,1,0.25]) cube([19,35+2,5.5],center=true);
                    translate([0,1,0]) cube([18,35,6],center=true);
                    translate([0,16,6])
                        translate([0,1,0]) cube([19,1,6],center=true);
                }
                if(right==0){
                    translate([0,1,-5.5]) cube([11,35+2,6],center=true);
                }
            }
            translate([0,17,6])
            translate([0,1,0]) cube([19,1,6],center=true);

            translate([0,27,0])
                hull() {
                    translate([-3,0,0]) rotate([90,0,0]) cylinder(d=7, h=10);
                    translate([3,0,0]) rotate([90,0,0]) cylinder(d=7, h=10);
                    translate([-3,0,-2]) rotate([90,0,0]) cylinder(d=7, h=10);
                    translate([3,0,-2]) rotate([90,0,0]) cylinder(d=7, h=10);
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
            hull() {
                cube([13,17.26,6], center=true);
                translate([1,-2,2])
                cube([15,17.26,6], center=true);
            }
        }
        color("red")
        untent(tentA)
        translate([-5,60,-(edgeH + bottomW)+0.3])
            rotate([180,0,90])
            linear_extrude(0.31)
            mirror(right==0 ? [0,0,0] : [1,0,0])
            text("github.com/maxhbr",
                    font = "Roboto Condensed:style=Light",
                    size = 6,
                    halign = "center");

        // outer bounds
        translate([0,0,100/2+4.1]) cube([1000,1000,100],center=true);
        untent(tentA) translate([0,0,-100/2-6.5]) cube([1000,1000,100],center=true);
    }
}

$fs = 0.01;

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
    translate([-200,140,0]) {
        case(right=1);
    }
    translate([200,-100,0])
        intersection() {
            case();
            union() {
                cube([100,100,100],center=true);
                translate([-100,100,0])
                    cube([100,100,100],center=true);
            }
        }
    /* translate([200,100,0]) */
    /*     intersection() { */
    /*         case(8); */
    /*         union() { */
    /*             cube([100,100,100],center=true); */
    /*             translate([-100,100,0]) */
    /*                 cube([100,100,100],center=true); */
    /*         } */
    /*     } */

    translate([-200,-100,0]) {
        case();
        tent() {
            color("green", 1) import("../assets/redox_rev1.stl");
        }
        /* color("black", 0.5) plate(); */
        /* translate([0,-60,0]) */
        /* translate([-40*cos(30),40*sin(30),0]) */
        /*     rotate([0,0,-30]) */
        /*     L6536100(); */
        /* translate([23,59,-2]) */
        /*     rotate([0,0,90]) */
        /*     L472878(); */
    }
    /* translate([-300,100,0]) { */
    /*     case(12); */
    /*     tent(12) { */
    /*         color("green", 1) import("../assets/redox_rev1.stl"); */
    /*     } */
    /*     /1* color("black", 0.5) plate(); *1/ */
    /*     /1* translate([-40*cos(30),40*sin(30),6]) *1/ */
    /*     /1*     rotate([0,0,-30]) *1/ */
    /*     /1*     L6536100(); *1/ */
    /* } */
}

