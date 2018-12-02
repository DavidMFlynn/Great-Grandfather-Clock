// **********************************************************
// Hour Hand Gears
// Filename: GGC_HourGears.scad
// Project: Great Grandfather Clock
// Created: 11/8/2018
// by: David M. Flynn
// Licence: GPL3.0
// Revision: 0.2 11/17/2018
// Units: mm
// *********************************************************
// History:
// 0.2 11/17/2018 Printing front/back plates, no mounting yet.
// 0.1 11/8/2018 First code
// *********************************************************
// Notes:
//  Gear Centers
//    (0,0) Input Gear, GearA+GearA15, GearC+GearA15
//    (100,0) Clock center, SecondHandGear, MinuteHandGear, HourHandGear
//    (0,62.5) GearC+GearB16, GearA+GearA15
//    rotate(0,0,60) translate(0,62.5) GearB+GearA15
//    translate(100,0)	rotate(0,0,116.5) translate(37.5+50,0) GearIdle60
// *********************************************************
// for STL output
// SecondHandGear();
// MinuteHandGear();
// HourHandGear();
//
// GearIdle60(); // print 1
// GearA(); // print 2
// GearA15(); // print 4
// GearB(); // print 1
// GearB16(); // print 1
// GearC(); // print 2
// GearIdleN(T=nTeeth_SecondHandIdle,QuickView=false); // print 1
//
//rotate([180,0,0]) mirror([0,0,1]) BackPlate();
//FrontPlate();
// *********************************************************
// Routines
//
// *********************************************************
// for Viewing
// ShowTimeKeepingGears();
 translate([0,0,19]) mirror([0,0,1]) BackPlate();
 translate([0,0,-31]) FrontPlate();
// *********************************************************
include<GGC_Basic.scad>

//GGC_SecondHandShaft_d=3/8*25.4;
//GGC_MinuteHandShaft_d=4/8*25.4;
//GGC_HourHandShaft_d=5/8*25.4;

module BackPlate(){
	difference(){
		union(){
			translate([0,0,0]) cylinder(d=15,h=6);
			// hands
			translate([100,0,0]) cylinder(d=20,h=6);
			translate([0,62.5,0]) cylinder(d=15,h=6);
			rotate([0,0,60]) translate([0,62.5,0]) cylinder(d=15,h=18);
			translate([100,0,0]) rotate([0,0,116.5]) translate([37.5+50,0]) cylinder(d=15,h=30);
			// second hand idle
			rotate([0,0,-45]) translate([20+50,0,0]) cylinder(d=15,h=6);
			
			hull(){
				translate([0,0,0]) cylinder(d=10,h=5);
				// second hand idle
				rotate([0,0,-45]) translate([20+50,0,0]) cylinder(d=10,h=5);
			} // hull
			
			hull(){
				translate([0,0,0]) cylinder(d=10,h=5);
				translate([100,0,0]) cylinder(d=10,h=5);
			} // hull
			
			hull(){
				translate([100,0,0]) cylinder(d=10,h=5);
				// second hand idle
				rotate([0,0,-45]) translate([20+50,0,0]) cylinder(d=10,h=5);
			} // hull
			
			hull(){
				translate([100,0,0]) cylinder(d=10,h=5);
				translate([0,62.5,0]) cylinder(d=10,h=5);
			} // hull
			
			hull(){
				translate([0,62.5,0]) cylinder(d=10,h=5);
				rotate([0,0,60]) translate([0,62.5,0]) cylinder(d=10,h=5);
			} // hull
			
			hull(){
				translate([100,0,0]) cylinder(d=10,h=5);
				translate([100,0,0]) rotate([0,0,116.5]) translate([37.5+50,0]) cylinder(d=10,h=5);
			} // hull
			
			hull(){
				translate([100,0,0]) cylinder(d=10,h=5);
				translate([100,0,0]) rotate([0,0,116.5]) translate([37.5+50,0]) cylinder(d=10,h=5);
			} // hull
			
			hull(){
				translate([0,0,0]) cylinder(d=10,h=5);
				rotate([0,0,60]) translate([0,62.5,0]) cylinder(d=10,h=5);
			}
			
			hull(){
				translate([0,0,0]) cylinder(d=10,h=5);
				translate([100,0,0]) rotate([0,0,116.5]) translate([37.5+50,0,0]) cylinder(d=10,h=5);
			}
		} // union
	
		translate([0,0,5]) {
			for (j=[1:4]) translate([100/5*j,0,0]) Bolt4Hole();
			translate([100,0,0]) rotate([0,0,116.5]) for (j=[1:4]) translate([(37.5+50)/5*j,0,0]) Bolt4Hole();
			translate([0,62.5,0]) rotate([0,0,120]) for (j=[1:3]) translate([0,62.5/4*j,0]) Bolt4Hole();
			}
		
		translate([0,0,-Overlap]){
			translate([0,0,0]) cylinder(d=GGC_BearingPinSmall,h=6+Overlap*2);
			translate([100,0,0]) cylinder(d=GGC_SecondHandShaft_d,h=12+Overlap*2);
			translate([0,62.5,0]) cylinder(d=GGC_BearingPinSmall,h=6+Overlap*2);
			rotate([0,0,60]) translate([0,62.5,0]) cylinder(d=GGC_BearingPinSmall,h=18+Overlap*2);
			translate([100,0,0]) rotate([0,0,116.5]) translate([37.5+50,0]) cylinder(d=GGC_BearingPinSmall,h=30+Overlap*2);
			rotate([0,0,-45]) translate([20+50,0,0]) cylinder(d=GGC_BearingPinSmall,h=30+Overlap*2);
			}

	} // diff
} // BackPlate

//translate([0,0,19]) mirror([0,0,1]) BackPlate();

module FrontPlate(){
	difference(){
		union(){
			translate([0,0,0]) cylinder(d=15,h=6);
			translate([100,0,0]) cylinder(d=20,h=12);
			translate([0,62.5,0]) cylinder(d=15,h=6);
			rotate([0,0,60]) translate([0,62.5,0]) cylinder(d=15,h=18);
			translate([100,0,0]) rotate([0,0,116.5]) translate([37.5+50,0]) cylinder(d=15,h=12);
			// second hand idle
			rotate([0,0,-45]) translate([20+50,0,0]) cylinder(d=15,h=30);
			
			hull(){
				translate([0,0,0]) cylinder(d=10,h=5);
				// second hand idle
				rotate([0,0,-45]) translate([20+50,0,0]) cylinder(d=10,h=5);
			} // hull
			
			hull(){
				translate([0,0,0]) cylinder(d=10,h=5);
				translate([100,0,0]) cylinder(d=10,h=5);
			} // hull
			
			hull(){
				translate([100,0,0]) cylinder(d=10,h=5);
				// second hand idle
				rotate([0,0,-45]) translate([20+50,0,0]) cylinder(d=10,h=5);
			} // hull
			
			hull(){
				translate([100,0,0]) cylinder(d=10,h=5);
				translate([0,62.5,0]) cylinder(d=10,h=5);
			} // hull
			
			hull(){
				translate([0,62.5,0]) cylinder(d=10,h=5);
				rotate([0,0,60]) translate([0,62.5,0]) cylinder(d=10,h=5);
			} // hull
			
			hull(){
				translate([100,0,0]) cylinder(d=10,h=5);
				translate([100,0,0]) rotate([0,0,116.5]) translate([37.5+50,0]) cylinder(d=10,h=5);
			} // hull
			
			hull(){
				translate([100,0,0]) cylinder(d=10,h=5);
				translate([100,0,0]) rotate([0,0,116.5]) translate([37.5+50,0]) cylinder(d=10,h=5);
			} // hull
			
			hull(){
				translate([0,0,0]) cylinder(d=10,h=5);
				rotate([0,0,60]) translate([0,62.5,0]) cylinder(d=10,h=5);
			}
			
			hull(){
				translate([0,0,0]) cylinder(d=10,h=5);
				translate([100,0,0]) rotate([0,0,116.5]) translate([37.5+50,0]) cylinder(d=10,h=5);
			}
		} // union
	
		translate([0,0,5]) {
			for (j=[1:4]) translate([100/5*j,0,0]) Bolt4Hole();
			translate([100,0,0]) rotate([0,0,116.5]) for (j=[1:4]) translate([(37.5+50)/5*j,0,0]) Bolt4Hole();
			translate([0,62.5,0]) rotate([0,0,120]) for (j=[1:3]) translate([0,62.5/4*j,0]) Bolt4Hole();
			}
			
		translate([0,0,-Overlap]){
			translate([0,0,0]) cylinder(d=GGC_BearingPinSmall,h=6+Overlap*2);
			translate([100,0,0]) cylinder(d=GGC_HourHandShaft_d,h=12+Overlap*2);
			translate([0,62.5,0]) cylinder(d=GGC_BearingPinSmall,h=6+Overlap*2);
			rotate([0,0,60]) translate([0,62.5,0]) cylinder(d=GGC_BearingPinSmall,h=18+Overlap*2);
			translate([100,0,0]) rotate([0,0,116.5]) translate([37.5+50,0]) cylinder(d=GGC_BearingPinSmall,h=12+Overlap*2);
			rotate([0,0,-45]) translate([20+50,0,0]) cylinder(d=GGC_BearingPinSmall,h=30+Overlap*2);
		}

	} // diff
} // FrontPlate

//translate([0,0,-31]) FrontPlate();
FrameWidth=50;
FrameThickness=5;
module PlateMount1(){
	
	Post1_X=15;
	Post1_Y=-65;
	
	difference(){
		union(){
			
			translate([Post1_X,Post1_Y,0]) cylinder(d=25,h=FrameThickness);
			for (j=[1:4]) translate([100/5*j,0,0]) cylinder(d=10,h=FrameThickness);
			
			for (j=[1:4]) hull(){
				translate([Post1_X,Post1_Y,0]) cylinder(d=5,h=FrameThickness);
				translate([100/5*j,0,0]) cylinder(d=5,h=FrameThickness);
			}
				
		
		} // union
		
		translate([Post1_X,Post1_Y,-Overlap]) cylinder(d=7,h=FrameThickness+Overlap*2);
		
		for (j=[1:4]) translate([100/5*j,0,FrameThickness]) Bolt4ButtonHeadHole();
			
		for (j=[0:3]) translate([Post1_X,Post1_Y,FrameThickness]) rotate([0,0,120*j]) translate([8,0,0]) Bolt4ButtonHeadHole();
	} // diff
} // PlateMount1

translate([0,0,18]) PlateMount1();

module GearA(QuickView=false){
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch,
				nSpokes=5, 
				Hub_h=6, HasSpline=true, SplineLen=5+6,
				Bore_d=GGC_BearingPinSmall,QuickView=QuickView);
} // GearA

module GearA15(){
	SpurGear(nTeeth=15, Pitch=GGC_GearPitch,
				Width=GGC_GearWidth, 
				Bore_d=GGC_BearingPinSmall, HasSpline=true);	
} // GearA15

module GearB(QuickView=false){
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitchSmall,
				nSpokes=5, 
				Hub_h=6, HasSpline=true, SplineLen=5+6,
				Bore_d=GGC_BearingPinSmall,QuickView=QuickView);
} // GearB

module GearB16(){
SpurGear(nTeeth=16, Pitch=GGC_GearPitchSmall,
				Width=GGC_GearWidth, 
				Bore_d=GGC_BearingPinSmall, HasSpline=true);				
} // GearB16

module GearC(QuickView=false){
	// tripple height hub
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch,
				nSpokes=5, 
				Hub_h=6+6+6, HasSpline=true, SplineLen=5+6+6+6,
				Bore_d=GGC_BearingPinSmall,QuickView=QuickView);
} // GearC

module SecondHandGear(QuickView=false){
	SpokedGear(nTeeth=nTeeth_SecondHand, GearPitch=GGC_GearPitch,
				nSpokes=5, 
				Hub_h=12, HasSpline=false, SplineLen=0,
				Bore_d=GGC_SecondHandShaft_d,QuickView=QuickView);
} // SecondHandGear

module MinuteHandGear(QuickView=false){
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch,
				nSpokes=5, 
				Hub_h=6, HasSpline=false, SplineLen=0,
				Bore_d=GGC_MinuteHandShaft_d,QuickView=QuickView);
} // MinuteHandGear

module HourHandGear(QuickView=false){
	SpokedGear(nTeeth=45, GearPitch=GGC_GearPitch,
				nSpokes=5, 
				Hub_h=6+6, HasSpline=false, SplineLen=0,
				Bore_d=GGC_HourHandShaft_d,QuickView=QuickView);
} // HourHandGear

module GearIdle60(QuickView=false){
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch,
				nSpokes=5, 
				Hub_h=6, HasSpline=false, SplineLen=0,
				Bore_d=GGC_BearingPinSmall,QuickView=QuickView);	
} // GearIdle60

module GearIdleN(T=20,QuickView=false){
	SpokedGear(nTeeth=T, GearPitch=GGC_GearPitch, Width=GGC_GearWidth*2+1,
				nSpokes=5, 
				Hub_h=GGC_GearWidth*2+2, HasSpline=false, SplineLen=0,
				Bore_d=GGC_BearingPinSmall,QuickView=QuickView);	
	
} // GearIdleN

nTeeth_SecondHand=60;
nTeeth_SecondHandIdle=24;

module ShowTimeKeepingGears(QuickView=true){
	// input gear 60t/min
	color("Blue") GearA(QuickView=QuickView);

	// first reduction 15t/min
	translate([0,0,6+Overlap]) GearA15();	

	// second hand gear 60t/min
	translate([100,0,6+6]) rotate([0,0,180/60]) color("Tan") rotate([180,0,0]) SecondHandGear(QuickView=QuickView);
	
	// second hand idle gear 60t/min
	rotate([0,0,-45]) translate([20+50,0,0]) GearIdleN(T=nTeeth_SecondHandIdle,QuickView=QuickView);

	// minute hand gear 60t/hour
	translate([100,0,-6])	rotate([0,0,0])	color("Tan") MinuteHandGear(QuickView=QuickView);

	// hour hand gear 3.75t/hour, pitch radius = 37.5
	translate([100,0,-6-6-6])	rotate([0,0,0])	color("Tan") HourHandGear(QuickView=QuickView);

	// hour idle gear 3.75t/h
	translate([100,0,-6-6-6])	rotate([0,0,116.5]) translate([37.5+50,0,0]) GearIdle60(QuickView=QuickView);

	// middle gear 1, 15t/min
	translate([0,62.5,5+6])	rotate([180,0,180/60]) GearC(QuickView=QuickView);

	// second reduction 4t/min
	translate([0,62.5,-1-6-Overlap])	rotate([180,0,180/60])	GearB16();	

	translate([0,62.5,0]) rotate([0,0,-60]) translate([0,-62.5,0]){
		// middle gear 2, 4t/min
		translate([0,0,-12])	rotate([0,0,180/60]) GearB(QuickView=QuickView);
					
		// Third reduction 1t/min = 60t/h
		translate([0,0,-6-Overlap])	rotate([0,0,180/60]) GearA15();
	}

	// hour idle, 60t/h
	translate([0,0,-1]) rotate([180,0,180/60]) color("Pink") GearC(QuickView=QuickView);

	// Fourth reduction 15t/h
	translate([0,0,-1-6-6-6-Overlap])	rotate([180,0,180/60]) color("Pink") GearA15();

	// middle gear 3 15t/h
	translate([0,62.5,-6-6-6-6]) rotate([0,0,180/60]) color("Pink") GearA(QuickView=QuickView);

	// Fifth reduction 3.75t/h
	translate([0,62.5,-6-6-6-Overlap])	rotate([0,0,180/60]) color("Pink") GearA15();
} // ShowTimeKeepingGears














				
				