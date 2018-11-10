// **********************************************************
// Hour Hand Gears
// Filename: GGC_HourGears.scad
// Project: Great Grandfather Clock
// Created: 11/8/2018
// by: David M. Flynn
// Licence: GPL3.0
// Revision: 0.1 11/8/2018
// Units: mm
// *********************************************************
// History:
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
// *********************************************************
// Routines
//
// *********************************************************
// for Viewing
// ShowTimeKeepingGears();
// translate([0,0,19]) mirror([0,0,1]) BackPlate();
// translate([0,0,-31]) FrontPlate();
// *********************************************************
include<GGC_Basic.scad>

//GGC_SecondHandShaft_d=3/8*25.4;
//GGC_MinuteHandShaft_d=4/8*25.4;
//GGC_HourHandShaft_d=5/8*25.4;

module BackPlate(){
	difference(){
		union(){
			translate([0,0,0]) cylinder(d=15,h=6);
			translate([100,0,0]) cylinder(d=20,h=12);
			translate([0,62.5,0]) cylinder(d=15,h=6);
			rotate([0,0,60]) translate([0,62.5,0]) cylinder(d=15,h=18);
			translate([100,0,0]) rotate([0,0,116.5]) translate([37.5+50,0]) cylinder(d=15,h=30);
			
			hull(){
				translate([0,0,0]) cylinder(d=10,h=5);
				translate([100,0,0]) cylinder(d=10,h=5);
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
			
			hull(){
				translate([0,0,0]) cylinder(d=10,h=5);
				translate([100,0,0]) cylinder(d=10,h=5);
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
	
		translate([0,0,-Overlap]){
			translate([0,0,0]) cylinder(d=GGC_BearingPinSmall,h=6+Overlap*2);
			translate([100,0,0]) cylinder(d=GGC_HourHandShaft_d,h=12+Overlap*2);
			translate([0,62.5,0]) cylinder(d=GGC_BearingPinSmall,h=6+Overlap*2);
			rotate([0,0,60]) translate([0,62.5,0]) cylinder(d=GGC_BearingPinSmall,h=18+Overlap*2);
			translate([100,0,0]) rotate([0,0,116.5]) translate([37.5+50,0]) cylinder(d=GGC_BearingPinSmall,h=12+Overlap*2);
		}

	} // diff
} // FrontPlate

//translate([0,0,-31]) FrontPlate();

module GearA(){
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch,
				nSpokes=5, 
				Hub_h=6, HasSpline=true, SplineLen=5+6,
				Bore_d=GGC_BearingPinSmall);
} // GearA

module GearA15(){
	SpurGear(nTeeth=15, Pitch=GGC_GearPitch,
				Width=GGC_GearWidth, 
				Bore_d=GGC_BearingPinSmall, HasSpline=true);	
} // GearA15

module GearB(){
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitchSmall,
				nSpokes=5, 
				Hub_h=6, HasSpline=true, SplineLen=5+6,
				Bore_d=GGC_BearingPinSmall);
} // GearB

module GearB16(){
SpurGear(nTeeth=16, Pitch=GGC_GearPitchSmall,
				Width=GGC_GearWidth, 
				Bore_d=GGC_BearingPinSmall, HasSpline=true);				
} // GearB16

module GearC(){
	// tripple height hub
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch,
				nSpokes=5, 
				Hub_h=6+6+6, HasSpline=true, SplineLen=5+6+6+6,
				Bore_d=GGC_BearingPinSmall);
} // GearC

module SecondHandGear(){
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch,
				nSpokes=5, 
				Hub_h=6, HasSpline=false, SplineLen=0,
				Bore_d=GGC_SecondHandShaft_d);
} // SecondHandGear

module MinuteHandGear(){
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch,
				nSpokes=5, 
				Hub_h=6, HasSpline=false, SplineLen=0,
				Bore_d=GGC_MinuteHandShaft_d);
} // MinuteHandGear

module HourHandGear(){
	SpokedGear(nTeeth=45, GearPitch=GGC_GearPitch,
				nSpokes=5, 
				Hub_h=6+6, HasSpline=false, SplineLen=0,
				Bore_d=GGC_HourHandShaft_d);
} // HourHandGear

module GearIdle60(){
	SpokedGear(nTeeth=60, GearPitch=GGC_GearPitch,
				nSpokes=5, 
				Hub_h=6, HasSpline=false, SplineLen=0,
				Bore_d=GGC_BearingPinSmall);	
} // GearIdle60


module ShowTimeKeepingGears(){
	// input gear 60t/min
	color("Blue") GearA();

	// first reduction 15t/min
	translate([0,0,6+Overlap]) GearA15();	

	// second hand gear 60t/min
	translate([100,0,0]) rotate([0,0,180/60]) color("Tan") SecondHandGear();

	// minute hand gear 60t/hour
	translate([100,0,-6])	rotate([0,0,0])	color("Tan") MinuteHandGear();

	// hour hand gear 3.75t/hour, pitch radius = 37.5
	translate([100,0,-6-6-6])	rotate([0,0,0])	color("Tan") HourHandGear();

	// hour idle gear 3.75t/h
	translate([100,0,-6-6-6])	rotate([0,0,116.5]) translate([37.5+50,0,0]) GearIdle60();

	// middle gear 1, 15t/min
	translate([0,62.5,5+6])	rotate([180,0,180/60]) GearC();

	// second reduction 4t/min
	translate([0,62.5,-1-6-Overlap])	rotate([180,0,180/60])	GearB16();	

	translate([0,62.5,0]) rotate([0,0,-60]) translate([0,-62.5,0]){
		// middle gear 2, 4t/min
		translate([0,0,-12])	rotate([0,0,180/60]) GearB();
					
		// Third reduction 1t/min = 60t/h
		translate([0,0,-6-Overlap])	rotate([0,0,180/60]) GearA15();
	}

	// hour idle, 60t/h
	translate([0,0,-1]) rotate([180,0,180/60]) color("Pink") GearC();

	// Fourth reduction 15t/h
	translate([0,0,-1-6-6-6-Overlap])	rotate([180,0,180/60]) color("Pink") GearA15();

	// middle gear 3 15t/h
	translate([0,62.5,-6-6-6-6]) rotate([0,0,180/60]) color("Pink") GearA();

	// Fifth reduction 3.75t/h
	translate([0,62.5,-6-6-6-Overlap])	rotate([0,0,180/60]) color("Pink") GearA15();
} // ShowTimeKeepingGears














				
				