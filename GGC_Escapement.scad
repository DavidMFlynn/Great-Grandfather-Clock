// **********************************************************
// Escapement
// Filename: GGC_Escapement.scad
// Project: Great Grandfather Clock
// Created: 10/31/2018
// Revision: 0.2 11/1/2018
// Units: mm
// *********************************************************
// History:
// 0.2 11/1/2018  Moved WebbedSpoke to WebbedSpokeLib.scad
// 0.1 10/31/2018 First code
// *********************************************************
// for STL output
// EscapementWheel();
// EscapementRocker();
// EscapementDriveGear();
// PendulumMountSpline();
// PendulumHanger();
// *********************************************************
// Routines
// EscapeTooth(ToothLen=12,Thickness=3);
// EscapementDriveGear();
// *********************************************************
// for Viewing
// ShowEscapementNPendulum();
// *********************************************************
include<GGC_Basic.scad>
/*
include<CommonStuffSAEmm.scad>
include<WebbedSpokeLib.scad>
// WebbedSpoke(ID=25,OD=100,Spoke_w=5,Spoke_h=2,Web_h=4);
include<SplineLib.scad>
//SplineShaft(d=20,l=30,nSplines=Spline_nSplines,Spline_w=30,Hole=Spline_Hole_d,Key=false);
// SplineHole(d=20,l=20,nSplines=Spline_nSplines,Spline_w=30,Gap=IDXtra,Key=false);
include<involute_gears.scad>

$fn=90;
Overlap=0.05;
IDXtra=0.2;

Pressure_a=20;
GearPitch=300;
GearBacklash=0.4;
*/
GGC_Escapement_h=5;

module ShowEscapementNPendulum(){
	translate([0,0,-GGC_Hub_h-Overlap*2]) color("Gold") EscapementDriveGear();
	
	color("Blue") rotate([0,0,360/15*$t]) EscapementWheel();
	
	translate([0,90,GGC_Escapement_h+2+Overlap*2]) color("Tan") PendulumHanger();
	translate([0,90,-GGC_Hub_h-Overlap*2]) color("LightBlue") PendulumMountSpline();
	
	translate([0,90,0]) rotate([0,0,abs(1-$t*2)*8-4]) EscapementRocker();
	
	rotate([0,0,-15]) translate([-25-50,0,-GGC_Hub_h-Overlap*2]) rotate([0,0,180/60-1]) 
		color("Green") SpokedGear(nTeeth=60,nSpokes=5,HasSpline=false);
}// ShowEscapementNPendulum


module EscapeTooth(ToothLen=12,Thickness=3){
	translate([ToothLen,0,0]) cylinder(d=2,h=Thickness);
	/*
	hull(){
		cylinder(d=2,h=Thickness);
		translate([ToothLen,-6,0]) cylinder(d=2,h=Thickness);
		translate([0,4,0]) cylinder(d=2,h=Thickness);
	} // hull
	/**/
	/*
	difference(){
		translate([0,1,0]) cube([ToothLen-1,ToothLen-1,Thickness]);
		translate([ToothLen-1,ToothLen-1+1,-Overlap]) cylinder(r=ToothLen-1+Overlap,h=Thickness+Overlap*2);
		
	} // diff
	/**/
} // EscapeTooth

//EscapeTooth();

module PendulumMountSpline(){
	SplineHub(Hub_d=GGC_Hub_d,SpineLen=GGC_Hub_h*2+GGC_Escapement_h+2,Bore_d=GGC_Bore_d);
} // PendulumMountSpline

//PendulumMountSpline();

module EscapementDriveGear(){
	SpokedGear(nTeeth=30,nSpokes=5);
} // EscapementDriveGear

//EscapementDriveGear();

module EscapementTopper(){
	TopperThickness=5;
	Hub_d=GGC_Hub_d;
	
	cylinder(d=Hub_d,h=TopperThickness);
	rotate([0,0,-30])translate([0,-85,0]) cylinder(d=Hub_d,h=TopperThickness);
	rotate([0,0,30])translate([0,-85,0]) cylinder(d=Hub_d,h=TopperThickness);
	translate([0,90,0]) cylinder(d=Hub_d,h=TopperThickness);
} // EscapementTopper

//translate([0,0,GGC_Hub_h+7+Overlap*2]) EscapementTopper();

module PendulumHanger(){
	Hub_d=GGC_Hub_d;
	
	//Hub
	difference(){
		union(){
			cylinder(d=Hub_d,h=GGC_Hub_h);
			translate([0,-30,0]) cylinder(d=75,h=5);
		} // union
		
		translate([0,-40,-Overlap]) cylinder(d=58,h=5+Overlap*2);
		
		//translate([0,0,-Overlap]) cylinder(d=6.35,h=10+Overlap*2);
		translate([0,0,-Overlap])
			SplineHole(d=Hub_d-6,l=GGC_Hub_h+Overlap*2,nSplines=4,Spline_w=30,Gap=IDXtra,Key=false);
	} // diff
	
	translate([0,-90,0])
	difference(){
		union(){
			cylinder(d=100,h=5);
			translate([0,-55,0]) cylinder(d=Hub_d,h=5);
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=85,h=5+Overlap*2);
		
		translate([0,-55,-Overlap])
			SplineHole(d=Hub_d-6,l=GGC_Hub_h+Overlap*2,nSplines=GGC_nSplines,Spline_w=30,Gap=IDXtra,Key=false);
		
	} // diff
} // PendulumHanger

//translate([0,90,10+Overlap*2]) 
//PendulumHanger();



module EscapementWheel(nTeeth=30, OD=120,Thickness=GGC_Escapement_h){
	nSpokes=5;
	Hub_d=20;
	
	for (j=[0:nTeeth-1]) rotate([0,0,360/nTeeth*j]) 
		translate([OD/2-2,0,0]) EscapeTooth(ToothLen=12,Thickness=Thickness);
	
	difference(){
		cylinder(d=OD,h=Thickness);
		
		translate([0,0,-Overlap]) cylinder(d=OD-6,h=Thickness+Overlap*2);
	} // diff
	
	for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
	WebbedSpoke(ID=15,OD=OD-6,Spoke_w=5,Spoke_h=2,Web_h=3);
	
	//Hub
	difference(){
		cylinder(d=Hub_d,h=GGC_Hub_h);
		//translate([0,0,-Overlap]) cylinder(d=6.35,h=10+Overlap*2);
		translate([0,0,-Overlap])
			SplineHole(d=Hub_d-6,l=GGC_Hub_h+Overlap*2,nSplines=GGC_nSplines,Spline_w=30,Gap=IDXtra,Key=false);
	} // diff
} // EscapementWheel

//rotate([0,0,-6.6]) //align to entry pallet
//rotate([0,0,-10.6]) // Entry release
//rotate([0,0,-12.4]) //align to exit pallet
//rotate([0,0,-17]) // exit release
rotate([0,0,-6.6-12]) //align to entry pallet
EscapementWheel();

//*
translate([0,115,0]) rotate([0,0,-4+abs($t-0.5)*16])
//rotate([0,0,-3]) // Entry release
//rotate([0,0,3]) // exit release

{ 
	EscapementRocker();
	rotate([0,0,7.5]) EntryPallet();
	rotate([0,0,-7.5]) ExitPallet();
}
/**/



module EntryPallet(OD=120,Thickness=GGC_Escapement_h){
	difference(){
		cylinder(d=OD*1.4,h=GGC_Escapement_h);
		
		translate([0,0,-Overlap]) cylinder(d=OD*1.4-8,h=GGC_Escapement_h+Overlap*2);
		
		rotate([0,0,25]) translate([-OD,0,-Overlap]) cube([OD*2,OD,GGC_Escapement_h+Overlap*2]);
		rotate([0,0,-130]) translate([-OD,0,-Overlap]) cube([OD*2,OD,GGC_Escapement_h+Overlap*2]);
		rotate([0,0,45]) translate([-OD*0.7+Overlap,0,-Overlap]) rotate([0,0,-135]) cube([8,8,GGC_Escapement_h+Overlap*2]);
		//#cylinder(d=5,h=GGC_Escapement_h+Overlap*2);
	} // diff
} // EntryPallet

//translate([0,90,0]) // center of anchor
//EntryPallet();

module ExitPallet(OD=120,Thickness=GGC_Escapement_h){
	difference(){
		cylinder(d=OD*1.4,h=GGC_Escapement_h);
		
		translate([0,0,-Overlap]) cylinder(d=OD*1.4-8,h=GGC_Escapement_h+Overlap*2);
		
		rotate([0,0,-25]) translate([-OD,0,-Overlap]) cube([OD*2,OD,GGC_Escapement_h+Overlap*2]);
		rotate([0,0,130]) translate([-OD,0,-Overlap]) cube([OD*2,OD,GGC_Escapement_h+Overlap*2]);
		rotate([0,0,-45]) translate([OD*0.7-4-Overlap,0,-Overlap]) rotate([0,0,135+90]) cube([8,8,GGC_Escapement_h+Overlap*2]);
		//#cylinder(d=5,h=GGC_Escapement_h+Overlap*2);
		
	} // diff
} // ExitPallet

//translate([0,90,0]) // center of anchor
//ExitPallet();

module EscapementRocker(OD=120,Thickness=GGC_Escapement_h){
	Extention=0.75;
	
	difference(){
		union(){
			// hub
			cylinder(d=GGC_Hub_d,h=Thickness+2);
			
			// arms
			for (j=[0:1]) mirror([j,0,0])
				rotate([0,0,45]) translate([0,-OD*Extention,0]){
					/*
					cylinder(d=5,h=Thickness);
					hull(){
						cylinder(d=3,h=Thickness);
						translate([22,0,0]) cylinder(d=3,h=Thickness);
					} // hull
					/**/
					hull(){
						translate([22,0,0]) cylinder(d=3,h=Thickness);
						translate([8,OD*Extention-2,0]) cylinder(d=3,h=Thickness);
						translate([0,OD*Extention-6,0]) cylinder(d=3,h=Thickness);
					} // hull
				}
		} // union
		
		translate([0,0,-Overlap])
			SplineHole(d=GGC_Hub_d-6,l=GGC_Hub_h+Overlap*2,nSplines=GGC_nSplines,Spline_w=30,Gap=IDXtra,Key=false);
		//translate([0,0,-Overlap]) cylinder(d=6.35,h=10+Overlap*2);
	} // diff
	
} // EscapementRocker

//translate([0,90,0]) EscapementRocker();






















