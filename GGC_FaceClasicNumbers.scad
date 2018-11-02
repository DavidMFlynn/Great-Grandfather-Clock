// **********************************************************
// Face Numbers 1,2,3..12
// Filename: GGC_FaceClasicNumbers.scad
// Project: Great Grandfather Clock
// Created: 10/29/2018
// Revision: 0.2 11/1/2018
// Units: mm
// *********************************************************
// History:
// 0.2 11/1/2018 First number support.
// 0.1 10/29/2018 First code
// *********************************************************
// for STL output
//FontSocketTop(NumberSize=NumberSize);
//rotate([180,0,0])NumberThree(NumberSize=NumberSize);
// *********************************************************
// Routines
// *********************************************************
// for Viewing
// ShowAllNumbers();
// *********************************************************
include<GGC_Basic.scad>


NumberSize=100;


module FontSocketTop(NumberSize=80){
	
	difference(){
		translate([0,NumberSize/2.4,-6]) cylinder(d=8,h=6);
		
		translate([0,NumberSize/2.4,-5]) cylinder(d1=5,d2=6,h=5+Overlap);
		
	} // diff
	
	
	
	difference(){
		translate([0,-NumberSize/2.4,-6]) cylinder(d=8,h=6);
		
		translate([0,-NumberSize/2.4,-5]) cylinder(d1=5,d2=6,h=5+Overlap);
		
	} // diff
	
	
	translate([0,0,-GGC_NumberStandout]) NumberSupportBase(Len=20);
	
	hull(){
		translate([0,NumberSize/2.4,-6]) cylinder(d=8,h=1);
		translate([0,0,-GGC_NumberStandout]) cylinder(d=12,h=20);
	}
	hull(){
		translate([0,-NumberSize/2.4,-6]) cylinder(d=8,h=1);
		translate([0,0,-GGC_NumberStandout]) cylinder(d=12,h=20);
	}
} // FontSocketTop

//FontSocketTop(NumberSize=NumberSize);
//NumberThree(NumberSize=NumberSize);


module FontPins(NumberSize=80){
	
	translate([0,NumberSize/2.4,-5]) cylinder(d1=5,d2=6,h=5+Overlap);
	translate([0,-NumberSize/2.4,-5]) cylinder(d1=5,d2=6,h=5+Overlap);
	
} // FontPins

//FontPins(NumberSize=NumberSize);

module NumberOne(NumberSize=80){
	linear_extrude(6)
	text(text="1",size=NumberSize,halign="center",valign="center",font="Arial Black:style=Regular");
	FontPins(NumberSize=NumberSize);
} // NumberOne


module NumberTwo(NumberSize=80){
	linear_extrude(6)
	text(text="2",size=NumberSize,halign="center",valign="center",font="Arial Black:style=Regular");
	FontPins(NumberSize=NumberSize);
} // NumberTwo


module NumberThree(NumberSize=80){
	linear_extrude(6)
	text(text="3",size=NumberSize,halign="center",valign="center",font="Arial Black:style=Regular");
	FontPins(NumberSize=NumberSize);
} // NumberThree



module ShowAllNumbers(){
	
	rotate([0,0,-30]) translate([0,300,0]) rotate([0,0,30])
		NumberOne(NumberSize=NumberSize);
		
	
	rotate([0,0,-60]) translate([0,300,0]) rotate([0,0,60])
		NumberTwo(NumberSize=NumberSize);
		
		
	rotate([0,0,-90]) translate([0,300,0]) rotate([0,0,90])
		NumberThree(NumberSize=NumberSize);
		
		
} // ShowAllNumbers








