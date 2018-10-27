// **********************************************
// Roller Chain
//  by David Flynn
// Created:8/22/2017
// License: GPLv3
// Revision: 1.0.3 8/27/2017
// Units:millimeters
// **********************************************
// History
// 1.0.3 8/27/2017 80L UserLink_d=15;
// 1.0.2 8/26/2017 Thinner. Pin_w=LinkPin_w+Link_t*2+EndGap*2; 
// 1.0.1 8/23/2017 Sneeking up on a 81L chain
// 1.0.0 8/22/2017 first code
// **********************************************
// for STL output
//
OneLinkSet();

//Roller();
//InnerLink();
//LinkWithRollerPins();
//OuterLink();
//LinkWithPins();
//
// ---------------------------
// for Viewing
//ShowLinks();
// **********************************************
// User inputs
/*
// ANSI size 80 chain
//ANSI_Size=8;
// ANSI size 60 chain
ANSI_Size=6;
Pin_d=ANSI_Size*0.125*0.3*25.4; // .312 is correct
Roller_w=ANSI_Size*0.125*0.625*25.4;
UserRoller_od=ANSI_Size*0.125*0.625*25.4; // 5/8" roller, optional, min is calculated 

Gap=0.38; // 0.24 wiil not assemble
EndGap=0.34;
Link_t=ANSI_Size*0.125*0.125*25.4;
ThinWall=1.2;
UserLink_d=0; // default is Pitch * 0.921
UserPitch=ANSI_Size*0.125*25.4; // 1" pitch, optional, min is calculated 
PinWeld_Xtra=0.8;
PinEndInset_d=0.4;
/**/


// Custom 80L optomized for PETG
ANSI_Size=0;
Pin_d=3.8;
Roller_w=6;
UserRoller_od=11; //11mm optional, min is calculated 

Gap=0.44;
EndGap=0.34;
Link_t=1.2; // 4 layers
ThinWall=1.2;
UserLink_d=15; // default is Pitch * 0.921"
UserPitch=25.4; // 1" pitch, optional, min is calculated 
PinWeld_Xtra=0.8;
PinEndInset_d=0.4;
/**/
//----------------------------
// Constants
Overlap=0.05;
IDXtra=0.2;
$fn=90;

// Calculated dimensions
Pin_id=Pin_d-ThinWall*2;
LinkPin_id=Pin_d+Gap*2+IDXtra;
LinkPin_d=LinkPin_id+ThinWall*2;
Roller_id=LinkPin_d+Gap*2+IDXtra;
Roller_d=ANSI_Size>0 ? UserRoller_od : max(Roller_id+ThinWall*2,UserRoller_od);
Pitch=UserPitch == 0 ? Roller_d*2 : UserPitch;
Link_d=UserLink_d == 0 ? Pitch*0.921 : UserLink_d;
OuterLink_d=Link_d-ThinWall*2;
LinkPin_w=Roller_w+EndGap*2;
Pin_w=LinkPin_w+Link_t*2+EndGap*2; 

echo(Pitch=Pitch);
echo(Link_d=Link_d);
echo(UserRoller_od=UserRoller_od);
echo(Roller_d=Roller_d);
echo(Roller_id=Roller_id);
echo(LinkPin_d=LinkPin_d);
echo(LinkPin_id=LinkPin_id);
echo(Pin_d=Pin_d);

module OneLinkSet(){
	translate([3,0,0]) Roller();
	translate([Roller_d+6,0,0])Roller();
	translate([0,Link_d,0]) InnerLink();
	translate([0,-Link_d,0])LinkWithRollerPins();
	translate([0,OuterLink_d+Link_d+3,0])OuterLink();
	translate([0,-OuterLink_d-Link_d-3,0])LinkWithPins();
} // OneLinkSet


module ShowLinks(){
	for (j=[0:4])translate([j*Pitch*2,0,0]){
		translate([0,0,Link_t*2+Gap*2]) color("LightBlue")Roller();
		translate([Pitch,0,Link_t*2+Gap*2]) color("LightBlue")Roller();
		translate([0,0,Link_t+Gap]) color("Tan")LinkWithRollerPins();
		translate([0,0,Link_t*2+Gap+LinkPin_w]) color("Tan")InnerLink();
		
		translate([Pitch,0,0]) LinkWithPins();
		translate([Pitch,0,Pin_w+Link_t]) OuterLink();
	} 

} // ShowLinks

//ShowLinks();

module Roller(){
	difference(){
		cylinder(d=Roller_d,h=Roller_w);
		translate([0,0,-Overlap])cylinder(d=Roller_id,h=Roller_w+Overlap*2);
	} // diff
} // Roller

//Roller();

module InnerLink(){
	difference(){
		LinkShape(Pitch=Pitch,Link_d=Link_d,Link_t=Link_t);
		
		translate([0,0,-Overlap])cylinder(d=LinkPin_d-PinEndInset_d+IDXtra,h=Link_t+Overlap*2);
		translate([Pitch,0,-Overlap])cylinder(d=LinkPin_d-PinEndInset_d+IDXtra,h=Link_t+Overlap*2);

	} // diff
} // InnerLink

//InnerLink();

module LinkWithRollerPins(){
	difference(){
		union(){
			LinkShape(Pitch=Pitch,Link_d=Link_d,Link_t=Link_t);
			
			cylinder(d=LinkPin_d,h=Link_t+LinkPin_w);
			translate([Pitch,0,0])cylinder(d=LinkPin_d,h=Link_t+LinkPin_w);
			
			cylinder(d=LinkPin_d-PinEndInset_d,h=Link_t*2+LinkPin_w+PinWeld_Xtra);
			translate([Pitch,0,0])cylinder(d=LinkPin_d-PinEndInset_d,h=Link_t*2+LinkPin_w+PinWeld_Xtra);
		} // union
		
		translate([0,0,-Overlap])cylinder(d=LinkPin_id,h=Link_t*2+LinkPin_w+PinWeld_Xtra+Overlap*2);
		translate([Pitch,0,-Overlap])cylinder(d=LinkPin_id,h=Link_t*2+LinkPin_w+PinWeld_Xtra+Overlap*2);
		
	} // diff
} // LinkWithRollerPins

//LinkWithRollerPins();

module OuterLink(){
	difference(){
		LinkShape(Pitch=Pitch,Link_d=OuterLink_d,Link_t=Link_t);
		
		translate([0,0,-Overlap])cylinder(d=Pin_d-PinEndInset_d+IDXtra,h=Link_t+Overlap*2);
		translate([Pitch,0,-Overlap])cylinder(d=Pin_d-PinEndInset_d+IDXtra,h=Link_t+Overlap*2);

	} // diff
} // OuterLink

//OuterLink();

module LinkWithPins(){
	difference(){
		union(){
			LinkShape(Pitch=Pitch,Link_d=OuterLink_d,Link_t=Link_t);
			
			cylinder(d=Pin_d,h=Link_t+Pin_w);
			translate([Pitch,0,0])cylinder(d=Pin_d,h=Link_t+Pin_w);
			
			cylinder(d=Pin_d-PinEndInset_d,h=Link_t*2+Pin_w+PinWeld_Xtra);
			translate([Pitch,0,0])cylinder(d=Pin_d-PinEndInset_d,h=Link_t*2+Pin_w+PinWeld_Xtra);
		} // union
		
		translate([0,0,-Overlap])cylinder(d=Pin_id,h=Link_t*2+Pin_w);
		translate([Pitch,0,-Overlap])cylinder(d=Pin_id,h=Link_t*2+Pin_w);

		translate([0,0,-Overlap])cylinder(d=Pin_id-PinEndInset_d,h=Link_t*2+Pin_w+PinWeld_Xtra+Overlap*2);
		translate([Pitch,0,-Overlap])cylinder(d=Pin_id-PinEndInset_d,h=Link_t*2+Pin_w+PinWeld_Xtra+Overlap*2);
		
	} // diff
} // LinkWithPins

//LinkWithPins();



module LinkShape(Pitch=Pitch,Link_d=Link_d,Link_t=Link_t){
	difference(){
		union(){
			cylinder(d=Link_d,h=Link_t);
			translate([Pitch,0,0])cylinder(d=Link_d,h=Link_t);
			translate([Link_d/4,-sqrt(3)*Link_d/4,0])
				cube([Pitch-Link_d/2,sqrt(3)*Link_d/2,Link_t]);
		} // union
		rotate([0,0,-30])translate([0,Pitch,-Overlap])cylinder(r=Pitch-Link_d/2,h=Link_t+Overlap*2);
		rotate([0,0,180+30])translate([0,Pitch,-Overlap])cylinder(r=Pitch-Link_d/2,h=Link_t+Overlap*2);
	} // diff
} // LinkShape

//LinkShape();
