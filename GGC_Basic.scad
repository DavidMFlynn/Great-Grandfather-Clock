// **********************************************************
// Basic stuff used by the Great Grandfather Clock project
// Filename: GGC_Basic.scad
// Project: Great Grandfather Clock
// by: David M. Flynn
// Licence: GPL3.0
// Created: 11/1/2018
// Revision: 1.0 11/1/2018
// Units: mm
// *********************************************************
// History:
// 1.0 11/1/2018  First code
// *********************************************************
// for STL output
// *********************************************************
// Routines
// SpokedGear(nTeeth=60,nSpokes=5,HasSpline=true);
// SplineHub(Hub_d=GGC_Hub_d,SpineLen=GGC_Hub_h*2,Bore_d=GGC_Bore_d);
// SplineHoleHub(Hub_d=GGC_Hub_d);
// NumberSupportBase(Len=20);
// PuzzleConnector(Thickness=6);
// Socket_12(Base_d=30,Height=10);
// *********************************************************
// for Viewing
//show3600to1Gears();
// *********************************************************

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
GGC_GearWidth=5;
GGC_Hub_h=GGC_GearWidth*2+2;
GGC_Hub_d=20;
GGC_nSplines=4;
//GGC_HubSpline_d=GGC_Hub_d-6;
GGC_Bore_d=6.35;

GGC_Face_d=600;
GGC_Band_w=40;
GGC_Band_t=3;
GGC_FaceSocket_d=30;
GGC_NumberSize=100;
GGC_NumberStandout=75;

module PuzzleConnector(Thickness=6){
	Web_t=6;
	Ball_d=12;
	
	hull(){
		cylinder(d=Web_t,h=Thickness);
		translate([Web_t/2+Ball_d/2,0,0]) cylinder(d=Web_t,h=Thickness);
	} // hull
	translate([Web_t/2+Ball_d/2,0,0]) cylinder(d=Ball_d,h=Thickness);
	
} // PuzzleConnector

//PuzzleConnector();

module Socket_12(Base_d=30,Height=10){
	
	cylinder(d1=Base_d,d2=Base_d+1,h=Height,$fn=12);
} // Socket_12

module NumberSupportBase(Len=20){
	
	Socket_12(Base_d=GGC_FaceSocket_d,Height=10);
	
	cylinder(d=12,h=Len);
	
} // NumberSupportBase

//NumberSupportBase();

module SplineHub(Hub_d=GGC_Hub_d,Hub_h=GGC_Hub_h,SpineLen=GGC_Hub_h*2,Bore_d=GGC_Bore_d){
	difference(){
		cylinder(d=Hub_d,h=Hub_h);
		translate([0,0,-Overlap]) cylinder(d=Bore_d,h=Hub_h+Overlap*2);
	} // diff
	
	SplineShaft(d=Hub_d-6,l=SpineLen,nSplines=GGC_nSplines,Spline_w=30,Hole=Bore_d,Key=false);
} // SplineHub

module SplineHoleHub(Hub_d=GGC_Hub_d){
	difference(){
		cylinder(d=Hub_d,h=GGC_Hub_h);
		
		translate([0,0,-Overlap])
			SplineHole(d=Hub_d-6,l=GGC_Hub_h+Overlap*2,nSplines=GGC_nSplines,Spline_w=30,Gap=IDXtra,Key=false);
	} // diff
	
} // SplineHoleHub

module SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch,
				nSpokes=5, 
				Hub_h=GGC_Hub_h, HasSpline=true, SplineLen=GGC_Hub_h*2,
				Bore_d=GGC_Bore_d){
					
	PD=nTeeth*GearPitch/180;
	RimID=PD-GearPitch/90-6;
	
	difference(){
		gear (number_of_teeth=nTeeth,
			circular_pitch=GearPitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=GGC_GearWidth,
			rim_thickness=GGC_GearWidth,
			rim_width=3,
			hub_thickness=0,
			hub_diameter=0,
			bore_diameter=0,
			circles=0,
			backlash=GearBacklash,
			twist=0,
			involute_facets=0,
			flat=false);
	
		translate([0,0,-Overlap]) cylinder(d=RimID,h=GGC_GearWidth+Overlap*2);
		
	}
	
	for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
	WebbedSpoke(ID=GGC_Hub_d,OD=RimID,Spoke_w=5,Spoke_h=2,Web_h=3);
	
	//Hub
	if (HasSpline==true){
		SplineHub(Hub_d=GGC_Hub_d,Hub_h=Hub_h,SpineLen=SplineLen,Bore_d=Bore_d);
	} else {
		difference(){
			cylinder(d=GGC_Hub_d,h=Hub_h);
			translate([0,0,-Overlap]) cylinder(d=Bore_d,h=Hub_h+Overlap*2);
		} // diff
	} // if
} // SpokedGear

//translate([0,0,-10-Overlap*2]) SpokedGear();

GGC_GearPitch=300;
GGC_GearPitchSmall=296.0526; // makes pitch radius of 16:60 the same as 15:60
GGC_BearingPinSmall=0.094*25.4;

module SpurGear(nTeeth=15, Pitch=GGC_GearPitch,
				Width=GGC_GearWidth, 
				Bore_d=GGC_BearingPinSmall, HasSpline=true){
	
	difference(){
		gear (number_of_teeth=nTeeth,
			circular_pitch=Pitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=Width,
			rim_thickness=Width,
			rim_width=3,
			hub_thickness=0,
			hub_diameter=0,
			bore_diameter=Bore_d,
			circles=0,
			backlash=GearBacklash,
			twist=0,
			involute_facets=0,
			flat=false);
		
		if (HasSpline==true)
			translate([0,0,-Overlap])
			SplineHole(d=GGC_Hub_d-6,l=Width+Overlap*2,nSplines=GGC_nSplines,Spline_w=30,Gap=IDXtra,Key=false);
	} // diff
} // SpurGear

module show3600to1Gears(){
// large gear is 1 tooth per second
translate([0,0,-6-Overlap*2])
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch,
				nSpokes=5, Hub_h=GGC_GearWidth+1,
				HasSpline=true, SplineLen=GGC_GearWidth*2+2, Bore_d=GGC_BearingPinSmall);
SpurGear(nTeeth=15,Pitch=GGC_GearPitch);

// large gear is 1/4 (4:1) tooth per second
translate([62.5,0,6]) rotate([0,0,360/120]) color("Green"){
translate([0,0,-6-Overlap*2])
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch,
				nSpokes=5, Hub_h=GGC_GearWidth+1,
				HasSpline=true, SplineLen=GGC_GearWidth*2+2, Bore_d=GGC_BearingPinSmall);
SpurGear(nTeeth=16,Pitch=GGC_GearPitchSmall);}

// large gear is 1/4/3.75 (15:1) tooth per second
translate([0,0,12]) rotate([0,0,360/120]) color("Tan"){
translate([0,0,-6-Overlap*2])
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitchSmall,
				nSpokes=5, Hub_h=GGC_GearWidth+1,
				HasSpline=true, SplineLen=GGC_GearWidth*2+2, Bore_d=GGC_BearingPinSmall);
SpurGear(nTeeth=15,Pitch=GGC_GearPitch);}

// large gear is 1/4/3.75/4 (60:1) tooth per second
translate([62.5,0,6+12]) rotate([0,0,360/120]) color("Blue"){
translate([0,0,-6-Overlap*2])
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch,
				nSpokes=5, Hub_h=GGC_GearWidth+1,
				HasSpline=true, SplineLen=GGC_GearWidth*2+2, Bore_d=GGC_BearingPinSmall);
SpurGear(nTeeth=15,Pitch=GGC_GearPitch);}

// large gear is 1/4/3.75/4/4 (240:1) tooth per second
translate([0,0,12+12]) rotate([0,0,360/120]) color("LightBlue"){
translate([0,0,-6-Overlap*2])
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch,
				nSpokes=5, Hub_h=GGC_GearWidth+1,
				HasSpline=true, SplineLen=GGC_GearWidth*2+2, Bore_d=GGC_BearingPinSmall);
SpurGear(nTeeth=16,Pitch=GGC_GearPitchSmall);}

// large gear is 1/4/3.75/4/4/3.75 (900:1) tooth per second
translate([62.5,0,6+12+12]) rotate([0,0,360/120]) color("Pink"){
translate([0,0,-6-Overlap*2])
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitchSmall,
				nSpokes=5, Hub_h=GGC_GearWidth+1,
				HasSpline=true, SplineLen=GGC_GearWidth*2+2, Bore_d=GGC_BearingPinSmall);
SpurGear(nTeeth=15,Pitch=GGC_GearPitch);}

// this gear is 1/4/3.75/4/4/3.75/4 (3600:1) tooth per second
translate([0,0,-6+12+12+12])
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch,
				nSpokes=5, Hub_h=GGC_GearWidth+1,
				HasSpline=true, SplineLen=GGC_GearWidth*2+2, Bore_d=GGC_BearingPinSmall);

}










