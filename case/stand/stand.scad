

module pin(t) {
    baser = 4;
    pinr = 2;
    translate(t) {
        translate([0,0,3]) {
            translate([0,0,-0.25])
                cylinder(h = 7, r1 = baser, r2 = baser, center = true);
            translate([0,0,0.25]) {
                translate([0,0,3.5]) {
                    cylinder(h = 1, r1 = baser, r2 = baser * 0.9, center = true);
                };
                translate([0,0,4.5]) {
                    cylinder(h = 3, r1 = pinr, r2 = pinr, center = true);
                    translate([0,0,2.5]) {
                        cylinder(h = 2, r1 = pinr, r2 = pinr * 0.6, center = true);
                    };
                };
            };
        };
    };
}

module base(t) {
    translate(t) {
        cylinder(h=3, r=4);
        cylinder(h=1.5, r=10, center=true);
    };
}

module bar(t1, t2) {
    difference() {
        hull() {base(t1); base(t2);};
        hull() {translate(t1) cylinder(r=1, h=10, center=true); translate(t2) cylinder(r=3, h=10, center=true);};
    }
}

p = [[0,0,0], [110.49,15.287,0], [17.145,92.202,0], [127.635,90.297,0]];

module stand() {
    pin(p[0]);
    pin(p[1]);
    pin(p[2]);
    pin(p[3]);

    bar(p[0], p[1]);
    bar(p[0], p[2]);
    bar(p[0], p[3]);
}

$fs = 0.01;

stand();
translate([100,180,0])
mirror([1,0.7,0]) stand();
