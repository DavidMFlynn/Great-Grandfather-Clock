// **********************************************************
// Power Input
// Filename: GGC_DriveSprocket.scad
// Project: Great Grandfather Clock
// Created: 10/26/2018
// Revision: 0.1 10/26/2018
// Units: mm
// *********************************************************
// History:
// 0.1 10/26/2018 First code
// *********************************************************
// for STL output
//	sprocket(teeth=20,roller_d=Roller_d,pitch=Pitch,thickness=RollerWidth/2, Hub_diameter=0,Hub_thickness=0,Bore_diameter=SprocketBore_d,Holes=0,Chamfer=true,Stretch=0.012); // Print 2
// DriveSprocket(myFn=360);
// DriveBearing(myFn=360);
// rotate([180,0,0]) BreakWheel();
// TwoPartBallSpacer(BallCircle_d=BallCircle_d,Ball_d=Ball_d,nBalls=16);
// *********************************************************
// for Viewing
// ShowCompleteDrive();
//
//translate([0,0,20]) ShowSprocket();
//DriveBearing(myFn=90);
//BreakWheel(); // glued to DriveBearing
//translate([0,0,20+Bearing_w/2]) TwoPartBallSpacer(BallCircle_d=BallCircle_d,Ball_d=Ball_d,nBalls=16);
//translate([0,0,20+Bearing_w/2]) rotate([180,0,0]) TwoPartBallSpacer(BallCircle_d=BallCircle_d,Ball_d=Ball_d,nBalls=16);

//ShowPlanets();
//translate([0,0,13]) rotate([0,0,360/nSunTeeth/2]) SunGear();
//translate([0,0,13]) DriveRingGear();
// *********************************************************

include<BearingLib.scad>
// OnePieceInnerRace(BallCircle_d=100,	Race_ID=50,	Ball_d=9.525, Race_w=10, PreLoadAdj=0.00, VOffset=0.00, myFn=360);
// OnePieceOuterRace(BallCircle_d=60, Race_OD=75, Ball_d=9.525, Race_w=10, PreLoadAdj=0.00, VOffset=0.00, myFn=360);
include<Sprocket.scad>
//sprocket(teeth=20,roller_d=Roller_d,pitch=Pitch,thickness=RollerWidth/2,
//	Hub_diameter=0,Hub_thickness=0,Bore_diameter=140,Holes=0,Chamfer=true,Stretch=0.012);
include<PlanetDriveLib.scad>
//include<CompoundHelicalPlanetary.scad>

PlanetaryPitch=300;
BackLash=0.4;
Pressure_a=20;
GearWidth=13;
DrivePlateXtra_d=12;
nPlanetTeeth=23;
nSunTeeth=16;

$fn=90;
Overlap=0.05;
IDXtra=0.2;

BallCircle_d=150;
Ball_d=9.525;
BearingPreload=0.00;

//DMFE 80L
Roller_d=11;
Pitch=25.4;
RollerWidth=6;
SprocketBore_d=140;

Ratchet_d=120;
ChainSpacer_w=5;
Bearing_w=10;
	
module ShowCompleteDrive(){
	translate([0,0,20]) ShowSprocket();
	DriveBearing(myFn=90);
		BreakWheel(); // glued to DriveBearing
	
	translate([0,0,20+Bearing_w/2]) TwoPartBallSpacer(BallCircle_d=BallCircle_d,Ball_d=Ball_d,nBalls=16);
	translate([0,0,20+Bearing_w/2]) rotate([180,0,0]) TwoPartBallSpacer(BallCircle_d=BallCircle_d,Ball_d=Ball_d,nBalls=16);

	ShowPlanets();
	translate([0,0,13+GearWidth+0.5]) PlanetCarrierTop();
	translate([0,0,13]) rotate([0,0,360/nSunTeeth/2]) SunGear();
	
	translate([0,0,13]) DriveRingGear();
} // ShowCompleteDrive

// ShowCompleteDrive();

module DriveBearing(myFn=90){
	Height=20;
	nBolts=8;
	Race_OD=BallCircle_d+2*Ball_d;
	
	difference(){
		cylinder(d=Race_OD,h=Height+Overlap,$fn=myFn);
		
		translate([0,0,-Overlap]) cylinder(d=Race_OD-5,h=Height-8+Overlap*2,$fn=myFn);
		translate([0,0,Height-8]) cylinder(d1=Race_OD-5,d2=Race_OD-12.5,h=8+Overlap*3,$fn=myFn);
		
	} // diff
	
	translate([0,0,Height])
	OnePieceOuterRace(BallCircle_d=BallCircle_d, Race_OD=Race_OD, Ball_d=Ball_d, Race_w=Bearing_w, PreLoadAdj=0.00, VOffset=0.00, myFn=myFn);
	
	difference(){
		cylinder(d=Race_OD-1,h=2);
		translate([0,0,-Overlap]) cylinder(d=SprocketBore_d-1,h=2+Overlap*2);
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([Race_OD/2-8,0,2]) Bolt6ClearHole();
	} // diff
} // DriveBearing

//DriveBearing(myFn=90);

module BreakWheel(){
	translate([0,0,13]) PawlWheel(nTeeth=6, Ratchet_OD=Ratchet_d, OD=SprocketBore_d-1);
	
	difference(){
		cylinder(d=SprocketBore_d-1,h=13+Overlap);
		translate([0,0,-Overlap]) cylinder(d=SprocketBore_d-6,h=13+Overlap*3);
	} // diff
} // BreakWheel

//BreakWheel();

module DriveSprocket(myFn=90){
	
	
	//translate([0,0,RollerWidth])
	OnePieceInnerRace(BallCircle_d=BallCircle_d,
						Race_ID=BallCircle_d-Ball_d*2,
						Ball_d=Ball_d, Race_w=Bearing_w,
						PreLoadAdj=BearingPreload, VOffset=0.00, myFn=myFn);
	
	PawlWheel(nTeeth=6, Ratchet_OD=Ratchet_d, OD=SprocketBore_d-1);
	
	translate([0,0,Bearing_w-Overlap])
	difference(){
		cylinder(d=SprocketBore_d+2,h=ChainSpacer_w+Overlap);
		
		translate([0,0,-Overlap]) cylinder(d=SprocketBore_d-5,h=ChainSpacer_w+Overlap*3);
	} // diff
	
	translate([0,0,Bearing_w+ChainSpacer_w-Overlap])
	difference(){
		cylinder(d=SprocketBore_d,h=RollerWidth+Overlap);
		
		translate([0,0,-Overlap]) cylinder(d=SprocketBore_d-5,h=RollerWidth+Overlap*3);
	} // diff
} // DriveSprocket

//DriveSprocket();

module ShowSprocket(){
	DriveSprocket();
	
	translate([0,0,Bearing_w+ChainSpacer_w+RollerWidth/2])
		sprocket(teeth=20,roller_d=Roller_d,pitch=Pitch,thickness=RollerWidth/2, Hub_diameter=0,Hub_thickness=0,Bore_diameter=SprocketBore_d,Holes=0,Chamfer=true,Stretch=0.012);

	translate([0,0,Bearing_w+ChainSpacer_w+RollerWidth/2]) rotate([180,0,0])
		sprocket(teeth=20,roller_d=Roller_d,pitch=Pitch,thickness=RollerWidth/2, Hub_diameter=0,Hub_thickness=0,Bore_diameter=SprocketBore_d,Holes=0,Chamfer=true,Stretch=0.012);
} // ShowSprocket

//ShowSprocket();
Twist=200;

module PlanetGear(){
translate([0,0,GearWidth/2])
gear (number_of_teeth=nPlanetTeeth,
			circular_pitch=PlanetaryPitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=GearWidth/2,
			rim_thickness=GearWidth/2,
			rim_width=3.5,
			hub_thickness=GearWidth/2,
			hub_diameter=0,
			bore_diameter=6.35,
			circles=0,
			backlash=BackLash,
			twist=Twist/nPlanetTeeth,
			involute_facets=0,
			flat=false);

translate([0,0,GearWidth/2]) mirror([0,0,1])
gear (number_of_teeth=nPlanetTeeth,
			circular_pitch=PlanetaryPitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=GearWidth/2,
			rim_thickness=GearWidth/2,
			rim_width=3.5,
			hub_thickness=GearWidth/2,
			hub_diameter=0,
			bore_diameter=6.35,
			circles=0,
			backlash=BackLash,
			twist=Twist/nPlanetTeeth,
			involute_facets=0,
			flat=false);
	}
		
module ShowPlanets(){
translate([nSunTeeth * PlanetaryPitch / 360 + nPlanetTeeth * PlanetaryPitch / 360,0,13]) rotate([0,0,360/nPlanetTeeth/2]) PlanetGear();
rotate([0,0,120])
translate([nSunTeeth * PlanetaryPitch / 360 + nPlanetTeeth * PlanetaryPitch / 360,0,13]) rotate([0,0,360/nPlanetTeeth*0.833]) PlanetGear();
rotate([0,0,-120])
translate([nSunTeeth * PlanetaryPitch / 360 + nPlanetTeeth * PlanetaryPitch / 360,0,13]) rotate([0,0,-360/nPlanetTeeth*0.833]) PlanetGear();
}

//ShowPlanets();

module PlanetCarrierTop(){
	nPlanets=3;
	Planet_r=nSunTeeth * PlanetaryPitch / 360 + nPlanetTeeth * PlanetaryPitch / 360;
	SunGearClearanceHole_d=nSunTeeth * PlanetaryPitch / 180 + 10;
	PC_t=4;
	
	difference(){
		union(){
			cylinder(d=Planet_r*1.71,h=PC_t);
			
			for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j])
			hull(){
				translate([Planet_r,0,0]) cylinder(d=20,h=PC_t);
				cylinder(d=20,h=PC_t);
			} 
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=SunGearClearanceHole_d,h=PC_t+Overlap*2);
		
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([Planet_r,0,PC_t]) Bolt4ClearHole();
		
	} // diff
	
} // PlanetCarrierTop

//translate([0,0,13+GearWidth+0.5]) PlanetCarrierTop();


module SunGear(){
translate([0,0,GearWidth/2])
gear (number_of_teeth=nSunTeeth,
			circular_pitch=PlanetaryPitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=GearWidth/2,
			rim_thickness=GearWidth/2,
			rim_width=3.5,
			hub_thickness=GearWidth/2,
			hub_diameter=0,
			bore_diameter=6.35,
			circles=0,
			backlash=BackLash,
			twist=-Twist/nSunTeeth,
			involute_facets=0,
			flat=false);

translate([0,0,GearWidth/2]) mirror([0,0,1])
gear (number_of_teeth=nSunTeeth,
			circular_pitch=PlanetaryPitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=GearWidth/2,
			rim_thickness=GearWidth/2,
			rim_width=3.5,
			hub_thickness=GearWidth/2,
			hub_diameter=0,
			bore_diameter=6.35,
			circles=0,
			backlash=BackLash,
			twist=-Twist/nSunTeeth,
			involute_facets=0,
			flat=false);
	} // SunGear
	
//translate([0,0,13]) rotate([0,0,360/nSunTeeth/2]) SunGear();
	
module DriveRingGear(){
	//RingGear(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth, Thickness=GearWidth);
	//nPlanetTeeth=23;
	//nSunTeeth=16;
	
	
	pitch_diameter  =  (nPlanetTeeth * PlanetaryPitch / 180) * 2 + nSunTeeth * PlanetaryPitch / 180;
	RingTeeth=pitch_diameter * 180 / PlanetaryPitch;
	
	echo(RingTeeth=RingTeeth);
	
	translate([0,0,GearWidth/2])
	ring_gear(number_of_teeth=RingTeeth,
		circular_pitch=PlanetaryPitch, diametral_pitch=false,
		pressure_angle=Pressure_a,
		clearance = 0.4,
		gear_thickness=GearWidth/2,
		rim_thickness=GearWidth/2,
		rim_width=3.5,
		backlash=BackLash,
		twist=Twist/RingTeeth,
		involute_facets=0, // 1 = triangle, default is 5
		flat=false);
	
	translate([0,0,GearWidth/2])
	mirror([0,0,1])
	ring_gear(number_of_teeth=RingTeeth,
		circular_pitch=PlanetaryPitch, diametral_pitch=false,
		pressure_angle=Pressure_a,
		clearance = 0.4,
		gear_thickness=GearWidth/2,
		rim_thickness=GearWidth/2,
		rim_width=3.5,
		backlash=BackLash,
		twist=Twist/RingTeeth,
		involute_facets=0, // 1 = triangle, default is 5
		flat=false);

	RatchetWheel(nTeeth=20, OD=Ratchet_d, ID=Ratchet_d-8, Width=13);
	
} // DriveRingGear

//translate([0,0,13]) DriveRingGear();

module RatchetWheel(nTeeth=20, OD=100, ID=88, Width=6){
	difference(){
		union(){
			cylinder(d=OD-5, h=Width);
			for (j=[0:nTeeth-1]) rotate([0,0,360/nTeeth*j])
				translate([0,OD/2-4,0]) rotate([0,0,10]) cylinder(d=10,h=Width,$fn=3);
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=ID,h=Width+Overlap*2);
	} // diff
	
} // RatchetWheel

//RatchetWheel();

module FreePawl(Thickness=6){
	Ratchet_OD=100;
	
	difference(){
		
			translate([0,Ratchet_OD/2+1.71,0]) 
				rotate([0,0,190]) cylinder(d=10,h=Thickness,$fn=3);
			
		translate([0,0,-Overlap])
			difference(){
				cylinder(d=Ratchet_OD+15,h=Thickness+Overlap*2);
				translate([0,0,-Overlap])cylinder(d=Ratchet_OD+3,h=Thickness+Overlap*4);
			} // diff
		
	} // diff
	
	
		hull(){
			 translate([2,Ratchet_OD/2+1.71,0]) cylinder(d=2,h=Thickness);
			rotate([0,0,17]) translate([0,Ratchet_OD/2+4,0])	cylinder(d=2,h=Thickness);}
		hull(){
			rotate([0,0,17]) translate([0,Ratchet_OD/2+4,0])	cylinder(d=2,h=Thickness);
			rotate([0,0,17]) translate([0,Ratchet_OD/2+8,0])	cylinder(d=2,h=Thickness);}
		rotate([0,0,17]) translate([0,Ratchet_OD/2+8,0]) cylinder(d=5,h=Thickness);
	
} // FreePawl

//FreePawl(Thickness=5);

module FreePawlWheel(nTeeth=6, Ratchet_OD=100, OD=124, Thickness=6){
	difference(){
		cylinder(d=OD,h=Thickness);
		
		translate([0,0,-Overlap]) cylinder(d=Ratchet_OD+10,h=Thickness+Overlap*2);
		
		for (j=[0:nTeeth-1]) rotate([0,0,360/nTeeth*j+17]){
			translate([0,Ratchet_OD/2+8,1]) cylinder(d=5+IDXtra*2,h=Thickness);
			
			hull(){
				translate([0,Ratchet_OD/2+4,1])	cylinder(d=3,h=Thickness);
				translate([0,Ratchet_OD/2+8,1])	cylinder(d=3,h=Thickness);}
		}
	} // diff
	
	// show Pawls
	//translate([0,0,1+Overlap]) for (j=[0:nTeeth-1]) rotate([0,0,360/nTeeth*j]) FreePawl(Thickness=5);
	
} // FreePawlWheel

//FreePawlWheel();

module PawlWheel(nTeeth=6, Ratchet_OD=100, OD=116){
	Thickness=6;
	
	// teeth
	difference(){
		for (j=[0:nTeeth-1]) rotate([0,0,360/nTeeth*j]) 
			translate([0,Ratchet_OD/2+1.71,0]) 
				rotate([0,0,190]) cylinder(d=10,h=Thickness,$fn=3);
			
		translate([0,0,-Overlap])
			difference(){
				cylinder(d=Ratchet_OD+15,h=Thickness+Overlap*2);
				translate([0,0,-Overlap])cylinder(d=Ratchet_OD+3,h=Thickness+Overlap*4);
			} // diff
		
	} // diff
	
	// connectors
	for (j=[0:nTeeth-1]) {
		hull(){
			rotate([0,0,360/nTeeth*j]) translate([2,Ratchet_OD/2+1.71,0]) cylinder(d=2,h=Thickness);
			rotate([0,0,360/nTeeth*j+17]) translate([0,Ratchet_OD/2+4,0])	cylinder(d=2,h=Thickness);}
		hull(){
			rotate([0,0,360/nTeeth*j+17]) translate([0,Ratchet_OD/2+4,0])	cylinder(d=2,h=Thickness);
			rotate([0,0,360/nTeeth*j+17]) translate([0,Ratchet_OD/2+6,0])	cylinder(d=2,h=Thickness);}
		}
	
	difference(){
		cylinder(d=OD,h=Thickness);
		
		translate([0,0,-Overlap]) cylinder(d=Ratchet_OD+10,h=Thickness+Overlap*2);
	} // diff
} // PawlWheel

//PawlWheel();







