// *****************************************
// Great Grandfather Clock, Weight and Pulleys
// Created: 6/30/2019
// Revision: 0.9.2 7/5/2019
// units: mm
// *****************************************
//  ***** History *****
// 0.9.2 7/5/2019 Added decoration and kThd_Xtra
// 0.9.1 7/3/2019 Added bolt hole in top of weight.
// 0.9 6/30/2019 First code
// *****************************************
//  ***** for STL output *****
// BlockPulley(myFn=360); // Print 6
// Block(nPulleys=3);
//
// rotate([180,0,0]) WeightTop(Fast=false);
// rotate([180,0,0]) WeightBottom(Fast=false);
// *****************************************
//  ***** for Viewing *****
// ShowBlock();
// *****************************************

include<Nut_Job.scad>
include<BearingLib.scad>

$fn=90;
//$fn=24;
Overlap=0.05;
IDXtra=0.2;

kThd_d=80;
kThd_p=5;
kThd_h=30;
kThd_Xtra=IDXtra*2;

PulleyBearing_ID=6.35;
PulleyBearing_OD=12.7;
PulleyBearing_h=4.5;

nSlots=11; // decoration

module ShowBlock(nPulleys=3){
	Block(nPulleys=nPulleys);
	
	for (j=[0:nPulleys-1]) translate([0,-(nPulleys*5.2)/2+5.2*j,0])
		rotate([-90,0,0]) BlockPulley(myFn=90);
} // ShowBlock

module Block(nPulleys=3){
	Block_h=35;
	
	difference(){
		union(){
			translate([0,((PulleyBearing_h+1)*nPulleys)/2,0])
			hull(){
				rotate([-90,0,0]) cylinder(d=20,h=5);
				
				translate([-10,0,-Block_h]) cube([20,5,5]);
			} // hull
			
			translate([0,-((PulleyBearing_h+1)*nPulleys)/2-5,0])
			hull(){
				rotate([-90,0,0]) cylinder(d=20,h=5);
				
				translate([-10,0,-Block_h]) cube([20,5,5]);
			} // hull
			
			translate([-10,-(nPulleys*5.2)/2-5,-Block_h]) cube([20,nPulleys*5.2+10,5]);
			
		} // union
		
		translate([0,-((PulleyBearing_h+1)*nPulleys)/2-5-Overlap,0]){
			rotate([90,0,0]) Bolt6ClearHole();
			 rotate([-90,0,0]) translate([0,0,6]) cylinder(d=6.35,h=nPulleys*5.2+10+Overlap*2);
		}
		
		translate([0,0,-Block_h-Overlap]) cylinder(d=6.4,h=5+Overlap*2);
	} // diff
} // Block

//Block(nPulleys=3);

module BlockPulley(myFn=90){
	nHoles=7;
	
	difference(){
		OnePieceInnerRace(BallCircle_d=50,	Race_ID=PulleyBearing_OD,
			Ball_d=3, Race_w=PulleyBearing_h, PreLoadAdj=0.00, VOffset=0.00, BI=false, myFn=myFn);
		
		for (j=[0:nHoles-1]) rotate([0,0,350/nHoles*j])
			translate([15,0,-Overlap]) cylinder(d=10,h=PulleyBearing_h+Overlap*2);
	} // diff
} // BlockPulley

//BlockPulley();

Weight_OD=kThd_d+8;

module WeightBottom(Fast=true){
	
	difference(){
		if (Fast==true){
			cylinder(d=kThd_d+10,h=kThd_h);
		} else {
			Nut_Job(type="nut",
				nut_thread_outer_diameter = kThd_d+kThd_Xtra,
				nut_thread_step = kThd_p,
				nut_diameter  = kThd_d+10,
				nut_height	  = kThd_h,
				resolution    = 0.5);
		}
		
		translate([0,0,-Overlap]) cylinder(d=kThd_d-kThd_p*1.4+3.5,h=kThd_h+Overlap*2);
		
		difference(){
			translate([0,0,-Overlap]) cylinder(d=kThd_d+30,h=kThd_h+Overlap*2);
			translate([0,0,-Overlap*2]) cylinder(d=Weight_OD,h=kThd_h+Overlap*4);
		} // diff
	} // diff
	
	difference(){
		hull(){
			translate([0,0,-100]) sphere(d=30);
			translate([0,0,-70]) cylinder(d=Weight_OD,h=70+Overlap);
		} // hull
		
		hull(){
			translate([0,0,-100]) sphere(d=20);
			translate([0,0,-70]) cylinder(d=kThd_d,h=70+Overlap*2);
		} // hull
		
		// decoration
		for (j=[0:nSlots-1]) rotate([0,0,360/nSlots*j])hull(){
			translate([Weight_OD/2+4,0,-50]) sphere(d=14);
			translate([Weight_OD/2+4,0,-50+40]) sphere(d=14);
		} // hull
		
	} // diff
	
} // WeightBottom

//WeightBottom(Fast=true);



module WeightTop(Fast=true){
	
	difference(){
		
		if (Fast==true){
				cylinder(d=kThd_d,h=kThd_h);
			} else {
				Nut_Job(type="bolt",
					thread_outer_diameter = kThd_d-kThd_Xtra,
					thread_step = kThd_p,
					thread_length= kThd_h,
					head_diameter  = 0,
					head_height	  = 0);
			}
		
		// Trim thread
		difference(){
			translate([0,0,-Overlap]) cylinder(d=kThd_d+2,h=kThd_h+Overlap*2);
			translate([0,0,-Overlap*2]) cylinder(d=kThd_d-1.5,h=kThd_h+Overlap*4,$fn=360);
		} // diff
		
		// center hole
		translate([0,0,-Overlap]) cylinder(d=kThd_d-kThd_p*2,h=kThd_h+Overlap*2);
	} // diff

	difference(){
		translate([0,0,kThd_h-1]) cylinder(d=Weight_OD,h=100);
		
		translate([0,0,kThd_h-1-Overlap]) cylinder(d=kThd_d-kThd_p*2,h=94);
		
		translate([0,0,kThd_h-1+100]) Bolt250Hole();
		
		// decoration
		for (j=[0:nSlots-1]) rotate([0,0,360/nSlots*j])hull(){
			translate([Weight_OD/2+4,0,50]) sphere(d=14);
			translate([Weight_OD/2+4,0,50+60]) sphere(d=14);
		} // hull
	} // diff

} // WeightTop

//WeightTop(Fast=false);
// WeightTop(Fast=true);
















































