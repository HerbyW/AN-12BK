setprop("/instrumentation/altimeter/mmhg", getprop("/environment/config/interpolated/pressure-inhg") * 25.39999);

setprop("/instrumentation/altimeter/inhg100", getprop("/environment/config/interpolated/pressure-inhg") * 100);


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