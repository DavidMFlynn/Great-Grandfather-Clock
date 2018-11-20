// **********************************************************
// Face Numbers 1,2,3..12
// Filename: GGC_FaceClasicNumbers.scad
// Project: Great Grandfather Clock
// Created: 10/29/2018
// Revision: 0.9 11/5/2018
// Units: mm
// *********************************************************
// History:
// 0.9 11/5/2018 FC1, all numbers are ready to print.
// 0.3 11/2/2018 Parametric pins and support.
// 0.2 11/1/2018 First number support.
// 0.1 10/29/2018 First code
// *********************************************************
// for STL output
//rotate([180,0,0]) StandardNumber(Text="1",NumberSize=GGC_NumberSize);
//rotate([180,0,0]) StandardNumber(Text="2",NumberSize=GGC_NumberSize);
//rotate([180,0,0]) StandardNumber(Text="3",NumberSize=GGC_NumberSize);
//rotate([180,0,0]) StandardNumber(Text="5",NumberSize=GGC_NumberSize);
//rotate([180,0,0]) StandardNumber(Text="6",NumberSize=GGC_NumberSize);
//rotate([180,0,0]) StandardNumber(Text="7",NumberSize=GGC_NumberSize);
//rotate([180,0,0]) StandardNumber(Text="8",NumberSize=GGC_NumberSize);
//rotate([180,0,0]) StandardNumber(Text="9",NumberSize=GGC_NumberSize);
//FontSocketTopP(TwoStdPins(GGC_NumberSize)); // print 8

//rotate([180,0,0]) NumberFour(NumberSize=GGC_NumberSize);
//FontSocketTopP(FourPins(GGC_NumberSize));

//rotate([180,0,0]) NumberTen(NumberSize=GGC_NumberSize);
//FontSocketTopP(TenPins(GGC_NumberSize));
		
//rotate([180,0,0]) NumberEleven(NumberSize=GGC_NumberSize);
//FontSocketTopP(ElevenPins(GGC_NumberSize));

//rotate([180,0,0]) NumberTwelve(NumberSize=GGC_NumberSize);
//FontSocketTopP(TwelvePins(GGC_NumberSize));

// *********************************************************
// Routines
// *********************************************************
// for Viewing
// ShowAllNumbers();
// *********************************************************
include<GGC_Basic.scad>

module FontPinsP(PinList=[[0,GGC_NumberSize/2.4,0],[0,-GGC_NumberSize/2.4,0]]){
	translate([0,0,-5]) for (j=PinList)
		translate(j) cylinder(d1=5,d2=6,h=5+Overlap);	
} // FontPinsP

module FontSocketTopP(PinList=[[0,GGC_NumberSize/2.4,0],[0,-GGC_NumberSize/2.4,0]]){
	
	for (j=PinList){
		difference(){
			translate([0,0,-6]) translate(j) cylinder(d=8,h=6);
			translate([0,0,-5]) translate(j) cylinder(d1=5,d2=6,h=5+Overlap);
		} // diff
		hull(){
			translate([0,0,-6]) translate(j) cylinder(d=8,h=1);
			translate([0,0,-GGC_NumberStandout]) cylinder(d=12,h=20);
		} // hull
	} // for
	
	translate([0,0,-GGC_NumberStandout]) NumberSupportBase(Len=20);
	
} // FontSocketTopP

function TwoStdPins(NumberSize ) = [[0,GGC_NumberSize/2.4,0],[0,-GGC_NumberSize/2.4,0]];

function FourPins ( NumberSize ) = [[NumberSize/5,NumberSize/2.4,0],[NumberSize/5,-NumberSize/2.4,0],[-NumberSize/3,-NumberSize/5,0]] ;

function TenPins(NumberSize ) = [[-30,NumberSize/2.4,0],[-30,-NumberSize/2.4,0],[35,NumberSize/2.4,0],[35,-NumberSize/2.4,0]];

function ElevenPins(NumberSize ) = [[-30,NumberSize/2.4,0],[-30,-NumberSize/2.4,0],[45,NumberSize/2.4,0],[45,-NumberSize/2.4,0]];

function TwelvePins(NumberSize ) = [[-30,NumberSize/2.4,0],[-30,-NumberSize/2.4,0],[35,NumberSize/2.4,0],[35,-NumberSize/2.4,0]];


module NumberFour(NumberSize=GGC_NumberSize){
	linear_extrude(6)
	text(text="4",size=NumberSize,halign="center",valign="center",font="Arial Black:style=Regular");
	FontPinsP(FourPins(NumberSize));
} // NumberFour

//NumberFour(NumberSize=NumberSize);
//FontSocketTopP(FourPins(NumberSize));

module StandardNumber(Text="1",NumberSize=GGC_NumberSize){
	linear_extrude(6)
	text(text=Text,size=NumberSize,halign="center",valign="center",font="Arial Black:style=Regular");
	FontPinsP(TwoStdPins(NumberSize));
} // StandardNumber


module NumberTen(NumberSize=GGC_NumberSize){
	linear_extrude(6){
		translate([-NumberSize/2.6,0])
			text(text="1",size=NumberSize,halign="center",valign="center",font="Arial Black:style=Regular");
		translate([NumberSize/2.6,0])
			text(text="0",size=NumberSize,halign="center",valign="center",font="Arial Black:style=Regular");}
	FontPinsP(TenPins(NumberSize));
} // NumberTen

//NumberTen(NumberSize=NumberSize);

module NumberEleven(NumberSize=GGC_NumberSize){
	linear_extrude(6){
		translate([-NumberSize/2.7,0])
			text(text="1",size=NumberSize,halign="center",valign="center",font="Arial Black:style=Regular");
		translate([NumberSize/2.7,0])
			text(text="1",size=NumberSize,halign="center",valign="center",font="Arial Black:style=Regular");}
	FontPinsP(ElevenPins(NumberSize));
} // NumberEleven

//NumberEleven(NumberSize=NumberSize);

module NumberTwelve(NumberSize=GGC_NumberSize){
	linear_extrude(6){
		translate([-NumberSize/2.6,0])
			text(text="1",size=NumberSize,halign="center",valign="center",font="Arial Black:style=Regular");
		translate([NumberSize/2.6,0])
			text(text="2",size=NumberSize,halign="center",valign="center",font="Arial Black:style=Regular");}
	FontPinsP(TwelvePins(NumberSize));
} // NumberTwelve

//NumberTwelve(NumberSize=NumberSize);

module ShowAllNumbers(){
	
	rotate([0,0,-30]) translate([0,300,0]) rotate([0,0,30]){
		StandardNumber(Text="1");
		FontSocketTopP(TwoStdPins(GGC_NumberSize));}
		
	
	rotate([0,0,-60]) translate([0,300,0]) rotate([0,0,60]){
		StandardNumber(Text="2");
		FontSocketTopP(TwoStdPins(GGC_NumberSize));}
		
		
	rotate([0,0,-90]) translate([0,300,0]) rotate([0,0,90]){
		StandardNumber(Text="3");
		FontSocketTopP(TwoStdPins(GGC_NumberSize));}
		
	rotate([0,0,-120]) translate([0,300,0]) rotate([0,0,120]){
		NumberFour();
		FontSocketTopP(FourPins(GGC_NumberSize));}

	rotate([0,0,-150]) translate([0,300,0]) rotate([0,0,150]){
		StandardNumber(Text="5");
		FontSocketTopP(TwoStdPins(GGC_NumberSize));}

	rotate([0,0,-180]) translate([0,300,0]) rotate([0,0,180]){
		StandardNumber(Text="6");
		FontSocketTopP(TwoStdPins(GGC_NumberSize));}

	rotate([0,0,-210]) translate([0,300,0]) rotate([0,0,210]){
		StandardNumber(Text="7");
		FontSocketTopP(TwoStdPins(GGC_NumberSize));}

	rotate([0,0,-240]) translate([0,300,0]) rotate([0,0,240]){
		StandardNumber(Text="8");
		FontSocketTopP(TwoStdPins(GGC_NumberSize));}

	rotate([0,0,-270]) translate([0,300,0]) rotate([0,0,270]){
		StandardNumber(Text="9");
		FontSocketTopP(TwoStdPins(GGC_NumberSize));}

	rotate([0,0,-300]) translate([0,300,0]) rotate([0,0,300]){
		NumberTen();
		FontSocketTopP(TenPins(GGC_NumberSize));}
		
	rotate([0,0,-330]) translate([0,300,0]) rotate([0,0,330]){
		NumberEleven();
		FontSocketTopP(ElevenPins(GGC_NumberSize));}

	rotate([0,0,0]) translate([0,300,0]) rotate([0,0,0]){
		NumberTwelve();
		FontSocketTopP(TwelvePins(GGC_NumberSize));}
		
} // ShowAllNumbers

//ShowAllNumbers();






