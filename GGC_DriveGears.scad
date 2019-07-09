// ************************************************
// Drive and Gears
// Filename: GGC_DriveGears.scad
// Project: Great Grandfather Clock
// Created: 6/30/2019
// by: David M. Flynn
// Licence: GPL3.0
// Revision: 0.9.4 7/5/2019
// Units: mm
// ************************************************
//  ***** History *****
// 0.9.4 7/5/2019 Added MainAndWinderFrontPlate();
// 0.9.3 7/4/2019 Added WindingGear();
// 0.9.2 7/3/2019 Added RotationLimiter
// 0.9.1 7/2/2019 Test printing some of the parts.
// 0.9.0 6/30/2019 First code
// ************************************************
//  ***** Notes *****
// 1:1024 Geartrain that goes between the Drive Wheel
//  and the escapement.
// ************************************************
//  ***** for STL output
// WindingGear();
// DrivePulley(); // FC1
// DrivePulleyCover(myFn=360); // FC1
// DriveGearWithSpring(ShowGear=true,ShowSpiral=true); // ??
// RotationLimiter(); // FC1
// DriveHubP1(myFn=360, QuickView=false); // FC2
// DriveHubP2(myFn=360, QuickView=false); // FC2
// GearA();
// GearA15();
//
//  WinderHandle();
//	WinderShaft();
//  WinderGear(myFn=360);
//
// MainAndWinderBackingPlate();
// rotate([180,0,0]) MainAndWinderFrontPlate(myFn=360);
//
// ************************************************
//  ***** for Viewing *****
// Show1to1000();
// ************************************************

include<GGC_Basic.scad>
include<BearingLib.scad>

SplineGap=0.08;
WindingGear_h=7;
nWinderGearTeeth=60;
Ball_d=5/16*25.4;
BallCircle=50;
PulleyBearing_BC=44;

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

module ShowHubAndPulleys(){
	//*
	//translate([0,0,12]) DriveHubP2();
	translate([0,0,-Ball_d-2]) DriveHubP1();
	//DriveGearWithSpring();
	//translate([0,0,6+Overlap]) RotationLimiter();
	/**/
	
	//*
	translate([0,0,13]){
		translate([0,0,WindingGear_h]) rotate([180,0,13]) WindingGear();
		translate([0,0,WindingGear_h])DrivePulley();
		translate([0,0,18+WindingGear_h]) rotate([0,180,0]) DrivePulleyCover();
		}
	/**/
} // ShowHubAndPulleys

// ShowHubAndPulleys();

module BackingPlate(){
	Pulley_w=Ball_d+2;
	Shaft_d=6.35;
	Plate_h=5;
	
	translate([0,0,-Plate_h])
	difference(){
		union(){
			// Winder Shaft
			translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,0]) cylinder(d=15,h=Plate_h+11);
			
			// Drive shaft
			cylinder(d=OneWayRingOD(Ball_d=Ball_d, BC=BallCircle),h=Plate_h);
			
			// Idle gear shaft
			translate([50+50,0,0]) cylinder(d=15,h=Plate_h+12);
			
			// Reduction gear shaft 1
			translate([50+50+50+12,0,0]) cylinder(d=15,h=Plate_h+12);
			
			// Reduction gear shaft 2
			translate([50+50+50+12,50+12,0]) cylinder(d=15,h=Plate_h+18);
			
			// Mounting hole 1
			translate([50+50,50+20,0]) cylinder(d=15,h=Plate_h+12);
			// Mounting hole 2
			translate([50+50,-50-20,0]) cylinder(d=15,h=Plate_h+12);
			
			// Drive shaft to Winder Shaft
			hull(){
				cylinder(d=15,h=Plate_h);
				translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Winder Shaft to top mount
			hull(){
				translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,0]) cylinder(d=15,h=Plate_h);
				translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360-20,20,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Winder Shaft to bottom mount
			hull(){
				translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,0]) cylinder(d=15,h=Plate_h);
				translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360-20,-20,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Drive shaft to Idle gear shaft
			hull(){
				cylinder(d=15,h=Plate_h);
				translate([50+50,0,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Idle gear shaft to Reduction gear shaft 1
			hull(){
				translate([50+50,0,0]) cylinder(d=15,h=Plate_h);
				translate([50+50+50+12,0,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Reduction gear shaft 1 to Reduction gear shaft 2
			hull(){
				translate([50+50+50+12,0,0]) cylinder(d=15,h=Plate_h);
				translate([50+50+50+12,50+12,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Drive shaft to Reduction gear shaft 2
			hull(){
				cylinder(d=15,h=Plate_h);
				translate([50+50+50+12,50+12,0]) cylinder(d=15,h=Plate_h);
			}
			
			// Mounting hole 1 to Mounting hole 2
			hull(){
				translate([50+50,50+20,0]) cylinder(d=15,h=Plate_h);
				translate([50+50,-50-20,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Mounting hole 2 to Drive shaft
			hull(){
				translate([50+50,-50-20,0]) cylinder(d=15,h=Plate_h);
				cylinder(d=15,h=Plate_h);
			} // hull
			
			// Mounting hole 2 to Reduction gear shaft 1
			hull(){
				translate([50+50,-50-20,0]) cylinder(d=15,h=Plate_h);
				translate([50+50+50+12,0,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			//Wall mount top to Drive shaft
			hull(){
				translate([-25,35,0]) cylinder(d=15,h=Plate_h);
				cylinder(d=15,h=Plate_h);
			} // hull
			//Wall mount bottom to Drive shaft
			hull(){
				translate([-25,-35,0]) cylinder(d=15,h=Plate_h);
				cylinder(d=15,h=Plate_h);
			} // hull
		} // union
		
		// Drive shaft
		//translate([0,0,-Overlap]) cylinder(d=Shaft_d,h=Plate_h+Overlap*2);
		rotate([180,0,0]) Bolt6ButtonHeadHole();
		// Idle gear shaft
		translate([50+50,0,-Overlap]) cylinder(d=GGC_BearingPinSmall,h=Plate_h+12+Overlap*2);
		// Reduction gear shaft 1
		translate([50+50+50+12,0,-Overlap]) cylinder(d=GGC_BearingPinSmall,h=Plate_h+12+Overlap*2);
		// Reduction gear shaft 2
		translate([50+50+50+12,50+12,-Overlap]) cylinder(d=GGC_BearingPinSmall,h=Plate_h+18+Overlap*2);
		
		// Mounting hole 1
			translate([50+50,50+20,Plate_h+12]) Bolt6Hole(depth=Plate_h+12);
		// Mounting hole 2
			translate([50+50,-50-20,Plate_h+12]) Bolt6Hole(depth=Plate_h+12);
		
		// Wall mount holes
		translate([50+50+50+12,40,Plate_h]) Bolt6ClearHole();
		translate([50+50,50,Plate_h]) Bolt6ClearHole();
		translate([50+50,-50,Plate_h]) Bolt6ClearHole();
		translate([50,0,Plate_h]) Bolt6ClearHole();
		translate([-25,35,Plate_h]) Bolt6ClearHole();
		translate([-25,-35,Plate_h]) Bolt6ClearHole();
		translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360+25,0,Plate_h]) Bolt6ClearHole();
		translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360-20,20,Plate_h]) Bolt6ClearHole();
		translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360-20,-20,Plate_h]) Bolt6ClearHole();
	}
	
	// Drive shaft
	translate([0,0,-Overlap]) OneWayRing(Ball_d=Ball_d, BC=BallCircle, nStops=7, Thickness=Pulley_w);
	
} // BackingPlate

//translate([0,0,-12]) BackingPlate();

module MainAndWinderBackingPlate(){
	Pulley_w=Ball_d+2;
	Shaft_d=6.35;
	Plate_h=5;
	
	translate([0,0,-Plate_h])
	difference(){
		union(){
			// Winder Shaft
			translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,0]) cylinder(d=15,h=Plate_h+11);
			
			// Drive shaft
			cylinder(d=OneWayRingOD(Ball_d=Ball_d, BC=BallCircle),h=Plate_h);
			
			// Top Front Plate Post
			translate([-62,62,0]) cylinder(d=15,h=Plate_h+12);
			
			// Bottom Front Plate Post
			translate([-62,-62,0]) cylinder(d=15,h=Plate_h+12);
							
			// Drive shaft to Top Front Plate Post
			hull(){
				cylinder(d=15,h=Plate_h);
				translate([-62,62,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Drive shaft to Bottom Front Plate Post
			hull(){
				cylinder(d=15,h=Plate_h);
				translate([-62,-62,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Winder Shaft to Top Front Plate Post
			hull(){
				translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,0]) cylinder(d=15,h=Plate_h);
				translate([-62,62,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Winder Shaft to Bottom Front Plate Post
			hull(){
				translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,0]) cylinder(d=15,h=Plate_h);
				translate([-62,-62,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			
			// Drive shaft to Winder Shaft
			hull(){
				cylinder(d=15,h=Plate_h);
				translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Winder Shaft to top mount
			hull(){
				translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,0]) cylinder(d=15,h=Plate_h);
				translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360-20,20,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Winder Shaft to bottom mount
			hull(){
				translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,0]) cylinder(d=15,h=Plate_h);
				translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360-20,-20,0]) cylinder(d=15,h=Plate_h);
			} // hull
					
			
			
			//Wall mount right to Drive shaft
			hull(){
				translate([50,0,0]) cylinder(d=15,h=Plate_h);
				cylinder(d=15,h=Plate_h);
			} // hull
		} // union
		
		// Drive shaft
		//translate([0,0,-Overlap]) cylinder(d=Shaft_d,h=Plate_h+Overlap*2);
		rotate([180,0,0]) Bolt6ButtonHeadHole();
		
		// Winder Shaft
		translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,Plate_h+11]) Bolt6Hole(depth=Plate_h+12);
			
		
		// Top Front Plate Post
			translate([-62,62,Plate_h+12]) Bolt6Hole(depth=Plate_h+12);
		// Bottom Front Plate Post
			translate([-62,-62,Plate_h+12]) Bolt6Hole(depth=Plate_h+12);
		
		// Wall mount holes
		translate([50,0,Plate_h]) Bolt6ClearHole();
		translate([-30,30,Plate_h]) Bolt6ClearHole();
		translate([-30,-30,Plate_h]) Bolt6ClearHole();
		translate([-50,50,Plate_h]) Bolt6ClearHole();
		translate([-50,-50,Plate_h]) Bolt6ClearHole();
		translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360+25,0,Plate_h]) Bolt6ClearHole();
		translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360-20,20,Plate_h]) Bolt6ClearHole();
		translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360-20,-20,Plate_h]) Bolt6ClearHole();
	} // diff
	
	// Drive shaft
	translate([0,0,-Overlap]) OneWayRing(Ball_d=Ball_d, BC=BallCircle, nStops=7, Thickness=Pulley_w);
	
} // MainAndWinderBackingPlate

//translate([0,0,-11]) MainAndWinderBackingPlate();

module MainAndWinderFrontPlate(myFn=90){
	Pulley_w=Ball_d+2;
	Shaft_d=6.35;
	Plate_h=5;
	PlateSpace=41;
	
	translate([0,0,-Plate_h])
	difference(){
		union(){
						
			// Drive shaft
			cylinder(d=15,h=Plate_h);
			
			// Top Front Plate Post
			translate([-62,62,-PlateSpace]) cylinder(d=15,h=Plate_h+PlateSpace);
			
			// Bottom Front Plate Post
			translate([-62,-62,-PlateSpace]) cylinder(d=15,h=Plate_h+PlateSpace);
							
			// Drive shaft to Top Front Plate Post
			hull(){
				cylinder(d=15,h=Plate_h);
				translate([-62,62,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Drive shaft to Bottom Front Plate Post
			hull(){
				cylinder(d=15,h=Plate_h);
				translate([-62,-62,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Winder Shaft to Top Front Plate Post
			hull(){
				translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,0]) cylinder(d=15,h=Plate_h);
				translate([-62,62,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Winder Shaft to Bottom Front Plate Post
			hull(){
				translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,0]) cylinder(d=15,h=Plate_h);
				translate([-62,-62,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Drive shaft to Winder Shaft
			hull(){
				cylinder(d=15,h=Plate_h);
				translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,0]) cylinder(d=15,h=Plate_h);
			} // hull			
			
		} // union
		
		// Drive shaft
		
		translate([0,0,Plate_h]) Bolt6ButtonHeadHole();
		
		// Winder Shaft
		translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,Plate_h+11]) Bolt6Hole(depth=Plate_h+12);
			
		
		// Top Front Plate Post
			translate([-62,62,-PlateSpace+8]) Bolt6HeadHole(depth=12,lAccess=PlateSpace+Plate_h);
		// Bottom Front Plate Post
			translate([-62,-62,-PlateSpace+8]) Bolt6HeadHole(depth=12,lAccess=PlateSpace+Plate_h);
		
		
		translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,Plate_h-Ball_d]) 
				cylinder(d=PulleyBearing_BC+Ball_d+5,h=Ball_d+Overlap*2);
	} // diff
	
	// Drive shaft
//	translate([0,0,-Overlap]) OneWayRing(Ball_d=Ball_d, BC=BallCircle, nStops=7, Thickness=Pulley_w);
	
	// WinderBearing
	translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,-Ball_d]) 
				OnePieceOuterRace(BallCircle_d=PulleyBearing_BC, Race_OD=PulleyBearing_BC+Ball_d*2, Ball_d=Ball_d,
					Race_w=Ball_d, PreLoadAdj=-0.15, VOffset=0.00, BI=true, myFn=myFn);
} // MainAndWinderFrontPlate

//translate([0,0,47]) MainAndWinderFrontPlate();

module FrontPlate(){
	Pulley_w=Ball_d+2;
	Shaft_d=6.35;
	Plate_h=5;
	
	translate([0,0,-Plate_h])
	difference(){
		union(){
			// Drive shaft
			translate([0,0,-5]) cylinder(d=20,h=Plate_h+5);
			
			// Idle gear shaft
			translate([50+50,0,-30]) cylinder(d=15,h=Plate_h+30);
			
			// Reduction gear shaft 1
			translate([50+50+50+12,0,-2]) cylinder(d=15,h=Plate_h+2);
			
			// Reduction gear shaft 2
			translate([50+50+50+12,50+12,-6]) cylinder(d=15,h=Plate_h+6);
			
			// Mounting hole 1
			translate([50+50,50+20,-10]) cylinder(d=15,h=Plate_h+10);
			// Mounting hole 2
			translate([50+50,-50-20,-10]) cylinder(d=15,h=Plate_h+10);
			
			// Drive shaft to Idle gear shaft
			hull(){
				cylinder(d=15,h=Plate_h);
				translate([50+50,0,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Idle gear shaft to Reduction gear shaft 1
			hull(){
				translate([50+50,0,0]) cylinder(d=15,h=Plate_h);
				translate([50+50+50+12,0,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Reduction gear shaft 1 to Reduction gear shaft 2
			hull(){
				translate([50+50+50+12,0,0]) cylinder(d=15,h=Plate_h);
				translate([50+50+50+12,50+12,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Drive shaft to Reduction gear shaft 2
			hull(){
				cylinder(d=15,h=Plate_h);
				translate([50+50+50+12,50+12,0]) cylinder(d=15,h=Plate_h);
			}
			
			// Mounting hole 1 to Mounting hole 2
			hull(){
				translate([50+50,50+20,0]) cylinder(d=15,h=Plate_h);
				translate([50+50,-50-20,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
			// Mounting hole 2 to Drive shaft
			hull(){
				translate([50+50,-50-20,0]) cylinder(d=15,h=Plate_h);
				cylinder(d=15,h=Plate_h);
			} // hull
			
			// Mounting hole 2 to Reduction gear shaft 1
			hull(){
				translate([50+50,-50-20,0]) cylinder(d=15,h=Plate_h);
				translate([50+50+50+12,0,0]) cylinder(d=15,h=Plate_h);
			} // hull
			
		} // union
		
		// Drive shaft
		translate([0,0,Plate_h]) Bolt6HeadHole();
		// Idle gear shaft
		translate([50+50,0,-Overlap]) cylinder(d=GGC_BearingPinSmall,h=Plate_h+12+Overlap*2);
		// Reduction gear shaft 1
		translate([50+50+50+12,0,-Overlap]) cylinder(d=GGC_BearingPinSmall,h=Plate_h+12+Overlap*2);
		// Reduction gear shaft 2
		translate([50+50+50+12,50+12,-Overlap]) cylinder(d=GGC_BearingPinSmall,h=Plate_h+18+Overlap*2);
		
		// Mounting hole 1
			translate([50+50,50+20,Plate_h]) Bolt6HeadHole(depth=Plate_h+12);
		// Mounting hole 2
			translate([50+50,-50-20,Plate_h]) Bolt6HeadHole(depth=Plate_h+12);
	}
	
	
} // FrontPlate

//translate([0,0,42]) FrontPlate();

module DriveGearWithSpring(ShowGear=false,ShowSpiral=false){
	Base_w=Ball_d+2;
	nTeeth=60;
	Width=6;
	SpFn=12;
	Hub_r=15;
	Hub_h=6;
	SpStarts=5;
	
	
	PD=nTeeth*GGC_GearPitch/180;
	RimID=PD-GGC_GearPitch/90-Width*1.2;
	
	difference(){
		union(){
			if (ShowGear==true){
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
			
			for (j=[0:SpStarts-1]) rotate([0,0,360/SpStarts*j]) translate([0,RimID/2+2,Width-Overlap]) cylinder(d=4,h=4);
		} // union
			
			
			if (ShowSpiral==true){
			// Spiral
			for (k=[0:SpStarts-1])
				for (j=[2:2:720])
					hull(){
						rotate([0,0,j+360/SpStarts*k])
							translate([Hub_r+(RimID/2-Hub_r)/720*j,0,-Overlap]) cylinder(d=1,h=Width+Overlap*2,$fn=SpFn);
						rotate([0,0,j-2+360/SpStarts*k])
							translate([Hub_r+(RimID/2-Hub_r)/720*j,0,-Overlap]) cylinder(d=1,h=Width+Overlap*2,$fn=SpFn);
					} // hull
				} else {
					difference(){
						translate([0,0,-Overlap]) cylinder(d=RimID,h=Width+Overlap*2);
						translate([0,0,-Overlap*2]) cylinder(d=31,h=Width+Overlap*4);
					} // diff
				} // if
			
			
		translate([0,0,-Overlap])
			SplineHole(d=25, l=Hub_h+Overlap*2, nSplines=GGC_nSplines, Spline_w=30, Gap=SplineGap, Key=false);
	} // diff
} // DriveGearWithSpring

//DriveGearWithSpring(ShowGear=true,ShowSpiral=false);

module RotationLimiter(){
	Base_w=Ball_d+2;
	nTeeth=60;
	Width=6;
	SpFn=12;
	Hub_r=15;
	Hub_h=6;
	SpStarts=5;
	
	PD=nTeeth*GGC_GearPitch/180;
	RimID=PD-GGC_GearPitch/90-Width*1.2;
	
	difference(){
		union(){
			// Spokes
			for (j=[0:SpStarts-1]) rotate([0,0,360/SpStarts*j])
				WebbedSpoke(ID=30-Overlap,OD=RimID-5+Overlap,Spoke_w=6,Spoke_h=2,Web_h=4);

			// hub
			cylinder(d=30,h=Width);
			
			// rim
			difference(){
				union(){
					cylinder(d=RimID,h=Width);
					cylinder(d=PD+2,h=2);
				} // union
				translate([0,0,-Overlap]) cylinder(d=RimID-5,h=Width+Overlap*2);
			} // diff
		} // union
		
		// the limit slots
		for (j=[0:SpStarts-1]) rotate([0,0,360/SpStarts*j]) 
			for (k=[2:30])  hull(){
				rotate([0,0,k-2]) translate([0,RimID/2+2,-Overlap]) cylinder(d=4+IDXtra*2,h=2+Overlap*2);
				rotate([0,0,k]) translate([0,RimID/2+2,-Overlap]) cylinder(d=4+IDXtra*2,h=2+Overlap*2);
			} // hull
		
		translate([0,0,-Overlap])
			SplineHole(d=25, l=Hub_h+Overlap*2, nSplines=GGC_nSplines, Spline_w=30, Gap=SplineGap, Key=false);
	}
} // RotationLimiter

//translate([0,0,6+Overlap]) RotationLimiter();


module DriveHubP1(myFn=90, QuickView=false){
	Base_w=Ball_d+2;
	SpineLen=Base_w*2+12+Ball_d+1+WindingGear_h+1;
		
	difference(){
		union(){
			OneWayShaft(Ball_d=Ball_d, BC=BallCircle, nStops=14, Thickness=Base_w-1+Overlap);
			
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
	Hub_h=Base_w+Ball_d+WindingGear_h+1;
		
	difference(){
		union(){
			cylinder(d=BallCircle,h=WindingGear_h+1+Overlap);
			translate([0,0,WindingGear_h+1])
				OneWayShaft(Ball_d=Ball_d, BC=BallCircle, nStops=7, Thickness=Base_w-1+Overlap);
			
	
	
			translate([0,0,Base_w-1+WindingGear_h+1])
				OnePieceInnerRace(BallCircle_d=PulleyBearing_BC, Race_ID=10, Ball_d=Ball_d,
					Race_w=Ball_d+1, PreLoadAdj=-0.10, VOffset=0.50, BI=true, myFn=myFn);
		} // union
		
		translate([0,0,-Overlap])
			SplineHole(d=25, l=Hub_h+Overlap*2, nSplines=GGC_nSplines, Spline_w=30, Gap=SplineGap, Key=false);
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

module WindingGear(){
	nSpokes=7;
	
	difference(){
		gear (number_of_teeth=60,
					circular_pitch=GGC_GearPitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.2,
					gear_thickness=WindingGear_h,
					rim_thickness=WindingGear_h,
					rim_width=3,
					hub_thickness=WindingGear_h,
					hub_diameter=60,
					bore_diameter=BallCircle+8,
					circles=nSpokes,
					backlash=GearBacklash,
					twist=0,
					involute_facets=0,
					flat=false);
		
		// inner bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)]) 
			translate([OneWayRingOD(Ball_d=Ball_d, BC=BallCircle)/2,0,WindingGear_h])
				Bolt4HeadHole();
	} // diff
} // WindingGear

//WindingGear();



module WinderGear(myFn=36){
	Hub_h=25;
	Race_h=Ball_d+1;
	OAH=Hub_h+Race_h+2;
	
	difference(){
		union(){
			gear (number_of_teeth=nWinderGearTeeth,
					circular_pitch=GGC_GearPitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.2,
					gear_thickness=WindingGear_h,
					rim_thickness=WindingGear_h,
					rim_width=3,
					hub_thickness=Hub_h,
					hub_diameter=PulleyBearing_BC-Ball_d*0.7,
					bore_diameter=12,
					circles=7,
					backlash=GearBacklash,
					twist=0,
					involute_facets=0,
					flat=false);
			
			translate([0,0,Hub_h-Overlap])
				OnePieceInnerRace(BallCircle_d=PulleyBearing_BC, Race_ID=10, Ball_d=Ball_d,
					Race_w=Race_h, PreLoadAdj=-0.15, VOffset=0.50, BI=true, myFn=myFn);
			
			cylinder(d=30,h=OAH);
		} // union
	
		translate([0,0,-Overlap])
			SplineHole(d=25, l=OAH+Overlap*2, nSplines=GGC_nSplines, Spline_w=30, Gap=SplineGap, Key=false);
	} // diff
	
	
} // WinderGear

//translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,13]) WinderGear();

module WinderHandle(){
	difference(){
		union(){
			hull(){
				cylinder(d=34,h=10);
				translate([0,100,0]) cylinder(d=20,h=10);
			} // hull
			translate([0,100,0]) cylinder(d=20,h=12);
		} // union
		
		translate([0,100,0]) rotate([180,0,0]) Bolt6HeadHole();
		
		translate([0,0,-Overlap])
			SplineHole(d=25, l=10+Overlap*2, nSplines=GGC_nSplines, Spline_w=30, Gap=SplineGap, Key=false);
	} // diff
} // WinderHandle

//translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,13+25+Ball_d+3]) WinderHandle();

module WinderShaft(){
	SpineLen=60;
	
	difference(){
		union(){
			cylinder(d=30,h=13);
	
			SplineShaft(d=25, l=SpineLen, nSplines=GGC_nSplines, Spline_w=30, Hole=12, Key=false);
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=12.7,h=5);
		translate([0,0,-Overlap]) cylinder(d=12,h=13+Overlap*2);
		
		//translate([0,0,SpineLen-5]) cylinder(d=12.7,h=5+Overlap);
	} // diff
} // WinderShaft

//translate([-60*GGC_GearPitch/360-nWinderGearTeeth*GGC_GearPitch/360,0,0]) WinderShaft();

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












