######################
#
# DD_Navigation.nas
#
######################
#	TWD	: True Wind Direction
#	WS	: Wind Speed
#	TAS	: True Air Speed
#	GS	: Ground Speed
#	DA	: Drift Angle
#	MD 	: Magnetic Declination
#	DEV	: Magnetic deviation

#	TC	: True Course
#	MC	: Magnetic Course
#	CC	: Compass Course

# Strömungseinflüsse 

#	TH	: True Heading
#	MH	: Magnetic Heading
#	CH	: Compass Heading
	

var TODEG = 180/math.pi;
var TORAD = math.pi/180;
var deg = func(rad){ return rad*TODEG; }
var rad = func(deg){ return deg*TORAD; }
var course = func(deg){ return math.mod(deg,360.0);}


var nCopilotMsg = props.globals.getNode("/sim/messages/ground",1);
var fnCopilot = func(msg) { nCopilotMsg.setValue(msg);}


########################
var loader_init = func(){
	setprop("dd/navigation/TC",0.0);
	setprop("dd/navigation/TAS",160.0);
	setprop("dd/navigation/DA",0.0);
	setprop("dd/navigation/TH",0.0);
	setprop("dd/navigation/MH",0.0);
	setprop("dd/navigation/CH",0.0);
	
	setprop("dd/navigation/course","");
	setprop("dd/navigation/ADF_1_MB","");
	setprop("dd/navigation/ADF_2_MB","");
	
	nav_display_object = screen.display.new(15, -25, 1);
	nav_display_object.setfont("FIXED_9x15");
	nav_display_object.setcolor(1, 1, 1);
	
	
	nav_navigator();
	nav_adf_bearing();
	nav_display();
	
}

var loader_unload = func(){
	nav_calc_loop = 0;
	nav_display_status = 0;
	if (nav_display_object != nil){
		nav_display_object.reset();
		nav_display_object = nil;
	}
}
########################


var nav_calc_loop = 0;
var nav_calc_timer = 1;

var nav_navigator = func(){
	nav_calc_loop=!nav_calc_loop;
	if (nav_calc_loop){
		fnCopilot("I calculate the course.");
		nav_calc();
	}else{
		fnCopilot("I'm stopping course calculation.");
	}
}

var nav_calc = func(){
	if (nav_calc_loop){
		calc();
		settimer(nav_calc,nav_calc_timer);
	}else{
		setprop("dd/navigation/DA",0.0);
		setprop("dd/navigation/TH",0.0);
		setprop("dd/navigation/MH",0.0);
		setprop("dd/navigation/CH",0.0);
	}
}


#
#Calculate Ground Speed, Course & Wind Correction Angle
#
var calc = func() {
  var TWD 	= rad(getprop("/environment/wind-from-heading-deg"));
  var WS 	= getprop("environment/wind-speed-kt");
  var TC 	= rad(getprop("/instrumentation/kcs55/ki525/selected-course-deg"));
  #var TC 	= rad(getprop("dd/navigation/TC"));
  #var TAS	= getprop("dd/navigation/TAS");
 var TAS	= getprop("/instrumentation/airspeed-indicator/true-speed-kt");
   var MD 	= rad(getprop("environment/magnetic-variation-deg"));

   
  
  var GS = 0.0;
  var DA = 0.0;
  var TH = 0.0;
  var MH = 0.0;
  var DEV = 0.0;
  
#   print("TC  :"~TC);
#   print("TWD :"~TWD);
  
  
  var x = WS * math.sin((TC-TWD));
  var y = TAS - (WS * math.cos((TC-TWD)));
  
#   print("x:"~ x ~" y:"~y~"");
  
  DA = math.atan2(x,y);
  
  TH = TC - DA;
  
  MH = TH - MD;
  
  CH = MH - DEV;
  
  
  setprop("dd/navigation/DA",deg(DA));
  setprop("dd/navigation/TH",deg(TH));
  setprop("dd/navigation/MH",deg(MH));
  setprop("dd/navigation/CH",deg(CH));
  
  var strCourse = sprintf("TC:%03i CH:%03i TWD:%03i WS:%i",course(deg(TC)),course(deg(CH)),course(deg(TWD)),WS);
  setprop("dd/navigation/course",strCourse);
    
}
############ ADF Bearing to Magnetic Bearing #############
#DD_Tour2013.nav_adf_bearing();
var nav_adf_loop = 0;
var nav_adf_timer = 1;
var nav_adf_bearing =func(){
	nav_adf_loop=!nav_adf_loop;
	if (nav_adf_loop){
		fnCopilot("I calculate ADF bearing.");
		nav_adf_bearing_calc();
	}else{
		fnCopilot("I'm stopping ADF caluculation.");
	}
}
var nav_adf_bearing_calc =func(){
	
	var MH = 0;
	var ADF1_B = 0;
	var ADF2_B = 0;
	
	if (nav_adf_loop){
		MH = getprop("/instrumentation/heading-indicator/indicated-heading-deg") or 0;
		ADF1_B = getprop("/instrumentation/adf[0]/indicated-bearing-deg") or 0;
		ADF2_B = getprop("/instrumentation/adf[1]/indicated-bearing-deg") or 0;
		
		ADF1_MB = MH + ADF1_B;
		ADF2_MB = MH + ADF2_B;
			
		settimer(nav_adf_bearing_calc,nav_adf_timer);
	}
	
	
	
	setprop("dd/navigation/ADF_1_MB", sprintf("%03i - %03i",course(ADF1_MB),course(ADF1_MB+180.0)) );
	setprop("dd/navigation/ADF_2_MB", sprintf("%03i - %03i",course(ADF2_MB),course(ADF2_MB+180.0)) );
# 	setprop("dd/navigation/ADF_1_MB", course(ADF1_MB) );
# 	setprop("dd/navigation/ADF_2_MB", course(ADF2_MB) );
	
}


############ Display properties ########
var nav_display_status = 0;
var nav_display_object = nil;
var nav_display = func(){
	nav_display_status = !nav_display_status;
	if (nav_display_status){
		fnCopilot("I'm reporting.");
		
		#screen.display.new(-15, -5, 0).setfont("TIMES_24").setcolor(1, 0.9, 0)
		
		
		nav_display_object.add(props.globals.getNode("/instrumentation/kcs55/ki525/selected-course-deg"));
		nav_display_object.add(props.globals.getNode("/dd/navigation/course"));
		nav_display_object.add(props.globals.getNode("/instrumentation/kcs55/ki525/selected-heading-deg"));
		nav_display_object.add(props.globals.getNode("/dd/navigation/ADF_1_MB"));
		nav_display_object.add(props.globals.getNode("/dd/navigation/ADF_2_MB"));
		
		
# 		screen.property_display.add(props.globals.getNode("/dd/navigation/CH"));
# 		screen.property_display.add(props.globals.getNode("/instrumentation/kcs55/ki525/selected-heading-deg"));
# 		screen.property_display.add(props.globals.getNode("/instrumentation/adf[0]/indicated-bearing-deg"));
# 		screen.property_display.add(props.globals.getNode("/instrumentation/adf[1]/indicated-bearing-deg"));
# 		screen.property_display.add(props.globals.getNode("/dd/navigation/ADF_1_MB"));
# 		screen.property_display.add(props.globals.getNode("/dd/navigation/ADF_2_MB"));
# 		
		
		
	}else{
		fnCopilot("I'm quiet now !!");
		#screen.property_display.reset();
		nav_display_object.reset();
	}
}



#loader_init();

setlistener("/sim/signals/fdm-initialized", loader_init );

print("DD_Tour2013.nas ... loaded");