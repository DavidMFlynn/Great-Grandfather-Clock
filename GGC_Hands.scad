// **********************************************************
// Clock Hands
// Filename: GGC_Hands.scad
// Project: Great Grandfather Clock
// Created: 11/5/2018
// by: David M. Flynn
// Licence: GPL3.0
// Revision: 0.3 12/9/2018
// Units: mm
// *********************************************************
// History:
// 0.3 12/9/2018 Minute hand
// 0.2 11/10/2018 Hour hand
// 0.1 11/5/2018 First code
// *********************************************************
// for STL output
//SecondHandHub();
//SecondHand();

//MinuteHand();
//MinuteHandHub();

//HourHandTail(); // arrow fletch
//HourHandHub();
//HourHand(); // arrow head
// *********************************************************
// Routines
//
// *********************************************************
// for Viewing
//rotate([0,0,10]) ShowSecondHand();
//rotate([0,0,-10]) ShowHourHand();
// *********************************************************
include<GGC_Basic.scad>

//GGC_SecondHandShaft_d=3/8*25.4;
//GGC_MinuteHandShaft_d=4/8*25.4;
//GGC_HourHandShaft_d=5/8*25.4;

//GGC_Face_d

//PuzzleConnector(Thickness=6);

ArrowShaft_d=16;

module HourHandTail(){
	difference(){
		rotate([0,90,0]) cylinder(d=ArrowShaft_d,h=100);
		translate([-Overlap,-ArrowShaft_d/2-Overlap,-ArrowShaft_d/2-Overlap])
			cube([100+Overlap*2,ArrowShaft_d+Overlap*2,ArrowShaft_d/2+Overlap]);
	}
	translate([100,0,0]) PuzzleConnector(Thickness=5);
	
	for (j=[1:3]) translate([15*j,0,0]){
		hull(){
			cube([10,0.01,2]);
			translate([-10,25,0]) cube([10,0.01,2]);
		} // hull
		mirror([0,1,0])
		hull(){
			cube([10,0.01,2]);
			translate([-10,25,0]) cube([10,0.01,2]);
		} // hull
	}
} // HourHandTail

//translate([-150,0,0])HourHandTail();

module HourHandHub(){
	difference(){
		union(){
			cylinder(d1=30,d2=25,h=15);
			
			// hand connection
			hull(){
				cylinder(d=20,h=5);
				translate([100-Overlap,-20/2,0]) cube([Overlap,20,5]);
			} // hull
			
			// tail connection
			hull(){
				cylinder(d=20,h=5);
				translate([-50+Overlap,-20/2,0]) cube([Overlap,20,5]);
			} // hull
			
			// counter weight
			//translate([-50,0,0])cylinder(d1=30,d2=25,h=14);
			//translate([-50,-5,0]) cube([50,10,5]);
		} // union
		
		translate([100,0,-Overlap]) mirror([1,0,0]) PuzzleConnector(Thickness=5+Overlap*2);
		translate([-50,0,-Overlap]) PuzzleConnector(Thickness=5+Overlap*2);
		
		// center hole
		translate([0,0,-Overlap]) cylinder(d=GGC_HourHandShaft_d,h=15+Overlap*2);
		
		// counter weight cavity
		//translate([-50,0,1]) cylinder(d=14,h=15+Overlap*2);
	} // diff
	
} // HourHandHub

//translate([0,0,5]) rotate([180,0,0]) HourHandHub();

module HourHand(){
	
	
	difference(){
		hull(){
			translate([0,-35,0]) cube([Overlap,70,2]);
			translate([100,0,0]) cylinder(d=2,h=2);
			translate([0,-25,0]) cube([Overlap,50,5]);
			translate([80,0,0]) cylinder(d=2,h=5);
		} // hull
		
		translate([0,0,-Overlap]){
			hull(){
				translate([5,-23,0]) cube([Overlap,46,5+Overlap*2]);
				translate([70,0,0]) cylinder(d=2,h=5+Overlap*2);
			} // hull
		}
	} // diff
	
	difference(){
		union(){
			translate([-50,0,0]) rotate([0,90,0]) cylinder(d=ArrowShaft_d,h=110);
			translate([60,0,0]) sphere(d=ArrowShaft_d);
		} // union
		
		translate([-50-Overlap,-ArrowShaft_d/2-Overlap,-ArrowShaft_d/2-Overlap])
			cube([110+ArrowShaft_d/2+Overlap*2,ArrowShaft_d+Overlap*2,ArrowShaft_d/2+Overlap]);
	} // diff
	
	translate([-50,0,0]) mirror([1,0,0]) PuzzleConnector(Thickness=5);
} // HourHand

//translate([100,0,0]) HourHand();

module ShowHourHand(){
	rotate([0,0,90]){
	translate([150,0,0]) HourHand();
	translate([-150,0,0])HourHandTail();
	translate([0,0,5]) rotate([180,0,0]) HourHandHub();}
} // ShowHourHand

//ShowHourHand();

module ShowSecondHand(){
	rotate([0,0,90]) translate([0,0,30]) rotate([180,0,0]){
		SecondHandHub();
		translate([100,0,0]) SecondHand();
	}
} // ShowSecondHand

//rotate([0,0,10]) ShowSecondHand();

module SecondHandHub(){
	difference(){
		union(){
			cylinder(d1=30,d2=25,h=15);
			translate([100,0,0]) PuzzleConnector(Thickness=5);
			// hand connection
			hull(){
				cylinder(d=20,h=5);
				translate([100-Overlap,-20/2,0]) cube([Overlap,20,5]);
			} // hull
			
			// counter weight
			translate([-50,0,0])cylinder(d1=30,d2=25,h=14);
			translate([-50,-5,0]) cube([50,10,5]);
		} // union
		
		// center hole
		translate([0,0,-Overlap]) cylinder(d=GGC_SecondHandShaft_d,h=15+Overlap*2);
		
		// counter weight cavity
		translate([-50,0,1]) cylinder(d=14,h=15+Overlap*2);
	} // diff
	
} // SecondHandHub

//SecondHandHub();

module SecondHand(){
	difference(){
		hull(){
			translate([0,-20/2,0]) cube([Overlap,20,5]);
			translate([GGC_Face_d/2-100,0,0]) cylinder(d=2,h=5);
		} // hull
		translate([0,0,-Overlap])PuzzleConnector(Thickness=5+Overlap*2);
	} // diff
	
	
} // SecondHand

//translate([100,0,0]) color("Blue") SecondHand();

module MinuteHandHub(){
	difference(){
		union(){
			cylinder(d1=30,d2=25,h=15);
			translate([100,0,0]) PuzzleConnector(Thickness=5);
			// hand connection
			hull(){
				cylinder(d=20,h=5);
				translate([100-Overlap,-20/2,0]) cube([Overlap,20,5]);
			} // hull
			
			// counter weight
			translate([-50,0,0])cylinder(d1=30,d2=25,h=14);
			translate([-50,-5,0]) cube([50,10,5]);
		} // union
		
		// center hole
		translate([0,0,-Overlap]) cylinder(d=GGC_MinuteHandShaft_d,h=15+Overlap*2);
		
		// counter weight cavity
		translate([-50,0,1]) cylinder(d=14,h=15+Overlap*2);
	} // diff
	
} // MinuteHandHub

//MinuteHandHub();

module MinuteHand(){
	difference(){
		hull(){
			translate([0,-20/2,0]) cube([Overlap,20,5]);
			translate([GGC_Face_d/2-150,0,0]) cylinder(d=2,h=5);
		} // hull
		translate([0,0,-Overlap])PuzzleConnector(Thickness=5+Overlap*2);
	} // diff
} // MinuteHand

//MinuteHand();




























