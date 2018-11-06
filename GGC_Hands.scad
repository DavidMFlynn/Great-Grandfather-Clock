// **********************************************************
// Clock Hands
// Filename: GGC_Hands.scad
// Project: Great Grandfather Clock
// Created: 11/5/2018
// Revision: 0.1 11/5/2018
// Units: mm
// *********************************************************
// History:
// 0.1 11/5/2018 First code
// *********************************************************
// for STL output
//
// *********************************************************
// Routines
//
// *********************************************************
// for Viewing
//
// *********************************************************
include<GGC_Basic.scad>

//GGC_Face_d

//PuzzleConnector(Thickness=6);

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
		translate([0,0,-Overlap]) cylinder(d=12.7,h=15+Overlap*2);
		
		// counter weight cavity
		translate([-50,0,1]) cylinder(d=14,h=15+Overlap*2);
	} // diff
	
} // SecondHandHub

SecondHandHub();

module SecondHand(){
	difference(){
		hull(){
			translate([0,-20/2,0]) cube([Overlap,20,5]);
			translate([GGC_Face_d/2-100,0,0]) cylinder(d=2,h=5);
		} // hull
		translate([0,0,-Overlap])PuzzleConnector(Thickness=5+Overlap*2);
	} // diff
	
	
} // SecondHand

translate([100,0,0]) color("Blue") SecondHand();

