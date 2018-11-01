// **********************************************************
// Escapement
// Filename: GGC_Escapement.scad
// Project: Great Grandfather Clock
// Created: 10/31/2018
// Revision: 0.1 10/31/2018
// Units: mm
// *********************************************************
// History:
// 0.1 10/31/2018 First code
// *********************************************************
// for STL output
// EscapementWheel();
// EscapementRocker();
// *********************************************************
// Routines
// EscapeTooth(ToothLen=12,Thickness=3);
// WebbedSpoke(ID=25,OD=100,Spoke_w=5,Spoke_h=2,Web_h=4);
// SpokedGear(nTeeth=60,nSpokes=5);
// *********************************************************
// for Viewing
ShowEscapementNPendulum();
// *********************************************************

include<CommonStuffSAEmm.scad>
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

module ShowEscapementNPendulum(){
	//translate([0,0,-10-Overlap*2]) color("Gold") SpokedGear();
	
	color("Blue") rotate([0,0,360/15*$t]) EscapementWheel();
	
	//translate([0,90,10+Overlap*2]) color("Tan") PendulumHanger();
	
	translate([0,90,0]) rotate([0,0,abs(1-$t*2)*8-4]) EscapementRocker();
}// ShowEscapementNPendulum


module EscapeTooth(ToothLen=12,Thickness=3){
	hull(){
		cylinder(d=2,h=Thickness);
		translate([ToothLen,0,0]) cylinder(d=2,h=Thickness);
	} // hull
	
	difference(){
		translate([0,1,0]) cube([ToothLen-1,ToothLen-1,Thickness]);
		translate([ToothLen-1,ToothLen-1+1,-Overlap]) cylinder(r=ToothLen-1+Overlap,h=Thickness+Overlap*2);
		
	} // diff
} // EscapeTooth

//EscapeTooth();

module SpokedGear(nTeeth=60,nSpokes=5){
	PD=nTeeth*GearPitch/180;
	RimID=PD-GearPitch/90-6;
	Hub_d=20;
	
	difference(){
		gear (number_of_teeth=nTeeth,
			circular_pitch=GearPitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=5,
			rim_thickness=5,
			rim_width=3,
			hub_thickness=0,
			hub_diameter=0,
			bore_diameter=0,
			circles=0,
			backlash=GearBacklash,
			twist=0,
			involute_facets=0,
			flat=false);
	
		translate([0,0,-Overlap]) cylinder(d=RimID,h=5+Overlap*2);
		
	}
	
	for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
	WebbedSpoke(ID=Hub_d,OD=RimID,Spoke_w=5,Spoke_h=2,Web_h=3);
	
	//Hub
	difference(){
		cylinder(d=Hub_d,h=10);
		translate([0,0,-Overlap]) cylinder(d=6.35,h=10+Overlap*2);
	} // diff
	
	SplineShaft(d=Hub_d-6,l=20,nSplines=4,Spline_w=30,Hole=6.35,Key=false);
} // SpokedGear

//translate([0,0,-10-Overlap*2])SpokedGear();

module PendulumHanger(){
	Hub_d=20;
	
	//Hub
	difference(){
		union(){
			cylinder(d=Hub_d,h=10);
			translate([0,-30,0]) cylinder(d=75,h=5);
		} // union
		
		translate([0,-40,-Overlap]) cylinder(d=58,h=5+Overlap*2);
		
		//translate([0,0,-Overlap]) cylinder(d=6.35,h=10+Overlap*2);
		translate([0,0,-Overlap])
			SplineHole(d=Hub_d-6,l=10+Overlap*2,nSplines=4,Spline_w=30,Gap=IDXtra,Key=false);
	} // diff
	
	translate([0,-90,0])
	difference(){
		union(){
			cylinder(d=100,h=5);
			translate([0,-55,0]) cylinder(d=Hub_d,h=5);
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=85,h=5+Overlap*2);
		
		translate([0,-55,-Overlap])
			SplineHole(d=Hub_d-6,l=10+Overlap*2,nSplines=4,Spline_w=30,Gap=IDXtra,Key=false);
		
	} // diff
} // PendulumHanger

//translate([0,90,10+Overlap*2]) PendulumHanger();

module WebbedSpoke(ID=25,OD=100,Spoke_w=5,Spoke_h=2,Web_h=4){
	difference(){
		union(){
			translate([-Spoke_w,0,0]) cube([Spoke_w*2,OD/2,Spoke_h]);
			if (Web_h != 0)
				translate([-Spoke_h/2,0,0]) cube([Spoke_h,OD/2+IDXtra,Web_h*1.5]);
		} // union
		
		hull(){			
			rotate([0,0,atan2(Spoke_w,ID/2+Spoke_w/2)]) translate([0,ID/2+Spoke_w/2-Overlap,-Overlap])
				cylinder(d=Spoke_w,h=Spoke_h+Overlap*2);
				
			
			rotate([0,0,atan2(Spoke_w,OD/2-Spoke_w/2)]) translate([0,OD/2-Spoke_w/2,-Overlap])
				cylinder(d=Spoke_w,h=Spoke_h+Overlap*2);
		} // hull
		
		rotate([0,0,atan2(Spoke_w,ID/2+Spoke_w/2)]) translate([0,ID/2+Spoke_w/2-Overlap,-Overlap])mirror([1,1,0])
			cube(Spoke_w,Spoke_w,Spoke_h+Overlap*2);
		
		
		hull(){			
			rotate([0,0,-atan2(Spoke_w,ID/2+Spoke_w/2)]) translate([0,ID/2+Spoke_w/2-Overlap,-Overlap])
				cylinder(d=Spoke_w,h=Spoke_h+Overlap*2);
			
			rotate([0,0,-atan2(Spoke_w,OD/2-Spoke_w/2)]) translate([0,OD/2-Spoke_w/2,-Overlap]) cylinder(d=Spoke_w,h=Spoke_h+Overlap*2);
		} // hull
		rotate([0,0,-atan2(Spoke_w,ID/2+Spoke_w/2)]) translate([0,ID/2+Spoke_w/2-Overlap,-Overlap])mirror([0,1,0])
			cube(Spoke_w,Spoke_w,Spoke_h+Overlap*2);
		
		// trim ID
		translate([0,0,-Overlap]) cylinder(d=ID-Overlap,h=Spoke_h+Web_h*1.5+Overlap*2);
		
		
		if (Web_h != 0){
			hull(){
				translate([-Spoke_h/2-Overlap,ID/2+Web_h,Web_h*2]) rotate([0,90,0])
					cylinder(d=Web_h*2,h=Spoke_h+Overlap*2);
				translate([-Spoke_h/2-Overlap,OD/2-Web_h,Web_h*2]) rotate([0,90,0])
					cylinder(d=Web_h*2,h=Spoke_h+Overlap*2);
			} // hull
			
		} // if
	} // diff
	
	
	
} // WebbedSpoke

//WebbedSpoke();

module EscapementWheel(nTeeth=15, OD=120,Thickness=5){
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
		cylinder(d=Hub_d,h=10);
		//translate([0,0,-Overlap]) cylinder(d=6.35,h=10+Overlap*2);
		translate([0,0,-Overlap])
			SplineHole(d=Hub_d-6,l=10+Overlap*2,nSplines=4,Spline_w=30,Gap=IDXtra,Key=false);
	} // diff
} // EscapementWheel

//EscapementWheel();


module EscapementRocker(OD=120,Thickness=5){
	Hub_d=20;
	difference(){
		cylinder(d=Hub_d,h=10);
		translate([0,0,-Overlap])
			SplineHole(d=Hub_d-6,l=10+Overlap*2,nSplines=4,Spline_w=30,Gap=IDXtra,Key=false);
		//translate([0,0,-Overlap]) cylinder(d=6.35,h=10+Overlap*2);
	} // diff
	
	Extention=0.75;
	
	rotate([0,0,45]) translate([0,-OD*Extention,0]){
		cylinder(d=5,h=Thickness);
		hull(){
			cylinder(d=3,h=Thickness);
			translate([22,0,0]) cylinder(d=3,h=Thickness);
		} // hull
		hull(){
			translate([22,0,0]) cylinder(d=3,h=Thickness);
			translate([8,OD*Extention-2,0]) cylinder(d=3,h=Thickness);
			translate([0,OD*Extention-6,0]) cylinder(d=3,h=Thickness);
		} // hull
	}

	// copy mirror
	mirror([1,0,0])
	rotate([0,0,45]) translate([0,-OD*Extention,0]){
		cylinder(d=5,h=Thickness);
		hull(){
			cylinder(d=3,h=Thickness);
			translate([22,0,0]) cylinder(d=3,h=Thickness);
		} // hull
		hull(){
			translate([22,0,0]) cylinder(d=3,h=Thickness);
			translate([8,OD*Extention-2,0]) cylinder(d=3,h=Thickness);
			translate([0,OD*Extention-6,0]) cylinder(d=3,h=Thickness);
		} // hull
	}
} // EscapementRocker

//translate([0,90,0]) EscapementRocker();






















