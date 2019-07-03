// ************************************************
// Drive and Gears
// Filename: GGC_DriveGears.scad
// Project: Great Grandfather Clock
// Created: 6/30/2019
// by: David M. Flynn
// Licence: GPL3.0
// Revision: 0.9.1 7/2/2019
// Units: mm
// ************************************************
//  ***** History *****
// 0.9.1 7/2/2019 Test printing some of the parts.
// 0.9.0 6/30/2019 First code
// ************************************************
//  ***** Notes *****
// 1:1024 Geartrain that goes between the Drive Wheel
//  and the escapement.
// ************************************************
//  ***** for STL output
// DrivePulley();
// DrivePulleyCover(myFn=360);
// DriveGearWithSpring(QuickView=false);
// DriveHubP1(myFn=360, QuickView=false);
// DriveHubP2(myFn=360, QuickView=false);
// GearA();
// GearA15();
// ************************************************
//  ***** for Viewing *****
// Show1to1000();
// ************************************************

include<GGC_Basic.scad>
include<BearingLib.scad>

module Show1to1000(){
	
	translate([50+50,0,0])
		GearA();
		
	translate([50+50+50+12,0,12]) rotate([180,0,0]){
		GearA();
		translate([0,0,6+Overlap])GearA15();}
	
	translate([50+50+50+12,50+12,18]) rotate([180,0,180/60]){
		GearA();
		translate([0,0,6+Overlap])GearA15();}
	
	translate([50+50+50+12,0,24]) rotate([180,0,0]){
		GearA();
		translate([0,0,6+Overlap])GearA15();}
		
	translate([50+50+50+12,50+12,30]) rotate([180,0,180/60]){
		GearA();
		translate([0,0,6+Overlap])GearA15();}
	
	translate([50+50+50+12,0,36]) rotate([180,0,0]){
		GearA();
		translate([0,0,6+Overlap])GearA15();}
	
} // Show1to1000

//Show1to1000();

// OneWayShaft(Ball_d=Ball_d, BC=50, nStops=nBalls, Thickness=Ball_d);
// OneWayRing(Ball_d=Ball_d, BC=50, nStops=nBalls, Thickness=Ball_d);
// OneWayRingOD(Ball_d=Ball_d, BC=50);

Ball_d=5/16*25.4;
BallCircle=50;
PulleyBearing_BC=44;

module ShowHubAndPulleys(){
	translate([0,0,12]) DriveHubP2();
	translate([0,0,-Ball_d-2]) DriveHubP1();
	DriveGearWithSpring(QuickView=true);
	
	translate([0,0,12]){
	DrivePulley();
	translate([0,0,18]) rotate([0,180,0]) DrivePulleyCover();}
} // ShowHubAndPulleys

//ShowHubAndPulleys();

module BackingPlate(){
	Pulley_w=Ball_d+2;
	Shaft_d=6.35;
	Plate_h=5;
	
	translate([0,0,-Plate_h])
	difference(){
		union(){
			cylinder(d=OneWayRingOD(Ball_d=Ball_d, BC=BallCircle),h=Plate_h);
			
			translate([50+50,0,0]) cylinder(d=15,h=Plate_h);
			translate([50+50,50+12,0]) cylinder(d=15,h=Plate_h);
			
			hull(){
				cylinder(d=15,h=Plate_h);
				translate([50+50,0,0]) cylinder(d=15,h=Plate_h);
			}
			
			hull(){
				cylinder(d=15,h=Plate_h);
				translate([50+50,50+12,0]) cylinder(d=15,h=Plate_h);
			}
			
			hull(){
				translate([50+50,0,0]) cylinder(d=15,h=Plate_h);
				translate([50+50,50+12,0]) cylinder(d=15,h=Plate_h);
			}
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=Shaft_d,h=Plate_h+Overlap*2);
		translate([50+50,0,-Overlap]) cylinder(d=GGC_BearingPinSmall,h=Plate_h+Overlap*2);
		translate([50+50,50+12,-Overlap]) cylinder(d=GGC_BearingPinSmall,h=Plate_h+Overlap*2);
	}
	
	translate([0,0,-Overlap]) OneWayRing(Ball_d=Ball_d, BC=BallCircle, nStops=7, Thickness=Pulley_w);
	
} // BackingPlate

//translate([0,0,-12]) BackingPlate();

module DriveGearWithSpring(QuickView=false){
	Base_w=Ball_d+2;
	nTeeth=60;
	Width=6;
	SpFn=12;
	Hub_r=15;
	Hub_h=12;
	SpStarts=5;
	
	PD=nTeeth*GGC_GearPitch/180;
	RimID=PD-GGC_GearPitch/90-Width*1.2;
	
	difference(){
		
		if (QuickView==false){
				gear (number_of_teeth=nTeeth,
					circular_pitch=GGC_GearPitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.2,
					gear_thickness=Width,
					rim_thickness=Width,
					rim_width=3,
					hub_thickness=Hub_h,
					hub_diameter=30,
					bore_diameter=0,
					circles=0,
					backlash=GearBacklash,
					twist=0,
					involute_facets=0,
					flat=false);
			}else{
				cylinder(d=nTeeth*GearPitch/180,h=Width);
				echo("Teeth:",nTeeth,"Pitch radius:",nTeeth*GearPitch/360);
				cylinder(d=30,h=Hub_h);
			}
			
			//*
			if (QuickView==false)
			// Spirel
			for (k=[0:SpStarts-1])
				for (j=[2:2:720])
					hull(){
						rotate([0,0,j+360/SpStarts*k])
							translate([Hub_r+(RimID/2-Hub_r)/720*j,0,-Overlap]) cylinder(d=1,h=Width+Overlap*2,$fn=SpFn);
						rotate([0,0,j-2+360/SpStarts*k])
							translate([Hub_r+(RimID/2-Hub_r)/720*j,0,-Overlap]) cylinder(d=1,h=Width+Overlap*2,$fn=SpFn);
					} // hull
				/**/
			
		translate([0,0,-Overlap])
			SplineHole(d=25, l=Hub_h+Overlap*2, nSplines=GGC_nSplines, Spline_w=30, Gap=IDXtra, Key=false);
	} // diff
} // DriveGearWithSpring

//DriveGearWithSpring(QuickView=true);

module DriveHubP1(myFn=90, QuickView=false){
	Base_w=Ball_d+2;
	SpineLen=Base_w*2+12+Ball_d+1;
		
	difference(){
		union(){
			OneWayShaft(Ball_d=Ball_d, BC=BallCircle, nStops=7, Thickness=Base_w-1+Overlap);
			
			SplineShaft(d=25, l=SpineLen, nSplines=GGC_nSplines, Spline_w=30, Hole=12, Key=false);
			
			
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=12.7,h=7);
		translate([0,0,-Base_w]) cylinder(d=12.0,h=Base_w*2+Ball_d+1);
		translate([0,0,SpineLen-7]) cylinder(d=12.7,h=7+Overlap);
	} // diff
} // DriveHubP1

//translate([0,0,-Ball_d-2]) DriveHubP1();

module DriveHubP2(myFn=90, QuickView=false){
	Base_w=Ball_d+2;
	Hub_h=Base_w+Ball_d;
		
	difference(){
		union(){
			OneWayShaft(Ball_d=Ball_d, BC=BallCircle, nStops=7, Thickness=Base_w-1+Overlap);
			
	
	
			translate([0,0,Base_w-1])
				OnePieceInnerRace(BallCircle_d=PulleyBearing_BC, Race_ID=10, Ball_d=Ball_d,
					Race_w=Ball_d+1, PreLoadAdj=-0.10, VOffset=0.50, BI=true, myFn=myFn);
		} // union
		
		translate([0,0,-Overlap])
			SplineHole(d=25, l=Hub_h+Overlap*2, nSplines=GGC_nSplines, Spline_w=30, Gap=IDXtra, Key=false);
	} // diff
} // DriveHubP2

//translate([0,0,12]) DriveHubP2();

module DrivePulley(){
	nSpokes=7;
	nBolts=7;
	Pulley_d=150;
	Pulley_w=Ball_d+2;
	
	difference(){
		union(){
			// Spokes
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
				WebbedSpoke(ID=OneWayRingOD(Ball_d=Ball_d, BC=BallCircle)-Overlap,OD=Pulley_d-5+Overlap,Spoke_w=6,Spoke_h=2,Web_h=5);
			
			// Outerbolts
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([0,Pulley_d/2-4,0])
				cylinder(d=8,h=Pulley_w);
			
			OneWayRing(Ball_d=Ball_d, BC=BallCircle, nStops=nSpokes, Thickness=Pulley_w);
			
			// inner bolts
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) 
				translate([0,OneWayRingOD(Ball_d=Ball_d, BC=BallCircle)/2,0]) cylinder(d=8,h=Pulley_w);
			
			difference(){
				cylinder(d=OneWayRingOD(Ball_d=Ball_d, BC=BallCircle),h=1.2);
				translate([0,0,-Overlap]) cylinder(d=BallCircle,h=1.2+Overlap*2);
			} // diff
			
			difference(){
				union(){
					cylinder(d=Pulley_d,h=Pulley_w);
					cylinder(d=Pulley_d+6,h=1.2);
					translate([0,0,1]) cylinder(d1=Pulley_d+6,d2=Pulley_d,h=2);
					
				} // union
				
				translate([0,0,-Overlap]) cylinder(d=Pulley_d-5,h=10+Overlap*2);
			} // diff
		} // union
		
		// Outerbolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([0,Pulley_d/2-4,Pulley_w])
			Bolt4Hole();
		
		// inner bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) 
			translate([0,OneWayRingOD(Ball_d=Ball_d, BC=BallCircle)/2,Pulley_w])
				Bolt4Hole();
	} // diff
} // DrivePulley

//DrivePulley();


module DrivePulleyCover(myFn=90){
	nSpokes=7;
	nBolts=7;
	Pulley_d=150;
	Pulley_w=Ball_d;
	
	difference(){
		union(){
			difference(){
				union(){
					cylinder(d=Pulley_d,h=Pulley_w);
					cylinder(d=Pulley_d+6,h=1.2);
					translate([0,0,1]) cylinder(d1=Pulley_d+6,d2=Pulley_d,h=2);
					
				} // union
				
				translate([0,0,-Overlap]) cylinder(d=Pulley_d-5,h=10+Overlap*2);
			} // diff
			
			translate([0,0,Ball_d]) rotate([180,0,0]) 
			OnePieceOuterRace(BallCircle_d=PulleyBearing_BC, Race_OD=OneWayRingOD(Ball_d=Ball_d, BC=BallCircle),
				Ball_d=Ball_d, Race_w=Ball_d, PreLoadAdj=-0.10, VOffset=0.00, BI=true, myFn=myFn);

			// inner bolts
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) 
				translate([0,OneWayRingOD(Ball_d=Ball_d, BC=BallCircle)/2,0]) cylinder(d=8,h=Pulley_w);

			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
				WebbedSpoke(ID=OneWayRingOD(Ball_d=Ball_d, BC=BallCircle)-Overlap,OD=Pulley_d-5+Overlap,Spoke_w=6,Spoke_h=2,Web_h=5);
			
			// Outerbolts
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([0,Pulley_d/2-4,0])
				cylinder(d=8,h=Pulley_w);
		} // union
		
		// Outerbolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([0,Pulley_d/2-4,0])
			rotate([180,0,0]) Bolt4HeadHole();
		
		// inner bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) 
			translate([0,OneWayRingOD(Ball_d=Ball_d, BC=BallCircle)/2,0])
				rotate([180,0,0]) Bolt4HeadHole();
	} // diff
	
} // DrivePulleyCover

//translate([0,0,18]) rotate([0,180,0]) DrivePulleyCover();


module GearA(QuickView=false){
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch,
				nSpokes=5, 
				Hub_h=6, HasSpline=true, SplineLen=5+6+1,
				Bore_d=GGC_BearingPinSmall,QuickView=QuickView);
} // GearA

//GearA();

module GearA15(){
	SpurGear(nTeeth=15, Pitch=GGC_GearPitch,
				Width=GGC_GearWidth, 
				Bore_d=GGC_BearingPinSmall, HasSpline=true);	
} // GearA15

//translate([0,0,6+Overlap])GearA15();












