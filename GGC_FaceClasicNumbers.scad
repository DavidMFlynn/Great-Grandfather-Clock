// **********************************************************
// Face Numbers 1,2,3..12
// Filename: GGC_FaceClasicNumbers.scad
// Project: Great Grandfather Clock
// Created: 10/29/2018
// Revision: 0.1 10/29/2018
// Units: mm
// *********************************************************
// History:
// 0.1 10/29/2018 First code
// *********************************************************
// for STL output
// *********************************************************
// Routines
// *********************************************************
// for Viewing
// *********************************************************

include<CommonStuffSAEmm.scad>

$fn=90;
Overlap=0.05;
IDXtra=0.2;

NumberSize=100;

module FontSocketTop(NumberSize=80){
	
	difference(){
		
	translate([0,NumberSize/2.4,-5]) cylinder(d1=5,d2=6,h=5+Overlap);
		
	} // diff
	
	
} // FontSocketTop

module FontPins(NumberSize=80){
	
	translate([0,NumberSize/2.4,-5]) cylinder(d1=5,d2=6,h=5+Overlap);
	translate([0,-NumberSize/2.4,-5]) cylinder(d1=5,d2=6,h=5+Overlap);
	
} // FontPins

//FontPins(NumberSize=NumberSize);

module NumberOne(NumberSize=80){
	linear_extrude(6)
	text(text="1",size=NumberSize,halign="center",valign="center",font="Arial Black:style=Regular");
} // NumberOne

rotate([0,0,-30]) translate([0,300,0]) rotate([0,0,30]){
	NumberOne(NumberSize=NumberSize);
	FontPins(NumberSize=NumberSize);
}

module NumberTwo(NumberSize=80){
	linear_extrude(6)
	text(text="2",size=NumberSize,halign="center",valign="center",font="Arial Black:style=Regular");
} // NumberTwo

rotate([0,0,-60]) translate([0,300,0]) rotate([0,0,60]){
	NumberTwo(NumberSize=NumberSize);
	FontPins(NumberSize=NumberSize);
}

module NumberThree(NumberSize=80){
	linear_extrude(6)
	text(text="3",size=NumberSize,halign="center",valign="center",font="Arial Black:style=Regular");
} // NumberThree

rotate([0,0,-90]) translate([0,300,0]) rotate([0,0,90]){
	NumberThree(NumberSize=NumberSize);
	FontPins(NumberSize=NumberSize);
}