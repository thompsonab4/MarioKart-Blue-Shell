/*Alexandra Thompson
athompson77@gatech.edu
CS 1301-Section B01
I worked on the assignment alone using only this semester's course materials.*/

/*This is a winged blue shell from the Mario Kart series (with a flat base and a hollow inside for ease in 3d printing).
*/

module star(){	//uses polygon points to make 5-pointed star
	translate ([0,0,300])
	rotate([0,90,0])
	scale([8,8,8])
	linear_extrude(height=1){
	polygon([[6.5,0],[9,5],[14,5.5],[10.5,9],[12,14],[6.5,11.5],[2,14],[3.5,9],[0,5.5],[5,5]]);
	}
}

module halo(number){ //uses iterations and conditional
for (x=[0:number], h=[0:100:number*100]){
	if (x/2 != 0){	//every other star
		rotate([h,0,0])
		star();
	}
	else{	//switches axes
		rotate([-h,90,0])
		star();
	}
}//end of iteration
}//end of module

//comment out the halo() module to remove the stars

halo(6); //function/module call

holeradius = 13; //variable for leg/neckhole size/radius

module neckHole(){
	translate([65,0,-25])
	rotate([0,100,0])
	cylinder(r=holeradius+3,h=25);
}

module neckRim(){	//little collar around neck hole
	rotate_extrude(){
		translate([holeradius+3,0,0])
		circle(r=5);
	}
}

module legHole(){
	translate([40,0,-30])
	rotate([90,0,0])
	cylinder(r=holeradius,h=160,center=true);
}

module insideHollow(){	//subtract this from top/bottom halves to make smooth inside hollow walls
	difference(){
	scale([1.13,1,1])
	sphere(r=70); //ovalloid
	translate([0,0,-60])
	cube([120,110,20],center=true); //flat base
	}
}

module spike(){	//self explanatory
	color("white")
	cylinder(h=37,r1=20,r2=0);
}


module shellLip(){	//takes a torus, elongates, cuts in half
	rotate([0,10,0])
	translate([0,0,-15])
	difference(){
		scale([1.13,1,1])
		rotate_extrude(){
			translate([80,0,0])
			circle(r=18);
		}
		translate([0,-115,-20])
		cube([130,240,40]);
	}
}

module wingbase(){ //half elongated torus, bottom rounded part of wing
color("white")
difference(){
	translate([0,100,0])
	rotate([90,0,0])
	rotate_extrude()
		translate([40,0,0])
		circle(r=10);
	translate([5,87,-50])
	cube([45,25,100]);
	}
}

module wingtip(){	//straighter top part of wing
color("white")
hull(){
	union(){
		rotate([0,14,0])//add ellipse to make rounded tip
		translate([-44,80,-29])
		scale([1.8,.8,.9])
		sphere(r=10);
		scale([1.4,.8,1])
		difference(){
			wingbase();
			translate([-50,85,-20])
			cube([60,30,70]);
		}
	}
}}

module winglayer(){
union(){ //put wingbase and tip together to make single unit
	translate([-75,-15,20])
	rotate([0,30,12])
	translate([0,-5,131])
	wingtip();
	translate([-60,-5,50])
	rotate([-10,210,5])
	scale([1.6,.8,1])
	wingbase();}
}

module wing(){ //wing is made of stacking many layers/units
union(){	//translate and rotate values found by trial/error
	winglayer(); //baselayer
translate([-15,20,20]) //2nd layer
rotate([0,-7,0])
scale([.75,.75,.75])
	winglayer();
translate([-14,18,34]) //3rd layer
rotate([-5,-16,0])
scale([.75,.75,.6])
	winglayer();
translate([-6,25,39]) //4th layer
rotate([-10,-35,0])
scale([.65,.6,.6])
	winglayer();
translate([-44,20,78]) //5th layer
rotate([0,-15,0])
scale([.9,.7,.7])
	wingtip();
translate([-50,-3,70.5]) //6th layer
rotate([0,-25,-3])
scale([1,1,1])
	wingtip();
}}

module wholeshell(){	//actual implementing of shell parts together

union(){ //unite everything

//top shell hemisphere

wing();//under wing layer
mirror([0,1,0])
wing();

//color("white") //top wing layer
rotate([0,-5,0])
scale([.65,.65,.7])
translate([-12,55,30])
wing();
mirror([0,1,0])//mirrored top wing layer
color("white")
rotate([0,-5,0])
scale([.65,.65,.7])
translate([-12,55,30])
wing();

rotate([0,105,0])//add neck cuff to hole
translate([5,0,88])
color("khaki")
	neckRim();

difference(){ //topshell AKA blue part
	difference(){
		scale([1.13,1,1])
		color("blue")
			sphere(r=85, $fn=100);
		translate([0,0,-60])
		color("blue")
			cube([200,200,100],center=true);
	}
	insideHollow();
}

translate([0,0,80])//center spike
spike();
translate([70,0,55])//front spike
rotate([0,43,0])
spike();
mirror()//back spike
translate([72,0,50])
rotate([0,45,0])
spike();
translate([38,55,50])//right spike
rotate([5,49,72])
spike();
mirror([0,1,0])//left spike
translate([38,55,50])
rotate([5,49,72])
spike();

color("white")//shellrim (white part) - connects top half and bottom half
difference(){
	hull(){	//takes the torus, mirrors, then hull to connect smoothly
		shellLip();
		mirror([1,0,0])
		shellLip();
	}
	insideHollow();	//because hull connects center as well, have to remove hole from center to keep shell hollow
}

//underbelly hemisphere AKA khaki part
difference(){
	difference(){
		difference(){
		scale([1.13,1,1]) //ovalloid shape
		color ("khaki")
			sphere(r=80, $fn=100);
		translate([0,0,-70]) //flat base
		color("khaki")
			cube([150,150,20],center=true);
		}
	translate([0,0,35])
		color("khaki")
		cube([190,170,100],center=true);
	}
insideHollow();	//make inside of hemisphere hollow
neckHole();	//subtract neckhole and both legholes
legHole();
mirror([1,0,0])
legHole();
}

}//end of union
}//end of module

wholeshell();