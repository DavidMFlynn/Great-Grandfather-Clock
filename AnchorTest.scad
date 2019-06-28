
Overlap=0.05;
$fn=90;
IDXtra=0.2;

kPin_BC=150;
kPin_BC_r=kPin_BC/2;
nPins=30;
//nPins=15;
Pin_d=3/32*25.4;
Pin_h=1;
Axil_h=1;

kPinAntiRotation=0.25; //0.25; // make the pallets miss the pins
//ActivePin=1; // number of pins CW from 9 O'clock
ActivePin=2+kPinAntiRotation; // number of pins CW from 9 O'clock

cylinder(d=Pin_d,h=Axil_h); // center of escapment wheel
//rotate([0,0,-360/nPins*(kPinAntiRotation-0.06)]) // touching 10 O'clock pallet
rotate([0,0,-360/nPins*(kPinAntiRotation+0.50-0.07)]) // touching 2 O'clock pallet+0.44
{
	translate([0,0,-1-Overlap*2])
		difference(){
			cylinder(d=kPin_BC+Pin_d*3,h=1);
			translate([0,0,-Overlap]) cylinder(d=kPin_BC-Pin_d*3,h=1+Overlap*2);
		}
		
	// pins
	for (j=[0:nPins]) rotate([0,0,360/nPins*j])
		translate([kPin_BC/2,0,0]) color("Red") cylinder(d=Pin_d,h=Pin_h);
}

ActivePin_a=360/nPins*ActivePin;

kAnchor_r=tan(90-ActivePin_a)*kPin_BC_r;

kAnchorCenter_Y=sqrt(kAnchor_r*kAnchor_r + kPin_BC_r*kPin_BC_r); // kPin_BC*0.85;
// Pallet rides on the 3rd pin CW from 9 O'clock and CCW from 3 O'clock
//kAnchor_r=sin(90-ActivePin_a)*kAnchorCenter_Y;
translate([0,kAnchorCenter_Y,0]) cylinder(d=Pin_d,h=1);

rotate([0,0,180-ActivePin_a]) translate([kPin_BC/2,0,0]) translate([0,-kAnchor_r,0]) cylinder(d=Pin_d,h=5);

// geometry
color("Blue")
hull(){
	cylinder(d=1,h=0.01);
	rotate([0,0,180-ActivePin_a]) translate([kPin_BC,0,0]) cylinder(d=1,h=0.01);
} // hull

color("Blue")
hull(){
	rotate([0,0,180-ActivePin_a]) translate([kPin_BC/2,0,0]) cylinder(d=1,h=0.01);
	rotate([0,0,180-ActivePin_a]) translate([kPin_BC/2,0,0]) translate([0,-kPin_BC*1.4,0]) cylinder(d=1,h=0.01);
} // hull

Pallet_a=25;
PalletWidth=(kPin_BC*PI/nPins-Pin_d)/3;
PalletEnd=kPin_BC/6;
PalletThickness=1;

//pallet at 10:30
difference(){
	translate([0,kAnchorCenter_Y,0]) cylinder(r=kAnchor_r-Overlap,h=PalletThickness);
	
	translate([0,kAnchorCenter_Y,-Overlap]) cylinder(r=kAnchor_r-PalletWidth,h=PalletThickness+Overlap*2);
	rotate([0,0,180-ActivePin_a]) translate([kPin_BC_r,0,-Overlap]) 
		rotate([0,0,-180-Pallet_a]) cube([PalletEnd,PalletEnd,PalletThickness+Overlap*2]);
	
	translate([-kAnchor_r,kAnchorCenter_Y,-Overlap]) cube([kAnchor_r*2,kAnchor_r,PalletThickness+Overlap*2]);
	translate([0,kAnchorCenter_Y,0]) rotate([0,0,90-ActivePin_a-10])
		translate([-kAnchor_r,0,-Overlap]) cube([kAnchor_r*2,kAnchor_r,PalletThickness+Overlap*2]);
	translate([0,kAnchorCenter_Y,0]) rotate([0,0,-90-ActivePin_a+5])
		translate([-kAnchor_r,0,-Overlap]) cube([kAnchor_r*2,kAnchor_r,PalletThickness+Overlap*2]);
} // diff

//pallet at 1:30
difference(){
	translate([0,kAnchorCenter_Y,0]) cylinder(r=kAnchor_r+PalletWidth,h=PalletThickness);
	
	translate([0,kAnchorCenter_Y,-Overlap]) cylinder(r=kAnchor_r+Overlap,h=PalletThickness+Overlap*2);
	rotate([0,0,ActivePin_a]) translate([kPin_BC_r,0,-Overlap]) 
		rotate([0,0,180-Pallet_a]) cube([PalletEnd,PalletEnd,PalletThickness+Overlap*2]);
	
	translate([-kAnchor_r-5,kAnchorCenter_Y,-Overlap]) cube([kAnchor_r*2+10,kAnchor_r,PalletThickness+Overlap*2]);
	translate([0,kAnchorCenter_Y,0]) rotate([0,0,-90+ActivePin_a+10])
		translate([-kAnchor_r-PalletWidth,0,-Overlap]) cube([kAnchor_r*2+PalletWidth*2,kAnchor_r+10,PalletThickness+Overlap*2]);
	translate([0,kAnchorCenter_Y,0]) rotate([0,0,90+ActivePin_a-5])
		translate([-kAnchor_r-PalletWidth,0,-Overlap]) cube([kAnchor_r*2+PalletWidth*2,kAnchor_r+10,PalletThickness+Overlap*2]);
} // diff





































