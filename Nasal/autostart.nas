###########################################################################################
#
#  Autostart for AN-12BK
#
#  Copyright (C) Herbert Wagner Dec2014-2016
#  see Read-Me.txt for all copyrights in the base folder of this aircraft
###########################################################################################
setprop("/controls/autostart-time", 1);

setlistener("/controls/autostart", func 

  { if(getprop("/controls/autostart") > 0.5)
      {
	setprop("/controls/autostart-time", 0);
	interpolate("/controls/autostart-time", 1, 70);
	setprop("/controls/electric/battery-switch", 1);
        setprop("/controls/switches/gauge-light", 1);
        setprop("/controls/lighting/nav-lights", 1);
	setprop("/controls/lighting/beacon", 1);
	
	setprop("/sim/messages/copilot", "Main power and lights are on");
	
	setprop("/instrumentation/adf[0]/power-btn", 1);
	setprop("/instrumentation/adf[1]/power-btn", 1);
	setprop("/instrumentation/heading-indicator[0]/serviceable", 1);
	setprop("/instrumentation/nav[0]/power-btn", 1);
	setprop("/instrumentation/nav[1]/power-btn", 1);
	setprop("/instrumentation/transponder/serviceable", 1);
	
	setprop("/sim/messages/copilot", "Instruments are powered");
	
	setprop("/controls/switches/fuel", 1);
        setprop("/consumables/fuel/tank[0]/selected", 1);
        setprop("/consumables/fuel/tank[1]/selected", 1);
        setprop("/consumables/fuel/tank[2]/selected", 1);
        setprop("/consumables/fuel/tank[3]/selected", 1);
        
	interpolate("/controls/engines/engine[0]/throttle", 0.1, 17);
	interpolate("/controls/engines/engine[3]/throttle", 0.001, 17, 0.1, 17);
	interpolate("/controls/engines/engine[1]/throttle", 0.001, 34, 0.1, 17);
	interpolate("/controls/engines/engine[2]/throttle", 0.001, 51, 0.1, 17);
	
	interpolate("/controls/engines/engine[0]/condition", 1, 1);
	interpolate("/controls/engines/engine[3]/condition", 0, 16, 1, 1);
	interpolate("/controls/engines/engine[1]/condition", 0, 33, 1, 1);
	interpolate("/controls/engines/engine[2]/condition", 0, 50, 1, 1);
	
	interpolate("/engines/engine[0]/running", 1, 1);
	interpolate("/engines/engine[3]/running", 1, 17);
	interpolate("/engines/engine[1]/running", 1, 34);
	interpolate("/engines/engine[2]/running", 1, 51);
	
	setprop("/sim/messages/copilot", "Engines 1-4 starting up, wait 70 seconds till idle position");
      }  
  }
  );


setlistener("/controls/electric/battery-switch", func 

  { if(getprop("/controls/electric/battery-switch") == 0)
      {
		
        setprop("/controls/switches/gauge-light", 0);
        setprop("/controls/lighting/nav-lights", 0);
	setprop("/controls/lighting/beacon", 0);
	setprop("/controls/lighting/strobe", 0);
	setprop("/controls/switches/headlight-mode",1);
    setprop("/sim/multiplay/generic/int[9]",0);
    setprop("/sim/multiplay/generic/int[10]",0);
	
	setprop("/sim/messages/copilot", "Main power and lights are off");
	
	setprop("/instrumentation/adf[0]/power-btn", 0);
	setprop("/instrumentation/adf[1]/power-btn", 0);
	setprop("/instrumentation/heading-indicator[0]/serviceable", 0);
	setprop("/instrumentation/nav[0]/power-btn", 0);
	setprop("/instrumentation/nav[1]/power-btn", 0);
	setprop("/instrumentation/transponder/serviceable", 0);
	
	setprop("/sim/messages/copilot", "Instruments are unpowered");
	
	setprop("/controls/switches/fuel", 0);
        setprop("/consumables/fuel/tank[0]/selected", 0);
        setprop("/consumables/fuel/tank[1]/selected", 0);
        setprop("/consumables/fuel/tank[2]/selected", 0);
        setprop("/consumables/fuel/tank[3]/selected", 0);
        
	setprop("/sim/messages/copilot", "Main Battery Power is off");
      }  
  }
  );
