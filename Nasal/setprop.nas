
#UVID-15 Control for Pressure in mmhg and inhg
# create listener

setlistener("/instrumentation/altimeter/setting-inhg", func(v)
{
  if(v.getValue())
  
    setprop("/instrumentation/altimeter/mmhg", getprop("/instrumentation/altimeter/setting-inhg") * 25.4);
    setprop("/instrumentation/altimeter/setting-inhgN", getprop("/instrumentation/altimeter/setting-inhg") + 0.005);
});







#
#var timerPressure = maketimer(0.10, func
#
#{     
#    setprop("/instrumentation/altimeter/mmhg", getprop("/instrumentation/altimeter/setting-inhg") * 25.39999);    
#  }
#);
#
# start the timer (with 0.10 second inverval)
#timerPressure.start();


#UVPD Control
# create timer with 0.1 second interval
var timerDiff = maketimer(0.1, func

{ 
    setprop("/controls/pressurization/diffdruck", (1 / getprop("/environment/atmosphere/density-tropo-avg") - 1.58));    
  }
);

# start the timer (with 0.1 second inverval)
timerDiff.start();

#
#Paratroopers
#
setlistener("/controls/paratroopers/jump-signal", func(v) {
  if(v.getValue()){
    interpolate("/controls/paratroopers/jump-signal-pos", 1, 0.25);
  }else{
    interpolate("/controls/paratroopers/jump-signal-pos", 0, 0.25);
  }
});

#
# Air and Groundspeed selector for USVP-Instrument
#
setlistener("/tu154/switches/usvp-selector-trans", func 

  { if(getprop("/tu154/switches/usvp-selector-trans") > 0.5)
      {
        setprop("/tu154/instrumentation/usvp/air_ground_speed_kt", getprop("/velocities/groundspeed-kt"));
      }
      else
      {
        setprop("/tu154/instrumentation/usvp/air_ground_speed_kt", getprop("/velocities/airspeed-kt"));
      }
  
  }
  );
 
#Lights
setprop("tu154/switches/headlight-mode", 1);


#
#Fuel and Condition Control
#
setprop("/consumables/fuel/tank[0]/selected", 0);
setprop("/consumables/fuel/tank[1]/selected", 0);
setprop("/consumables/fuel/tank[2]/selected", 0);
setprop("/consumables/fuel/tank[3]/selected", 0);
setprop("/controls/switches/fuel", 0);

setlistener("/controls/switches/fuel", func 

  { if(getprop("/controls/switches/fuel") > 0.5)
      {
        setprop("/consumables/fuel/tank[0]/selected", 1);
        setprop("/consumables/fuel/tank[1]/selected", 1);
        setprop("/consumables/fuel/tank[2]/selected", 1);
        setprop("/consumables/fuel/tank[3]/selected", 1);
      }
      else
      {
        setprop("/consumables/fuel/tank[0]/selected", 0);
        setprop("/consumables/fuel/tank[1]/selected", 0);
        setprop("/consumables/fuel/tank[2]/selected", 0);
        setprop("/consumables/fuel/tank[3]/selected", 0);
	setprop("/controls/engines/engine[0]/condition", 0);
	setprop("/controls/engines/engine[1]/condition", 0);
	setprop("/controls/engines/engine[2]/condition", 0);
	setprop("/controls/engines/engine[3]/condition", 0);
      }
  
  }
  );
 
##########################################################
#      ALS Control by HerbyW 03/2015
##########################################################

setlistener("/controls/ALS/setting", func(v) {
  if(v.getValue()){
    interpolate("/controls/ALS/setting-pos", 1, 0.25);
  }else{
    interpolate("/controls/ALS/setting-pos", 0, 0.25);
  }
});


setlistener("controls/ALS/setting", func

 { 
   if(getprop("sim/rendering/rembrandt/enabled") == 1)
    {
      setprop("sim/messages/copilot", "ALS is not working with Rembrandt");
    }
    else
    { 
      if(getprop("controls/ALS/setting") == 1)
      {
      setprop("sim/rendering/shaders/skydome", 1);
      setprop("sim/rendering/als-secondary-lights/landing-light1-offset-deg", -12);
      setprop("sim/rendering/als-secondary-lights/landing-light2-offset-deg", 12);
      setprop("sim/rendering/als-secondary-lights/use-alt-landing-light", 1);
      setprop("sim/rendering/als-secondary-lights/use-landing-light", 1);
      setprop("sim/rendering/als-secondary-lights/use-searchlight", 1);
      }
      else
      {
      setprop("sim/rendering/als-secondary-lights/use-alt-landing-light", 0);
      setprop("sim/rendering/als-secondary-lights/use-landing-light", 0);
      setprop("sim/rendering/als-secondary-lights/use-searchlight", 0);
      }
    }   

 }
);




# /engines/engine[0]/running
# /controls/switches/fuel
# /controls/engines/engine[0]/condition
#
#
#
#   initialisieren:
#
#  var flaginfo = props.globals.initNode("/controls/flag-info",0,"INT");
#
#  DOUBLE oder BOOL

#var AP_VS_neutral = func() {interpolate( getprop("/autopilot/settings/vertical-speed-fpm"), 0.0 , 5 );
#}
#setprop("/autopilot/internal/vert-speed-fpm", "AP_VS_neutral")
#;

# <command>nasal</command>
# 		  instruments.AP_VS_neutral();

# instruments

# /autopilot/locks/altitude

# <command>property-assign</command>
#		  <property>/autopilot/settings/target-altitude-ft</property>
#		  <property>/position/altitude-ft</property>

# <command>property-assign</command>
#              <property>/autopilot/settings/vertical-speed-fpm</property>
#	      <property>/autopilot/internal/vert-speed-fpm</property>
#	      

# <action>
#            <button>0</button>
#            <binding>
#              <command>property-assign</command>
#              <property>/autopilot/locks/altitude</property>
#              <value type="string">vertical-speed-hold</value>
#            </binding>
#	    <binding>
#              <command>property-assign</command>
#              <property>/autopilot/settings/vertical-speed-fpm</property>
#	      <property>/autopilot/internal/vert-speed-fpm</property>
#            </binding>
#        </action>