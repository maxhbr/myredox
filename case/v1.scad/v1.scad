include <../libs/Round-Anything/polyround.scad>;

// include lipo
var_type="caseWithLipo"; // ["case", "caseWithLipo", "caseWithLipoExt", "tentKit"]
// which side
var_right=false; // [true,false]
// incude trrs
var_trrs=false; // [true,false]
// whether to keep space for printed switchpalate
var_printedPlate=false; // [true,false]
/* [case] */
// tening, if no lipo
var_tentA=0; //[0:1:45]
/* [caseWithLipo] */
// include switch
var_switch=true; // [true,false]


/* [hidden] */

p = [[0+0,0,0], [-110.49,15.287,0], [-17.145,92.202,0], [-127.635,90.297,0]];
tP=[[4,-7.5,0], [-14,40,0],[4,95,0]];

tentP=-p[3] + [0,0,0];

module tent(tentA=0,tentP=tentP) {
    if (tentA==0) {
        children();
    } else {
        translate(-tentP)
        rotate([0,-tentA,0])
        translate(tentP)
        children();
    }
}
module untent(tentA=0,tentP=tentP) {
    if (tentA==0) {
        children();
    } else {
        translate(-tentP)
        rotate([0,tentA,0])
        translate(tentP)
        children();
    }
}

module counterTent(tentA=0,tentP=tentP) {
    if (tentA==0) {
        children();
    } else {
        highRes=max([15, ceil(tentA) * 2]);
        lowRes=max([1,ceil(tentA/3)]);
        res=$preview ? lowRes : highRes;
        for (r=[0:res]) {
            untent(tentA * (r/res),tentP=tentP) {
                if (r == res) {
                    children();
                } else {
                    intersection() {
                        children();
                        translate([0,-500,-500]-tentP) cube([1000,1000,1000]);
                    }
                }
            }
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

module pcbContour(fill=false) {
    translate([-213.35,144.3,0])
        import("../assets/redox_rev1_contour.stl");
    if (fill) {
        translate([-0.545,90.53,0.8])
            cube([10,10,1.6], center=true);
        translate([-128.845,90.53,0.8])
            cube([10,10,1.6], center=true);
        translate([-128.845,1.90,0.8])
            cube([10,20,1.6], center=true);
        translate([-50,1.9,0.8]) cube([80,20,1.6], center=true);
    }
}

module minkowskier(r,h) {
    hull() {
        if (h > 4) {
            translate([0,0,2]) cylinder(r=r, h=h - 4);
        } else {
            translate([0,0,2]) cylinder(r=r, h=h - 2);
        }
        cylinder(r=r - 1, h=h);
    }
}

module case(tentA=0,
        right=false,
        trrs=true,
        switch=false,
        printedPlate=false,
        fill=true,
        tentingScrews=true) {
    bottomW = 2.5;
    sideW = 4;
    edgeH = 4.5;
    overH = printedPlate? 0.7 : 2.5;
    delta = 0.5;

    mirror(right == false ? [0,0,0] : [1,0,0])
    difference() {
        tent(tentA)
        difference() {
            counterTent(tentA)
                render(convexity = 2)
                minkowski() {
                    union() {
                        pcbContour(fill=fill);
                        children();
                    }
                    translate([0,0,-(edgeH + bottomW)])
                        minkowskier( r=delta+sideW, h=edgeH + bottomW + overH);
                };

            m3hole(p[0]);
            m3hole(p[1]);
            m3hole(p[2]);
            m3hole(p[3]);
            difference() {
                render(convexity = 2)
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
                        if(tentA==0) {
                            for(t=[[[-18*cos(30),18*sin(30),0],[7*cos(30),-7*sin(30),0]]
                                  ,[p[1],p[1]+[0,100,0]]
                                  ,[[-72,37,-1],[-72,56,-1]]
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
                        for(t=[[p[2],p[2]+[-33,0,0],p[2]+[-33,4,1],p[2]+[0,4,1]]
                                ,[p[3],p[3]+[23,0,0],p[3]+[23,6,1],p[3]+[0,6,1]]
                                ,[[-135,0,0],[-135,100,0],[-134,0,0],[-133,100,0]]
                                ,[[-111+30,-9+2,0] ,[-111-20,-9+2,0],[-111+30,-9,0] ,[-111-20,-9,0]]
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
                    if(right==false){
                        translate([0,1,-5.5]) cube([11,35+2,6],center=true);
                    }
                }
                translate([0,17,6])
                translate([0,1,0]) cube([19,1,6],center=true);

                translate(right==false ? [0,27,0] : [0,27,-0.5])
                    hull() {
                        translate([-2.5,0,0]) rotate([90,0,0]) cylinder(d=7.5, h=10);
                        translate([2.5,0,0]) rotate([90,0,0]) cylinder(d=7.5, h=10);
                        translate([-2.5,0,-6]) rotate([90,0,0]) cylinder(d=7.5, h=10);
                        translate([2.5,0,-6]) rotate([90,0,0]) cylinder(d=7.5, h=10);
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
            translate(p[2] + [0,-4.81,0] + (right==true ? [9,0,0] : [14,0,0])) {
                hull() {
                    translate([0,0,-1.5-3]) cube([5,17.26,3], center=true);
                    translate([0,-1,-1.5-3]) cube([7,16.26,3], center=true);
                    translate([0,-1,-0.5-3]) cube([9,15.26,3], center=true);
                }
                if(trrs) {
                    hull() {
                        for(t=[[0,6.5,-5.3/2],
                               (tentA < 2 ? [0,6.5,-5.3/2-6] : [0,6.5,-5.3/2-1])]) {
                            translate(t) rotate([270,0,0]) cylinder(d=8.8,h=10);
                        }
                    }
                }
            }

            // outer bounds
            color("white", 0)
                translate([0,0,100/2+1.6+overH]) cube([1000,1000,100],center=true);

            if (!$preview)
                color("red")
                translate([-120,50,-edgeH-0.3])
                rotate([0,0,90])
                linear_extrude(0.31)
                mirror(right==false ? [0,0,0] : [1,0,0])
                text("github.com/maxhbr",
                        font = "Roboto Condensed:style=bold",
                        size = 6.5,
                        halign = "center");

        }

        if (switch) {
            color("pink")
                translate([-61.5,-3,-1.5]) {
                    difference() {
                        union() {
                            translate([0,-3.5,0])
                                cube([13,7,7],center=true);
                            translate([0,1.7,0]) {
                                hull() {
                                    translate([0,1,0])
                                    cube([13,10,7],center=true);
                                    translate([0,0,3]) cube([13,1,7],center=true);
                                }
                            }
                            translate([0,-7,0])
                                cube([9,14,5],center=true);
                            // latch
                            translate([0,-4.6+7.2,0])
                                union() {
                                    for(m=[[1,0,0],[0,0,0]]) {
                                        mirror(m)
                                            translate([3,0,-5])
                                            cube([0.6,6,10],center=true);
                                    }
                                    translate([0,-2.7,-5])
                                        cube([6,0.6,10],center=true);
                                    translate([0,1.5,-3])
                                        cube([6.6,4,2],center=true);
                                }
                        }
                        translate([0,-4.6+7.2,0])
                            hull() {
                                translate([0,-1.4,-4])
                                    cube([5.4,2,2],center=true);
                                translate([0,-1.4,-4])
                                    cube([4.4,1.5,3],center=true);
                            }
                    }
                }
        }

        if (tentingScrews && tentA > 2.4 && tentA < 5) {
            // tenting
            for(t=tP)
                translate(t + [0,0,-6.5])
                cylinder(h=5.7,d=4+0.2);
        }

        // outer bounds
        color("white", 0.1)
            translate([0,0,-100/2-6.5]) cube([1000,1000,100],center=true);
    }
}

module caseWithLipo(right=false, switch=true, trrs=false) {

    /*
     place for a lipo LP502245
     with e.g. 480mAh
       | W | 22.5mm |
       | H |  5.4mm |
       | L |   47mm |
     */

    tentA=2.5;
    depth=-2.9;
    batteryPos=[-22,24,depth];
    difference() {
        render(convexity = 2)
            case(tentA=tentA, right=right, trrs=trrs, switch=switch);
        mirror(right==false ? [0,0,0] : [1,0,0]) {
            // lipo
            hull() {
                translate(batteryPos)
                    cube([47+1, 22.5+1, 5.4], center=true);
                translate(batteryPos + [0,0,2])
                    cube([47+1, 22.5+1, 5.4], center=true);
                translate(batteryPos + [-1,0,3])
                    cube([47+1, 22.5+1, 5.4], center=true);
            }
            hull() {
                translate(batteryPos)
                    cube([47+1, 22.5+1, 5.4], center=true);
                translate(batteryPos)
                    cube([47+3, 22.5+1, 5.4-2], center=true);
            }
            if (!$preview)
                color("red")
                    translate(batteryPos)
                    translate([0,0,-3])
                    linear_extrude(0.31)
                    mirror(right==false ? [0,0,0] : [1,0,0])
                    text("LP502245",
                            font = "Roboto Condensed:style=bold",
                            size = 6.5,
                            halign = "center");

            translate([-48,13,depth+1]) 
                rotate([0,0,30]) 
                cube([28,8,5.4],center=true);
            translate([-56,13,depth+1]) 
                rotate([0,0,-30]) 
                cube([10,8,5.4],center=true);
            hull() {
                translate([-62,31,depth+1]) cube([12,61,2.6],center=true);
                translate([-62,31,depth+1]) cube([8,57,5.4],center=true);
            }
            /* translate([-78,15,depth+1]) cube([40,30,5.4],center=true); */
        }
    }
}

module tentingKit(aTentA=30) {
    /* intersection() { */
    /*     mirror([0,0,1]) */
    /*         linear_extrude(height = 90, convexity = 10, scale=1) */
    /*         projection(cut = false) pcbContour(fill=true); */
    /* } */
    difference() {
        translate([0,0,-8]) {
            render(convexity = 2)
                counterTent(aTentA,tentP=tentP+[-2,0,0])
                minkowski() {
                    difference() {
                        intersection() {
                            pcbContour(fill=true);
                            translate([-5,0,0])
                                cube([20,200,20],center=true);
                        }
                        translate([-5,35,0])
                            cube([20,60,20],center=true);
                        for(t=tP) {
                            translate(t)
                                rotate([180,0,0])
                                cylinder(h=100,d=20,center=true);
                        }
                    }
                    translate([0,0,-5])
                        minkowskier( r=4.5, h=5);
                };
            minkowski() {
                intersection() {
                    pcbContour(fill=true);
                    translate([-5,0,0])
                        cube([20,200,20],center=true);
                }
                translate([0,0,-5])
                    minkowskier( r=4.5, h=5);
            };
        }
        for(t=tP) {
            translate(t)
                rotate([180,0,0])
                cylinder(h=20,d=3.4);
        }
    }
}

module caseWithLipoExt(right=false, switch=true) {
    difference() {
        case(right=right, trrs=false, switch=switch){
            translate([15,54,0.8]) cube([27,84,1.6],center=true);
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

module helpview(type=0) {
    translate([200,0,0])
        if ($preview) {
            if(type==0) {
                children();
            }
            if(type==1) {
                intersection() {
                    children();
                    union() {
                        translate([-10,0,0])
                        cube([100,100,100],center=true);
                        translate([-100,100,0])
                            cube([100,100,100],center=true);
                    }
                }
            }
        }
}

if(var_type=="case"){
    case(tentA=var_tentA,trrs=var_trrs,switch=false,printedPlate=var_printedPlate);

    translate([200,0,0])
        if ($preview) {
            color("gray")
                mirror(var_right == false ? [0,0,0] : [1,0,0])
                tent(tentA=var_tentA)
                translate([57.25,32.25,-2.4 +5])
                import("../../submodules/Redox-neodox-Case/redox_rev1.0/Neodox_rev1.0-Top-Left_0.12.stl");
        }
}else if(var_type=="caseWithLipoExt"){
    caseWithLipoExt(right=var_right,switch=var_switch);
}else if(var_type=="caseWithLipo") {
    caseWithLipo(right=var_right,trrs=var_trrs,switch=var_switch);

    translate([200,0,0])
        tent(tentA=30)
        if ($preview) {
            caseWithLipo(right=var_right,trrs=var_trrs,switch=var_switch);

            mirror(var_right == false ? [0,0,0] : [1,0,0]) {
                color("gray") translate([-22,24,-2.9]) cube([47, 22.5, 5.4], center=true);
                tent(tentA=2.5)
                    color("green", .7) import("../assets/redox_rev1.stl");
                color("red")
                    tentingKit();
            }
        }
}else if(var_type=="tentKit") {
    mirror($preview ? [0,0,0] : [0,0,1]) {
        tentingKit();

        if ($preview) {
            color("red")
                caseWithLipo(right=false);
        }

        translate([70,0,0]) {
            mirror([1,0,0])
                tentingKit();

            if ($preview) {
                color("red")
                    caseWithLipo(right=true);
            }
        }
    }
}


/* if ($preview) { */
/*     color("gray") translate([-22,24,-2.9]) cube([47, 22.5, 5.4], center=true); */
/* } */
