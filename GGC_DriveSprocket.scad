// **********************************************************
// Power Input
// Filename: DriveSprocket.scad
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

// *********************************************************


include<BearingLib.scad>
// OnePieceInnerRace(BallCircle_d=100,	Race_ID=50,	Ball_d=9.525, Race_w=10, PreLoadAdj=0.00, VOffset=0.00, myFn=360);
// OnePieceOuterRace(BallCircle_d=60, Race_OD=75, Ball_d=9.525, Race_w=10, PreLoadAdj=0.00, VOffset=0.00, myFn=360);
include<Sprocket.scad>
//sprocket(teeth=20,roller_d=Roller_d,pitch=Pitch,thickness=RollerWidth/2,
//	Hub_diameter=0,Hub_thickness=0,Bore_diameter=140,Holes=0,Chamfer=true,Stretch=0.012);
include<PlanetDriveLib.scad>

PlanetaryPitch=300;
BackLash=0.4;
Pressure_a=20;
GearWidth=8;
DrivePlateXtra_d=12;
nPlanetTeeth=30;
nSunTeeth=15;

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

module DriveSprocket(){
	
	difference(){
		cylinder(d=SprocketBore_d,h=RollerWidth+Overlap);
		
		translate([0,0,-Overlap]) cylinder(d=SprocketBore_d-5,h=RollerWidth+Overlap*3);
	} // diff
	
	translate([0,0,RollerWidth])
	OnePieceInnerRace(BallCircle_d=BallCircle_d,
						Race_ID=BallCircle_d-Ball_d*2,
						Ball_d=Ball_d, Race_w=10,
						PreLoadAdj=BearingPreload, VOffset=0.00, myFn=360);
	
	RingGear(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth, Thickness=8);
} // DriveSprocket

DriveSprocket();










