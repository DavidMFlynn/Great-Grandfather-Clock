// **********************************************
// Roller Chain Sprocket
//  by David Flynn
// Created:8/22/2017
// License: GPLv3
// Revision: 1.1.1 9/15/2017
// Units:millimeters
// **********************************************
// History
// 1.1.1 9/15/2017 Improved "Strtched Chain" geometry.
// 1.1.0 9/5/2017 Reworked math to match ANSI 60 spocket
// 1.0.2 8/27/2017 Tighter fit.
// 1.0.1 8/26/2017 Still getting stuck
// 1.0.0 8/22/2017 first code
// **********************************************
// for STL output
//
/*
// ANSI size 80 chain
//ANSI_Size=8;
// ANSI size 60 chain
ANSI_Size=6;
Roller_d=ANSI_Size*0.125*0.625*25.4;
Pitch=ANSI_Size*0.125*25.4;
RollerWidth=ANSI_Size*0.125*0.612*25.4;
echo(RollerWidth=RollerWidth/25.4);
echo(Roller_d=Roller_d);
sprocket(teeth=12,roller_d=Roller_d,pitch=Pitch,thickness=RollerWidth/2,
	Hub_diameter=20,Hub_thickness=10,Bore_diameter=12.7,Holes=6,Chamfer=true,Stretch=0.015);
/**/

/*
//DMFE 80L
Roller_d=11;
Pitch=25.4;
RollerWidth=6;


sprocket(teeth=20,roller_d=Roller_d,pitch=Pitch,thickness=RollerWidth/2,
	Hub_diameter=0,Hub_thickness=0,Bore_diameter=140,Holes=0,Chamfer=true,Stretch=0.012);

//sprocket(teeth=9,roller_d=Roller_d,pitch=Pitch,thickness=RollerWidth/2,
	//Hub_diameter=20,Hub_thickness=10,Bore_diameter=12.7,Holes=6,Chamfer=true,Stretch=0.015);
/**/	

//sprocket(teeth=8,roller_d=Roller_d,pitch=25.4,thickness=3,
//	Hub_diameter=20,Hub_thickness=10,Bore_diameter=12.7,Holes=6,Chamfer=true,Stretch=0.015);

//sprocket(teeth=6,roller_d=Roller_d,pitch=25.4,thickness=3,
//	Hub_diameter=20,Hub_thickness=10,Bore_diameter=12.7,Holes=0,Chamfer=true,Stretch=0.015);

// **********************************************

$fn=90;
Overlap=0.05;
IDXtra=0.2;
pi=3.14159;

module sprocket(teeth=20, roller_d=3, pitch=17, thickness=3, 
				Hub_diameter=0, // optional
				Hub_thickness=0, // may be less than thickness
				Bore_diameter=0, // optional
				Holes=0, // optional, lightening holes
				Chamfer=true,
				Stretch=0.000){ // max stretch 0.015 = 1.5%
						
	OA_Thickness=max(thickness,Hub_thickness);
	roller_r=roller_d/2; //We need radius in our calculations, not diameter
	pitch_r=pitch/(2*sin(180/teeth));
	StretchExtra_l=teeth/4*pitch*Stretch;
					
	Sprocket_r=pitch_r+roller_r*0.77;
	echo(Sprocket_r=Sprocket_r/25.4*2);
	//echo(pitch_r=pitch_r);
	ChamferAt=4;  //mm past roller tops
	EngageTooth_r=pitch-roller_r-IDXtra;
	// Variables controlling the lightening holes in the sprocket.
	HolesBC_diameter=Hub_diameter+(pitch_r-roller_d-Hub_diameter/2);
	Holes_curcumference=pi*HolesBC_diameter;

	// Limit the circle size to 90% of the gear face.
	Hole_diameter=min(0.707*Holes_curcumference/Holes,(pitch_r-roller_d-Hub_diameter/2)*0.707);
	
	difference(){
		union(){
			cylinder(r=pitch_r-roller_r*(1-sin(60)),h=thickness);//-StretchExtra_l
			
			//fat hub
			if (Hub_thickness>thickness && Hub_diameter>0) cylinder(d=Hub_diameter,h=Hub_thickness);
			
			// The Teeth
			for(j=[1:teeth])
			//j=1;
				intersection(){
					
					rotate([0,0,360/teeth*j])
						translate([pitch_r-StretchExtra_l/2,0,0])
							cylinder(r=EngageTooth_r-StretchExtra_l/2,h=thickness);
						
					rotate([0,0,360/teeth*(j-1)])
						translate([pitch_r-StretchExtra_l/2,0,0])
							cylinder(r=EngageTooth_r-StretchExtra_l/2,h=thickness); 
				} // intersection
			
		} // union
		
		// Rollers go here
		for(j=[1:teeth])
			rotate([0,0,360/teeth*j])
				translate([pitch_r+StretchExtra_l/2,0,-Overlap])
					cylinder(r=roller_r+StretchExtra_l/2+IDXtra,h=thickness+Overlap*2);
						
		// thin hub
		if (Hub_thickness>0 && Hub_thickness<thickness)
			translate([0,0,Hub_thickness])
				cylinder(d=Hub_diameter,h=thickness);
		
		// center hole
		if (Bore_diameter>0) translate([0,0,-Overlap]) cylinder(d=Bore_diameter,h=OA_Thickness+Overlap*2);
			
		// lightening holes
		if (Holes>0)
			for(j=[0:Holes-1]) rotate([0,0,j*360/Holes])
				translate([HolesBC_diameter/2,0,-Overlap]) cylinder(d=Hole_diameter,h=thickness+Overlap*2);
		
			// truncate teeth	
		difference(){
			translate([0,0,-Overlap])cylinder(r=pitch_r*2,h=thickness+Overlap*2);
			translate([0,0,-Overlap*2])cylinder(r=Sprocket_r,h=thickness+Overlap*4,$fn=360);
		} // diff
		
		// chamfer truncated teeth
		if (Chamfer == true)
			difference(){
				translate([0,0,thickness*0.5])cylinder(r=pitch_r*2,h=thickness*0.5+Overlap*2);
				translate([0,0,thickness*0.5-Overlap])
					cylinder(r1=pitch_r+roller_r+ChamferAt,r2=pitch_r-roller_r,h=thickness*0.5+Overlap*4);
			} // diff
			
	} // diff
} // sprocket









