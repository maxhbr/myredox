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
        res=$preview ? 1 : 10;
        for (a=[0:tentA * 10]) {
            translate(-tentP)
                rotate([0,a / res,0])
                translate(tentP)
                children();
        }
    }
}

module m3hole(t) {
    color("gray")
    translate(t) {
        cylinder(d=4 + 0.2, h=5.7*2, center=true);
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
    // https://www.amazon.de/-/en/Lithium-Protective-Insulation-Connector-Development/dp/B087LTZW61/
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

module case(tentA=0,right=0,trrs=1) {
    bottomW = 2.5;
    sideW = 4;
    edgeH = 4.5;
    overH = 2.5;
    delta = 0.5;

    translate([0,0,0]) {
    }

    mirror(right==0 ? [0,0,0] : [1,0,0])
    tent(tentA)
    difference() {
        counterTent(tentA)
            union() {
                minkowski() {
                    union() {
                        pcbContour();
                        translate([-50,0,0.8]) cube([80,14,1.6], center=true);
                        if (trrs==1) {
                            translate([-0.545,90.53,0.8])
                                cube([10,10,1.6], center=true);
                        }
                    }
                    translate([0,0,-(edgeH + bottomW)])
                        hull() {
                            translate([0,0,2])
                                cylinder(r=delta+sideW, h=edgeH + bottomW + overH - 4);
                            cylinder(r=delta+sideW - 2, h=edgeH + bottomW + overH);
                            cylinder(r=delta+sideW - 1, h=edgeH + bottomW + overH);
                        }
                };
            }

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
            //supports
            color("red")
                union() {
                    for(t=[[-50,-5,0]
                          ,[-111,-9,0]
                          ,[-130,-9,0]
                          ,[-76,97,0]
                          ,[-48.6,97,0]
                          ,[6,28,0]
                          ,[-135,50,0]
                          ,[-134,8,0]
                          ,[-sin(30)*26,-cos(30)*26,0]
                          ]) {
                        translate([0,0,-6]+t)
                            hull() {
                                cylinder(d=7,h=6);
                                cylinder(d=8,h=5);
                            }
                    }
                    for(t=[[[-52,37,0],0]
                          ,[[-72,37,0],0]
                          ,[[-72,56,0],0]
                          ,[p[1]+[0,55,0],0]
                          ,[[-10,55,0],120]
                          ,[[-18*cos(30),18*sin(30),0],60]
                          ,[[-90.5,73,0],0]
                          ,[[-33.5,75,0],0]
                          ]) {
                        translate(t[0])
                            rotate([0,0,t[1]])
                            union() {
                                hull() {
                                    translate([-1,-2.5,-6])
                                        cube([2,5,6]);
                                    translate([-1.5,-3,-6])
                                        cube([3,6,5]);
                                }
                                hull() {
                                    translate([-1.5,-3,-6])
                                        cube([3,6,5]);
                                translate([0,0,-6])
                                    cylinder(d1=9,d2=3,h=5);
                                }
                            }
                    }
                    for(t=[[[-18*cos(30),18*sin(30),0],[7*cos(30),-7*sin(30),0]]
                          ,[p[1],p[1]+[0,100,0]]
                          ,[[-72,37,-1],[-72,56,-1]]
                          ,[p[2],p[2]+[-33,0,0],p[2]+[-33,4,1],p[2]+[0,4,1]]
                          ,[p[3],p[3]+[23,0,0],p[3]+[23,6,1],p[3]+[0,6,1]]
                          ,[[-135,0,0],[-135,100,0],[-134,0,0],[-133,100,0]]
                          ,[[-111+30,-9+2,0] ,[-111-20,-9+2,0],[-111+30,-9,0] ,[-111-20,-9,0]]
                          ,[[-52,37,-1],[-52+30,37,-1]]
                        ]) {
                        hull(){
                            for(tt=t){
                                translate(tt+[0,0,-6]) cylinder(d=3, h=3);
                                translate(tt+[0,0,-6]) cylinder(d=2, h=4);
                            }
                        }
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
                    translate([-3,0,-6]) rotate([90,0,0]) cylinder(d=7, h=10);
                    translate([3,0,-6]) rotate([90,0,0]) cylinder(d=7, h=10);
                }
        }
        // reset switch
        color("blue")
        translate([-127.635+32.35,90.297+0.6,-2.5]) {
            hull() {
                cube([6.5+3,6.5+3,3], center=true);
                cube([6.5+2,6.5+2,5], center=true);
            }
            cylinder(d=3,h=20, center=true);
        }
        // trrs jack
        color("blue")
        translate(p[2] + [0,-4.81,0] + (right==1 ? [9,0,0] : [14,0,0])) {
            hull() {
                translate([0,0,-1.5-3]) cube([5,17.26,3], center=true);
                translate([0,-1,-1.5-3]) cube([7,16.26,3], center=true);
                translate([0,-1,-0.5-3]) cube([9,15.26,3], center=true);
            }
            if(trrs==1) {
                hull() {
                    for(t=[[0,6.5,-5.3/2],[0,6.5,-5.3/2-6]]) {
                        translate(t) rotate([270,0,0]) cylinder(d=8.8,h=10);
                    }
                }
            }
        }



        // outer bounds
        color("white", 0)
        translate([0,0,100/2+4.1]) cube([1000,1000,100],center=true);
        color("white", 0)
        untent(tentA) translate([0,0,-100/2-6.5]) cube([1000,1000,100],center=true);

        color("red")
        translate([-120,50,-edgeH-0.3])
            rotate([0,0,90])
            linear_extrude(0.31)
            mirror(right==0 ? [0,0,0] : [1,0,0])
            text("github.com/maxhbr",
                    font = "Roboto Condensed:style=bold",
                    size = 6.5,
                    halign = "center");

    }
}

module caseWithLipo(right=0, switch=1) {

    /*
     place for a lipo LP502245
     with e.g. 480mAh
       | W | 22.5mm |
       | H |  5.4mm |
       | L |   47mm |
     */

    tentA=2;
    depth=-2.9;
    batteryPos=[-22,24,depth];
    difference() {
        case(tentA=tentA, right=right, trrs=0);
        mirror(right==0 ? [0,0,0] : [1,0,0]) {
            hull() {
                translate(batteryPos)
                    cube([47+1, 22.5+1, 5.4], center=true);
                translate(batteryPos + [0,0,2])
                    cube([47+1, 22.5+1, 5.4], center=true);
                translate(batteryPos + [-3,0,3])
                    cube([47+1, 22.5+1, 5.4], center=true);
            }
            // lipo
            union() {
                hull() {
                    translate(batteryPos)
                        cube([47+1, 22.5+1, 5.4], center=true);
                    translate(batteryPos)
                        cube([47+3, 22.5+1, 5.4-2], center=true);
                }
                color("red")
                    translate(batteryPos)
                        translate([0,0,-3])
                        linear_extrude(0.31)
                        mirror(right==0 ? [0,0,0] : [1,0,0])
                        text("LP502245",
                                font = "Roboto Condensed:style=bold",
                                size = 6.5,
                                halign = "center");

                translate([-48,20,depth+0.5]) cube([40,10,5.4],center=true);
                hull() {
                    translate([-62,36,depth+1]) cube([12,50,2.4],center=true);
                    translate([-62,36,depth+1]) cube([8,47,5.4],center=true);
                }
                translate([-76,15,depth+1]) cube([40,30,5.4],center=true);
            }
            // switch
            if (switch==1) {
                color("pink")
                    translate([-61.5,-3,-1]) {
                        translate([0,-3.5,0])
                            cube([13,7,7],center=true);
                        translate([0,1.7,0]) {
                            intersection() {
                                hull() {
                                    cube([13,8,7],center=true);
                                    translate([0,0,3]) cube([13,1,7],center=true);
                                }
                            translate([0,0,2])
                                cube([13,10,9],center=true);
                            }
                        }
                        translate([0,-7,0])
                            cube([9,14,5],center=true);
                    }
            }
        }
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

if($preview && false) {
    translate([-200,140,0]) {
        case(right=1,trrs=1);
    }
    translate([200,-100,0])
        intersection() {
            caseWithLipo();
            union() {
                translate([-10,0,0])
                cube([100,100,100],center=true);
                translate([-100,100,0])
                    cube([100,100,100],center=true);
            }
        }
    translate([200,100,0]) {
        caseWithLipo();
        color("gray")
            translate([-22,24,-2.9]) cube([47, 22.5, 5.4], center=true);
    }
    translate([200,300,0]) {
        caseWithLipo(right=1);
    }

    translate([-200,-100,0]) {
        case();
        color("green", .7) import("../assets/redox_rev1.stl");

        /* translate([24,51,-2.6]) */
        /*     rotate([0,0,90]) */
        /*     L472878(); */
    }

    translate([-400,140,0]) {
        case(right=1);
        mirror([1,0,0])
        color("green", .7) import("../assets/redox_rev1.stl");
    }
}

