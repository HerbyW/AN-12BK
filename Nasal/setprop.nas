setprop("/instrumentation/altimeter/mmhg", getprop("/environment/config/interpolated/pressure-inhg") * 25.39999);

setprop("/instrumentation/altimeter/inhg100", getprop("/environment/config/interpolated/pressure-inhg") * 100);



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