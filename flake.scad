// jedna odnož se zaoblením
module leg (r, d, $fn=30) {
    union() {
        sphere(r);
        cylinder(r=r,d);
        translate([0,0,d]) sphere(r);   
    }
}
// jedna vetev vlocky
module branch(branchCount, circr, r, ang) {
    c = circr - r;
    if (branchCount == 1)
        leg(r, c);
    else {
        x = sqrt((c*c)/(13-(12*cos(180-ang)))); // Cosinova věta
        leg( r, 3*x );
        for (i = [0:branchCount-1])
            rotate([0,0,i*360/branchCount]) translate([0,0,3*x]) rotate([0,ang,0]) leg(r, 2*x);
    }
}
// modul pro vlocku
module flake(branches=[], circr=30, r=3, ang=45) {
    // Fibonacci Sphere Algorithm
    // http://stackoverflow.com/questions/9600801/evenly-distributing-n-points-on-a-sphere/26127012#26127012
    golang = PI*(3-sqrt(5)); //Zlatý úhel
    CountOfBranches = len(branches);
    offset = 2/CountOfBranches;
    union(){
        for (i = [0:CountOfBranches-1]) {
            phi = (i % CountOfBranches) * golang * 180/PI;
            y = ((i * offset) - 1) + (offset / 2);
            fr = sqrt(1 - y*y);
            x = cos(phi) * fr;
            z = sin(phi) * fr;
            // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#rotate
            rotate([0, acos(z/norm([x,y,z])), atan2(y,x)]) branch(branches[i], circr, r, ang);
        }
    }
}
