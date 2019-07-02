// ************************************************
// Drive and Gears
// Filename: GGC_DriveGears.scad
// Project: Great Grandfather Clock
// Created: 6/30/2019
// by: David M. Flynn
// Licence: GPL3.0
// Revision: 0.9.0 6/30/2019
// Units: mm
// ************************************************
//  ***** History *****
// 0.9.0 6/30/2019 First code
// ************************************************
//  ***** Notes *****
// 1:1024 Geartrain that goes between the Drive Wheel
//  and the escapement.
// ************************************************
//  ***** for STL output
// GearA();
// GearA15();
// ************************************************
//  ***** for Viewing *****
// Show1to1000();
// ************************************************

include<GGC_Basic.scad>
include<OneWayLib.scad>

module Show1to1000(){
	GearA();
	translate([0,0,6+Overlap])GearA15();
	
	translate([50+12,0,6])rotate([0,0,180/60]){
		GearA();
		translate([0,0,6+Overlap])GearA15();
	}
	
	translate([0,0,12]){
		GearA();
		translate([0,0,6+Overlap])GearA15();
	}
	
	translate([50+12,0,18])rotate([0,0,180/60]){
		GearA();
		translate([0,0,6+Overlap])GearA15();
	}
	
	translate([0,0,24]){
		GearA();
		translate([0,0,6+Overlap])GearA15();
	}
} // Show1to1000

//Show1to1000();

module GearA(QuickView=false){
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch,
				nSpokes=5, 
				Hub_h=6, HasSpline=true, SplineLen=5+6,
				Bore_d=GGC_BearingPinSmall,QuickView=QuickView);
} // GearA

//GearA();

module GearA15(){
	SpurGear(nTeeth=15, Pitch=GGC_GearPitch,
				Width=GGC_GearWidth, 
				Bore_d=GGC_BearingPinSmall, HasSpline=true);	
} // GearA15

//translate([0,0,6+Overlap])GearA15();












