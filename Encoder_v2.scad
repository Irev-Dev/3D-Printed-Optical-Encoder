include <MCAD/triangles.scad>
////////////Varibles
$fn = 50;
PI = 3.141592653589793238462643383279502884197169399;

//photo interupter
plus = 0.2;
phClear = 0.3; // clearance from the bottom of the channel
senL = 4.5+plus;
senW = 2.6+plus;
senH = 2.9+plus;
senCD = 2; // sensor channel depth
senLegl = 3.55;
senLegs = 2;
senCW = 2; // sensor channel width

// code wheel
    //next two variables determine the code wheel diameter
PPR = 50; //Pulses per revolution (number of teeth)
teethW = 1.2; //width of teeth (mesured at the tip of a tooth)
CWD = PPR*2*teethW/PI;
echo(CWD);
teethH = 5;
wheelD = 1.2; //wheel depth or thickness
bore = 2.3;

//case
wall = 1.5;
screwD = 3;


/////////////RENDERS

wheel();
/*rotate([90,0,0])  {
    senhousing(2.75);
    senhousing(-2.75);
    senbase();
}*/
rotate([0,90,0])  {
    throughHole(-1.625,0.8);
    throughHole(1.625,0.8);
}


//////////////MODULES
module throughHole(whichtooth,thick){
    rotate([0,0,whichtooth*180/PPR]) difference(){
        difference(){
            union(){
                translate([CWD/2+senH-senCD,-senW/2-thick,-senL/2-thick]) cube([wall,senW+2*thick,senL+2*thick]);    
            }
            union(){
                translate([CWD/2-senH-senCD,senLegs/2,senLegl/2]) rotate([0,90,0]) cylinder(h=15*wall,d=1.2);
                translate([CWD/2-senH-senCD,-senLegs/2,senLegl/2]) rotate([0,90,0]) cylinder(h=15*wall,d=1.2);
                translate([CWD/2-senH-senCD,senLegs/2,-senLegl/2]) rotate([0,90,0]) cylinder(h=15*wall,d=1.2);
                translate([CWD/2-senH-senCD,-senLegs/2,-senLegl/2]) rotate([0,90,0]) cylinder(h=15*wall,d=1.2);
            }
        }
    }
}

module senbase(){
    rotate([0,0,180*0/PPR]){
        difference(){
            translate([-12*teethW,CWD/2-wall,-wall-senL/2]) cube([24*teethW,screwD*2,wall]);
            union(){
                translate([-12*teethW+screwD,CWD/2-wall+screwD,-wall*1.5-senL/2]) cylinder(h=wall*3,d=screwD);
                translate([+12*teethW-screwD,CWD/2-wall+screwD,-wall*1.5-senL/2]) cylinder(h=wall*3,d=screwD);
            }
        }
    }
}

module senhousing(whichtooth){
    rotate([0,0,whichtooth*180/PPR]) difference(){
        union(){
            translate([-senW/2-wall,CWD/2-wall-senCD+phClear,-senL/2-wall]) cube([senW+2*wall,senH+2*wall,senL+2*wall]);
        }
        union(){
            translate([-senW/2,CWD/2-senCD+phClear,-senL/2]) cube([senW,senH*4,senL]);
            translate([0,0,-senCW/2]) cylinder(h=senCW,d=CWD+phClear);
        }
    }
    
}

module wheel() {
    difference(){
        union(){
            translate([0,0,-wheelD/2]) cylinder(h=wheelD,d=CWD-teethH);
            //translate([0,0,+wheelD/2]) cylinder(h=(-wheelD+senCW)/2+wall*4,d=bore+wall*2);
            translate([0,0,+wheelD/2]) cylinder(h=(-wheelD+senCW)/2+wall,d=CWD-teethH-wall*4);
            translate([0,0,+wheelD/2]) cylinder(h=(-wheelD+senCW)/2,d1=CWD-teethH,d2=CWD-teethH-wall*4);
            intersection(){
                for(i=[0:PPR-1]){
                    rotate([0,0,i*360/PPR]) translate([-CWD,0,-wheelD/2]) a_triangle(180/PPR, CWD, wheelD);
                }
                translate([0,0,-wheelD/2]) cylinder(h=wheelD*2,d=CWD);
            }
        }
        union(){
            translate([0,0,-wall*15]) cylinder(h=wall*30,d=bore);
        }
    }
}