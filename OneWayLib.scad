// ********************************************
// One Way Drive Library
// Created: 6/30/2019
// Revision: 1.0.0 6/30/2019
// Units: mm
// ********************************************
//  ***** History *****
// 1.0.0 6/30/2019 First Code
// ********************************************
//  ***** for STL output *****
// OneWayShaft(Ball_d=Ball_d, BC=50);
// OneWayRing(Ball_d=Ball_d, BC=50);
// ********************************************
//  ***** for Viewing *****
// ShowBalls(Ball_d=Ball_d, BC=50, Open=true);
// ********************************************

echo("OneWayLib 1.0.0");

Overlap=0.05;
IDXtra=0.2;
$fn=90;

Ball_d=5/16*25.4;
nBalls=5;

module ShowBalls(Ball_d=Ball_d, BC=50, Open=false){
	BallOffset = Open==false? 0:-Ball_d*1.6;
	
	for (j=[0:nBalls-1]) rotate([0,0,360/nBalls*j+asin(Ball_d/BC)])
		translate([BC/2,BallOffset,Ball_d/2]) sphere(d=Ball_d);
} // ShowBalls

module OneWayShaft(Ball_d=Ball_d, BC=50){
	difference(){
		union(){
			cylinder(d=BC-Ball_d,h=Ball_d);
			for (j=[0:nBalls-1]) rotate([0,0,360/nBalls*j])
				translate([BC/2-Ball_d+Ball_d/3,0,0]) cylinder(d=Ball_d,h=Ball_d);
		} // union
		
		for (j=[0:nBalls-1]) rotate([0,0,360/nBalls*j+asin(Ball_d/BC)])
				translate([BC/2,0,-Overlap]) cylinder(d=Ball_d+IDXtra,h=Ball_d+Overlap*2);
	} // diff
} // OneWayShaft

//rotate([0,0,-asin(Ball_d/50)-8]) OneWayShaft(Ball_d=Ball_d, BC=50);

module OneWayRing(Ball_d=Ball_d, BC=50){
	difference(){
		cylinder(d=BC+Ball_d*2+2,h=Ball_d);
		
		translate([0,0,-Overlap]) cylinder(d=BC,h=Ball_d+Overlap*2);
		
		for (j=[0:nBalls-1]) rotate([0,0,360/nBalls*j]) hull(){
			translate([BC/2,0,-Overlap]) cylinder(d=Ball_d+IDXtra,h=Ball_d+Overlap*2);
				translate([BC/2,-Ball_d*1.6,-Overlap]) 
					cylinder(d=Ball_d+IDXtra,h=Ball_d+Overlap*2);
		}
	} // diff
} // OneWayRing

//rotate([0,0,asin(Ball_d/50)]) OneWayRing(Ball_d=Ball_d, BC=50);



















