// **********************************************************
// Basic stuff used by the Great Grandfather Clock project
// Filename: GGC_Basic.scad
// Project: Great Grandfather Clock
// by: David M. Flynn
// Licence: GPL3.0
// Created: 11/1/2018
// Revision: 1.0.1 12/19/2018
// Units: mm
// *********************************************************
// History:
// 1.0.1 12/19/2018 Improved scalability.
// 1.0 11/1/2018  First code
// *********************************************************
// for STL output
// *********************************************************
// Routines
// SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch, Width=GGC_GearWidth, 
//				nSpokes=5, 
//				Hub_h=GGC_Hub_h, HasSpline=true, SplineLen=GGC_Hub_h*2,
//				Bore_d=GGC_Bore_d, QuickView=false, GaurdFlange=false);
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
include<OneWayLib.scad>
include<WebbedSpokeLib.scad>
// WebbedSpoke(ID=25,OD=100,Spoke_w=5,Spoke_h=2,Web_h=4);
include<SplineLib.scad>
//SplineShaft(d=20,l=30,nSplines=Spline_nSplines,Spline_w=30,Hole=Spline_Hole_d,Key=false);
// SplineHole(d=20,l=20,nSplines=Spline_nSplines,Spline_w=30,Gap=SplineGap,Key=false);
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

GGC_SecondHandShaft_d=3/8*25.4;
GGC_MinuteHandShaft_d=4/8*25.4;
GGC_HourHandShaft_d=5/8*25.4;

GGC_Face_d=600;
GGC_Band_w=40;
GGC_Band_t=3;
GGC_FaceSocket_d=30;
GGC_NumberSize=100;
GGC_NumberStandout=75;

GGC_Post1_X=15;
GGC_Post1_Y=-65;
GGC_Post2_X=125;
GGC_Post2_Y=65;
GGC_Post3_X=-60;
GGC_Post3_Y=100;

GGC_GearPitch=300;
GGC_GearPitchSmall=296.0526; // makes pitch radius of 16:60 the same as 15:60
GGC_BearingPinSmall=0.094*25.4;
SplineGap=0.08; // was IDXtra

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

module SplineHub(Hub_d=GGC_Hub_d, Hub_h=GGC_Hub_h, SpineLen=GGC_Hub_h*2, Bore_d=GGC_Bore_d){
	difference(){
		cylinder(d=Hub_d,h=Hub_h);
		translate([0,0,-Overlap]) cylinder(d=Bore_d,h=Hub_h+Overlap*2);
	} // diff
	
	SplineShaft(d=Hub_d*0.7, l=SpineLen, nSplines=GGC_nSplines, Spline_w=30, Hole=Bore_d, Key=false);
} // SplineHub

module SplineHoleHub(Hub_d=GGC_Hub_d, Hub_h=GGC_Hub_h){
	difference(){
		cylinder(d=Hub_d,h=Hub_h);
		
		translate([0,0,-Overlap])
			SplineHole(d=Hub_d*0.7, l=Hub_h+Overlap*2, nSplines=GGC_nSplines, Spline_w=30, Gap=SplineGap, Key=false);
	} // diff
	
} // SplineHoleHub

module GearSegment(nTeeth=60, GearPitch=GGC_GearPitch, Width=GGC_GearWidth, 
					Segment_a=72, QuickView=false, GaurdFlange=false, myFn=90, Label="60T1200"){
		
	Tooth_h=GearPitch/90;
	PD=nTeeth*GearPitch/180;
	RimID=PD-Tooth_h*3;
		
	difference(){
		if (QuickView==false){
			gear (number_of_teeth=nTeeth,
				circular_pitch=GearPitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.2,
				gear_thickness=Width,
				rim_thickness=Width,
				rim_width=3,
				hub_thickness=0,
				hub_diameter=0,
				bore_diameter=0,
				circles=0,
				backlash=GearBacklash,
				twist=0,
				involute_facets=0,
				flat=false);
		}else{
			cylinder(d=nTeeth*GearPitch/180,h=Width);
			echo("Teeth:",nTeeth,"Pitch radius:",nTeeth*GearPitch/360);
		}
	
		// center hole
		translate([0,0,-Overlap]) cylinder(d=RimID,h=Width+Overlap*2,$fn=myFn);
		// cut to length
		rotate([0,0,180/60]) translate([-IDXtra,0,-Overlap]) cube([PD,PD,Width+Overlap*2]);
		rotate([0,0,180/60+Segment_a]) translate([IDXtra,0,-Overlap]) mirror([1,0,0]) cube([PD,PD,Width+Overlap*2]);
		rotate([0,0,180/60+Segment_a/2]) translate([-PD,0,-Overlap]) mirror([0,1,0]) cube([PD*2,PD,Width+Overlap*2]);
		
		// label
		rotate([0,0,180/60+Segment_a/2]) translate([0,RimID/2+1.5,Width-1]) 
			linear_extrude(height=2) text(text=Label,size=8,halign="center");
		
		// right notch and bolt
		rotate([0,0,180/60]) translate([-Tooth_h/2,RimID/2+Tooth_h/2,Width]) children();
		rotate([0,0,180/60]) translate([-Tooth_h-IDXtra,PD/2-Tooth_h/2,-Overlap]) 
			mirror([0,1,0]) cube([Tooth_h+IDXtra+Overlap,Tooth_h*1.1,Width/2]);
		
		// left notch and bolt
		rotate([0,0,180/60+Segment_a]) mirror([1,0,0])translate([-Tooth_h/2,RimID/2+Tooth_h/2,Width]) children();
		rotate([0,0,180/60+Segment_a]) mirror([1,0,0])translate([-Tooth_h-IDXtra,PD/2-Tooth_h/2,-Overlap]) 
			mirror([0,1,0]) cube([Tooth_h+IDXtra+Overlap,Tooth_h*1.1,Width/2]);
	} // diff
			
	
} // GearSegment

//rotate([180,0,0])
//GearSegment(nTeeth=60, GearPitch=1200, Width=20, 
	//				Segment_a=72, QuickView=false, GaurdFlange=false, myFn=720, Label="60T1200") Bolt6HeadHole();

module BoltedSpoke(nTeeth=60, Hub_d=GGC_Hub_d, GearPitch=GGC_GearPitch, Width=GGC_GearWidth, 
					GaurdFlange=false, myFn=90){
	
				
	Tooth_h=GearPitch/90;
	PD=nTeeth*GearPitch/180;
	RimID=PD-Tooth_h*3;
						
	WebbedSpoke(ID=Hub_d, OD=RimID, Spoke_w=Width, Spoke_h=Width/2.5, Web_h=Width*0.6);
					
	// Gear mount	
	difference(){
		translate([-Tooth_h,RimID/2-Tooth_h/20,0]) cube([Tooth_h*2,Tooth_h+Tooth_h/20-IDXtra,Width/2]);
		
		translate([-Tooth_h/2,RimID/2+Tooth_h/2,Width/2]) children();
		translate([Tooth_h/2,RimID/2+Tooth_h/2,Width/2]) children();
	} // diff
	
	// Hub mount
	difference(){
		translate([-Tooth_h*0.75,Hub_d/2,0]) mirror([0,1,0]) cube([Tooth_h*1.5,Tooth_h+Tooth_h/20-IDXtra,Width/2.5]);
		
		translate([Tooth_h/2.5,Hub_d/2-Tooth_h/2,0]) rotate([180,0,0]) Bolt6HeadHole();
		translate([-Tooth_h/2.5,Hub_d/2-Tooth_h/2,0]) rotate([180,0,0]) Bolt6HeadHole();
		
		difference(){
			translate([0,0,-Overlap]) cylinder(d=Hub_d+Tooth_h,h=Width/2.5+Overlap*2);
			translate([0,0,-Overlap*2]) cylinder(d=Hub_d+Overlap,h=Width/2.5+Overlap*4);
		} // diff
	} // diff
} // BoltedSpoke

//BoltedSpoke(nTeeth=60, Hub_d=GGC_Hub_d*4, GearPitch=1200, Width=20, GaurdFlange=false) Bolt6Hole();

module BigHub(Width=GGC_GearWidth, 
				nSpokes=5, GearPitch=GGC_GearPitch,
				Hub_d=GGC_Hub_d, Hub_h=GGC_Hub_h, HasSpline=true, SplineLen=GGC_Hub_h*2,
				Bore_d=GGC_Bore_d, GaurdFlange=false){
	
	Tooth_h=GearPitch/90;
					
	if (HasSpline==true){
		
		difference(){
			SplineHub(Hub_d=Hub_d,Hub_h=Hub_h,SpineLen=SplineLen,Bore_d=Bore_d);
			
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]){
				translate([-Tooth_h*0.75-IDXtra,-Hub_d/2,-Overlap]) cube([Tooth_h*1.5+IDXtra*2,Tooth_h+Tooth_h/20+IDXtra,Width/2.5+IDXtra+Overlap*2]);
				translate([Tooth_h/2.5,-Hub_d/2+Tooth_h/2,Width/2.5]) rotate([180,0,0]) Bolt6Hole();
				translate([-Tooth_h/2.5,-Hub_d/2+Tooth_h/2,Width/2.5]) rotate([180,0,0]) Bolt6Hole();
			}
			
		} // diff
	} else {
		if (GaurdFlange==true){
				difference(){
					translate([0,0,-1]) cylinder(d=GGC_Hub_d,h=Hub_h+1);
					translate([0,0,-1-Overlap]) cylinder(d=Bore_d,h=Hub_h+1+Overlap*2);
				} // diff
			}else{
		difference(){
			cylinder(d=GGC_Hub_d,h=Hub_h);
			
			translate([0,0,-Overlap]) cylinder(d=Bore_d,h=Hub_h+Overlap*2);
		} // diff
		} //if (GaurdFlange==true)
	} // if
	
} // BigHub
/*
BigHub(Width=GGC_GearWidth*4, 
				nSpokes=5, GearPitch=GGC_GearPitch*4,
				Hub_d=GGC_Hub_d*4, Hub_h=GGC_GearWidth*1.2*4, HasSpline=true, SplineLen=GGC_GearWidth*4+GGC_GearWidth*1.2*4,
				Bore_d=GGC_BearingPinSmall*4, GaurdFlange=false);
/**/

module SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch, Width=GGC_GearWidth, 
				nSpokes=5, 
				Hub_d=GGC_Hub_d, Hub_h=GGC_Hub_h, HasSpline=true, SplineLen=GGC_Hub_h*2,
				Bore_d=GGC_Bore_d, QuickView=false, GaurdFlange=false){
					
	PD=nTeeth*GearPitch/180;
	RimID=PD-GearPitch/90-Width*1.2;
	
	difference(){
		if (QuickView==false){
			gear (number_of_teeth=nTeeth,
				circular_pitch=GearPitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.2,
				gear_thickness=Width,
				rim_thickness=Width,
				rim_width=3,
				hub_thickness=0,
				hub_diameter=0,
				bore_diameter=0,
				circles=0,
				backlash=GearBacklash,
				twist=0,
				involute_facets=0,
				flat=false);
		}else{
			cylinder(d=nTeeth*GearPitch/180,h=Width);
			echo("Teeth:",nTeeth,"Pitch radius:",nTeeth*GearPitch/360);
		}
	
		translate([0,0,-Overlap]) cylinder(d=RimID,h=Width+Overlap*2);
		
	}
	
	if (GaurdFlange==true){
		difference(){
			translate([0,0,-1]) cylinder(d=nTeeth*GearPitch/180+5,h=1+Overlap);
			translate([0,0,-1-Overlap]) cylinder(d=RimID,h=1+Overlap*3);
		} // diff
		
		
		for (j=[0:nSpokes-1]) translate([0,0,-1]) rotate([0,0,360/nSpokes*j])
			WebbedSpoke(ID=GGC_Hub_d,OD=RimID,Spoke_w=Width,Spoke_h=Width/2,Web_h=Width*0.8);
	}else{
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
			WebbedSpoke(ID=Hub_d,OD=RimID,Spoke_w=Width,Spoke_h=Width/2.5,Web_h=Width*0.6);
	}
	
	//Hub
	if (HasSpline==true){
		SplineHub(Hub_d=Hub_d,Hub_h=Hub_h,SpineLen=SplineLen,Bore_d=Bore_d);
	} else {
		if (GaurdFlange==true){
				difference(){
					translate([0,0,-1]) cylinder(d=GGC_Hub_d,h=Hub_h+1);
					translate([0,0,-1-Overlap]) cylinder(d=Bore_d,h=Hub_h+1+Overlap*2);
				} // diff
			}else{
		difference(){
			cylinder(d=GGC_Hub_d,h=Hub_h);
			
			translate([0,0,-Overlap]) cylinder(d=Bore_d,h=Hub_h+Overlap*2);
		} // diff
		} //if (GaurdFlange==true)
	} // if
} // SpokedGear

//translate([0,0,-10-Overlap*2]) SpokedGear();


/*
SpokedGear(nTeeth=60, GearPitch=1200, Width=20, 
				nSpokes=5, 
				Hub_d=GGC_Hub_d*4, Hub_h=GGC_Hub_h*4, HasSpline=true, SplineLen=GGC_Hub_h*2*4,
				Bore_d=GGC_Bore_d*4, QuickView=false, GaurdFlange=false);
/**/

module SpurGear(nTeeth=15, Pitch=GGC_GearPitch,
				Width=GGC_GearWidth, Hub_d=GGC_Hub_d,
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
			SplineHole(d=Hub_d*0.7,l=Width+Overlap*2,nSplines=GGC_nSplines,Spline_w=30,Gap=SplineGap,Key=false);
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










