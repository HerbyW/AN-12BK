#
# Autostart for AN-12
#
#


setlistener("/controls/autostart", func 

  { if(getprop("/controls/autostart") > 0.5)
      {
        setprop("/tu154/switches/gauge-light", 1);
        setprop("/controls/lighting/nav-lights", 1);
        setprop("/controls/switches/fuel", 1);
        setprop("/consumables/fuel/tank[0]/selected", 1);
        setprop("/consumables/fuel/tank[1]/selected", 1);
        setprop("/consumables/fuel/tank[2]/selected", 1);
        setprop("/consumables/fuel/tank[3]/selected", 1);
        setprop("/controls/engines/engine[0]/condition", 1);
        setprop("/controls/engines/engine[1]/condition", 1);
        setprop("/controls/engines/engine[2]/condition", 1);
        setprop("/controls/engines/engine[3]/condition", 1);
      }
      
  
  }
  );