// **********************************************************
// Escapement
// Filename: GGC_Escapement.scad
// Project: Great Grandfather Clock
// Created: 10/31/2018
// Revision: 0.3 6/28/2019
// Units: mm
// *********************************************************
// History:
// 0.3 6/28/2019  Got the escapement math good.
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

kEscPin_BC=150;
kEscPin_BC_r=kEscPin_BC/2;
nEscPins=30;
kEscPin_d=3/32*25.4;
kEscPin_h=25.4;

kPinAntiRotation=0.25; //0.25; // make the pallets miss the pins
//ActivePin=1; // number of pins CW from 9 O'clock
kEscActivePin=2+kPinAntiRotation; // number of pins CW from 9 O'clock

kEscActivePin_a=360/nEscPins*kEscActivePin;

kEscAnchor_r=tan(90-kEscActivePin_a)*kEscPin_BC_r;

kEscAnchorCenter_Y=sqrt(kEscAnchor_r*kEscAnchor_r + kEscPin_BC_r*kEscPin_BC_r); // kPin_BC*0.85;
// Pallet rides on the 3rd pin CW from 9 O'clock and CCW from 3 O'clock
kEscPallet_a=25;
kEscPalletWidth=(kEscPin_BC*PI/nEscPins-kEscPin_d)/3;
kEscPalletEnd=kEscPin_BC/6;
kEscPalletThickness=6;

module EscapementPins(nTeeth=nEscPins){
	for (j=[0:nTeeth-1]) rotate([0,0,360/nTeeth*j]) 
			translate([kEscPin_BC_r,0,0]) cylinder(d=kEscPin_d,h=kEscPin_h);
} // EscapementPins

//EscapementPins();

module EscapementWheel(nTeeth=nEscPins, OD=kEscPin_BC+8,Thickness=GGC_Escapement_h){
	nSpokes=5;
	Hub_d=20;
	
	difference(){
		cylinder(d=OD,h=Thickness);
		
		// Pins
		for (j=[0:nTeeth-1]) rotate([0,0,360/nTeeth*j]) 
			translate([kEscPin_BC_r,0,-Overlap]) cylinder(d=kEscPin_d,h=Thickness+Overlap*2);
		
		translate([0,0,-Overlap]) cylinder(d=OD-16,h=Thickness+Overlap*2);
	} // diff
	
	for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
		WebbedSpoke(ID=15,OD=OD-16,Spoke_w=5,Spoke_h=2,Web_h=3);
	
	//Hub
	difference(){
		cylinder(d=Hub_d,h=GGC_Hub_h);
		//translate([0,0,-Overlap]) cylinder(d=6.35,h=10+Overlap*2);
		translate([0,0,-Overlap])
			SplineHole(d=Hub_d-6,l=GGC_Hub_h+Overlap*2,nSplines=GGC_nSplines,Spline_w=30,Gap=IDXtra,Key=false);
	} // diff
} // EscapementWheel

/*
rotate([0,0,-360/nEscPins*(kPinAntiRotation-0.06)]) // touching 10 O'clock pallet
//rotate([0,0,-360/nEscPins*(kPinAntiRotation+0.50-0.07)]) // touching 2 O'clock pallet+0.44
{
	EscapementPins();
	EscapementWheel();
}
/**/


//pallet at 10:00
module EntryPallet(){
	difference(){
		translate([0,kEscAnchorCenter_Y,0]) cylinder(r=kEscAnchor_r-Overlap,h=kEscPalletThickness);
		
		translate([0,kEscAnchorCenter_Y,-Overlap]) cylinder(r=kEscAnchor_r-kEscPalletWidth,h=kEscPalletThickness+Overlap*2);
		rotate([0,0,180-kEscActivePin_a]) translate([kEscPin_BC_r,0,-Overlap]) 
			rotate([0,0,-180-kEscPallet_a]) cube([kEscPalletEnd,kEscPalletEnd,kEscPalletThickness+Overlap*2]);
		
		translate([-kEscAnchor_r,kEscAnchorCenter_Y,-Overlap]) cube([kEscAnchor_r*2,kEscAnchor_r,kEscPalletThickness+Overlap*2]);
		translate([0,kEscAnchorCenter_Y,0]) rotate([0,0,90-kEscActivePin_a-10])
			translate([-kEscAnchor_r,0,-Overlap]) cube([kEscAnchor_r*2,kEscAnchor_r,kEscPalletThickness+Overlap*2]);
		translate([0,kEscAnchorCenter_Y,0]) rotate([0,0,-90-kEscActivePin_a+5])
			translate([-kEscAnchor_r,0,-Overlap]) cube([kEscAnchor_r*2,kEscAnchor_r,kEscPalletThickness+Overlap*2]);
	} // diff
} // EntryPallet

//translate([0,0,GGC_Escapement_h+1]) rotate([0,0,180]) EntryPallet();

//pallet at 2:00
module ExitPallet(){
	
	difference(){
		translate([0,kEscAnchorCenter_Y,0]) cylinder(r=kEscAnchor_r+kEscPalletWidth,h=kEscPalletThickness);
		
		translate([0,kEscAnchorCenter_Y,-Overlap]) cylinder(r=kEscAnchor_r+Overlap,h=kEscPalletThickness+Overlap*2);
		rotate([0,0,kEscActivePin_a]) translate([kEscPin_BC_r,0,-Overlap]) 
			rotate([0,0,180-kEscPallet_a]) cube([kEscPalletEnd,kEscPalletEnd,kEscPalletThickness+Overlap*2]);
		
		translate([-kEscAnchor_r-5,kEscAnchorCenter_Y,-Overlap]) cube([kEscAnchor_r*2+10,kEscAnchor_r,kEscPalletThickness+Overlap*2]);
		translate([0,kEscAnchorCenter_Y,0]) rotate([0,0,-90+kEscActivePin_a+10])
			translate([-kEscAnchor_r-kEscPalletWidth,0,-Overlap]) 
				cube([kEscAnchor_r*2+kEscPalletWidth*2,kEscAnchor_r+10,kEscPalletThickness+Overlap*2]);
		translate([0,kEscAnchorCenter_Y,0]) rotate([0,0,90+kEscActivePin_a-5])
			translate([-kEscAnchor_r-kEscPalletWidth,0,-Overlap]) 
				cube([kEscAnchor_r*2+kEscPalletWidth*2,kEscAnchor_r+10,kEscPalletThickness+Overlap*2]);
	} // diff
} // ExitPallet

//translate([0,0,GGC_Escapement_h+1]) rotate([0,0,180]) ExitPallet();

module EscapementRocker(Thickness=GGC_Escapement_h){
	Extention=1.00;
	
	difference(){
		union(){
			// hub
			translate([0,kEscAnchorCenter_Y,0]) cylinder(d=GGC_Hub_d,h=Thickness+2);
			
			// arms
			for (j=[0:1]) mirror([j,0,0])
				translate([0,kEscAnchorCenter_Y,0]) rotate([0,0,27]) translate([0,-kEscAnchorCenter_Y*Extention,0]){
					/*
					cylinder(d=5,h=Thickness);
					hull(){
						cylinder(d=3,h=Thickness);
						translate([22,0,0]) cylinder(d=3,h=Thickness);
					} // hull
					/**/
					hull(){
						translate([22,0,0]) cylinder(d=6,h=Thickness);
						translate([7,kEscAnchorCenter_Y*Extention-2,0]) cylinder(d=6,h=Thickness);
						translate([-4,kEscAnchorCenter_Y*Extention-6,0]) cylinder(d=6,h=Thickness);
					} // hull
				}
		} // union
		
		translate([0,kEscAnchorCenter_Y,-Overlap])
			SplineHole(d=GGC_Hub_d-6,l=GGC_Hub_h+Overlap*2,nSplines=GGC_nSplines,Spline_w=30,Gap=IDXtra,Key=false);
		//translate([0,0,-Overlap]) cylinder(d=6.35,h=10+Overlap*2);
	} // diff
	
} // EscapementRocker


translate([0,0,GGC_Escapement_h+1]) rotate([0,0,180]) {
	ExitPallet();
	EntryPallet();
	EscapementRocker();
}






















