// **********************************************************
// Face Support
// Filename: GGC_FaceSupport.scad
// Project: Great Grandfather Clock
// Created: 10/29/2018
// Revision: 0.1 10/29/2018
// Units: mm
// *********************************************************
// History:
// 0.1 10/29/2018 First code
// *********************************************************
// for STL output
// Twelfth();
// Hub12();
// TwelfthConnector();
// *********************************************************
// Routines
// PuzzleConnector(Thickness=6);
// Socket_12(Base_d=30,Height=10);
// NumberSupportBase(Len=20);
// *********************************************************
// for Viewing
//ShowBackingPlate();
// *********************************************************

include<CommonStuffSAEmm.scad>

$fn=90;
Overlap=0.05;

GGC_Face_d=600;
GGC_Band_w=40;
GGC_Band_t=3;
GGC_FaceSocket_d=30;

module NumberSupportBase(Len=20){
	
	Socket_12(Base_d=GGC_FaceSocket_d,Height=10);
	
	cylinder(d=12,h=Len);
	
} // NumberSupportBase

//NumberSupportBase();


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

module Hub12(){
	difference(){
		union(){
			cylinder(d=120,h=GGC_Band_t);
			
			for (j=[0:11]) rotate([0,0,30*j+15]) hull(){
				translate([-GGC_Band_w*0.7/2,TwelfthInset,0]) cube([GGC_Band_w*0.7,0.1, GGC_Band_t]);
				translate([0,60,0]) cylinder(d=GGC_Band_w*0.7,h=GGC_Band_t);}
		} // union
		
		for (j=[0:11]) rotate([0,0,30*j+15])
			translate([0,60,GGC_Band_t]) Bolt6ClearHole();
		
		translate([0,0,-Overlap]) cylinder(d=90,h=GGC_Band_t+Overlap*2);
	} // diff
	
	for (j=[0:11]) rotate([0,0,30*j+15]) 
		translate([0,TwelfthInset,0]) rotate([0,0,90]) PuzzleConnector(Thickness=GGC_Band_t+Overlap*2);
	
	
} // Hub12

//Hub12();

TwelfthInset=75;

module TwelfthConnector(){
	difference(){
		translate([-GGC_Band_w*0.7/2,0,0]) cube([GGC_Band_w*0.7,GGC_Face_d/2-TwelfthInset*2,GGC_Band_t]);
		translate([0,GGC_Face_d/2-TwelfthInset*2,-Overlap]) rotate([0,0,-90]) PuzzleConnector(Thickness=GGC_Band_t+Overlap*2);
	} // diff
	
	translate([0,0,-Overlap]) rotate([0,0,-90]) PuzzleConnector(Thickness=GGC_Band_t+Overlap*2);
} // TwelfthConnector

//for (j=[0:11])
//rotate([0,0,30*j+15]) translate([0,-GGC_Face_d/2+TwelfthInset,0]) color("Blue") TwelfthConnector();

module Twelfth(){
	
	difference(){
		union(){
			hull(){
				translate([0,-GGC_Face_d/2*cos(15)-GGC_Band_w/2,0]) cube([0.1,GGC_Band_w,GGC_Band_t]);
				rotate([0,0,15]) translate([0,-GGC_Face_d/2,0]) cylinder(d=GGC_Band_w,h=GGC_Band_t);
			} // hull
			hull(){
				rotate([0,0,30]) translate([-0.1,-GGC_Face_d/2*cos(15)-GGC_Band_w/2,0]) cube([0.1,GGC_Band_w,GGC_Band_t]);
				rotate([0,0,15]) translate([0,-GGC_Face_d/2,0]) cylinder(d=GGC_Band_w,h=GGC_Band_t);
			} // hull
			
			hull(){
				rotate([0,0,15]) translate([-GGC_Band_w*0.7/2,-GGC_Face_d/2+TwelfthInset-0.1,0]) cube([GGC_Band_w*0.7,0.1,GGC_Band_t]);
				rotate([0,0,15]) translate([0,-GGC_Face_d/2,0]) cylinder(d=GGC_Band_w*0.7,h=GGC_Band_t);
			} // hull
			
			rotate([0,0,15]) translate([0,-GGC_Face_d/2,0]) cylinder(d1=GGC_FaceSocket_d+8,d2=GGC_FaceSocket_d+6,h=10,$fn=12);
		} // union
		
		
		translate([0,-GGC_Face_d/2*cos(15),-Overlap]) PuzzleConnector(Thickness=GGC_Band_t+Overlap*2);
		rotate([0,0,15]) translate([0,-GGC_Face_d/2+TwelfthInset,-Overlap]) rotate([0,0,-90])PuzzleConnector(Thickness=GGC_Band_t+Overlap*2);
		
		rotate([0,0,15]) translate([0,-GGC_Face_d/2,-Overlap]) Socket_12(Base_d=GGC_FaceSocket_d,Height=10+Overlap*2);
		
		rotate([0,0,15]) translate([0,-GGC_Face_d/2,GGC_Band_t]){
			rotate([0,0,-15]) translate([-30,0,0]) Bolt6ClearHole();
			rotate([0,0,15]) translate([30,0,0]) Bolt6ClearHole();
		}
	} // diff
	
	rotate([0,0,30]) translate([0,-GGC_Face_d/2*cos(15),-Overlap]) PuzzleConnector(Thickness=GGC_Band_t+Overlap*2);
} // Twelfth

//for (j=[0:11])
//rotate([0,0,30*j]) Twelfth();


module ShowBackingPlate(){
	Hub12();
	
	for (j=[0:11])
		rotate([0,0,30*j+15]) translate([0,-GGC_Face_d/2+TwelfthInset,0]) color("Blue") TwelfthConnector();

	for (j=[0:11]) rotate([0,0,30*j]) Twelfth();
} // ShowBackingPlate

//ShowBackingPlate();





























