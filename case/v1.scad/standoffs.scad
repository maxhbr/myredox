
module standoff(t) {
    translate(t)
difference(){
    hull(){
    rotate([0,0,30])
    cylinder(h=2,d=6,$fn=6);
    translate([0,0,1.5])
    cylinder(h=2,d=6,$fn=6);
    }
    cylinder(h=3.5,d=3,$fn=100);
}
}

standoff([0,0]);
standoff([10,0]);
standoff([20,0]);
standoff([30,0]);
standoff([40,0]);
standoff([0,10]);
standoff([10,10]);
standoff([20,10]);
standoff([30,10]);
standoff([40,10]);
standoff([0,20]);
standoff([10,20]);
standoff([20,20]);
standoff([30,20]);
standoff([40,20]);
standoff([0,30]);
standoff([10,30]);
standoff([20,30]);
standoff([30,30]);
standoff([40,30]);