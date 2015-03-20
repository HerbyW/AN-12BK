#
# NASAL instruments for TU-154B
# Yurik V. Nikiforoff, yurik.nsk@gmail.com
# Novosibirsk, Russia
# jun 2007, dec 2013
#


######################################################################

# ************************* TKS staff ***********************************

# auto corrector for GA-3 and BGMK
var tks_corr = func{
var mk1 = getprop("fdm/jsbsim/instrumentation/km-5-1");
if( mk1 == nil ) return;
var mk2 = getprop("fdm/jsbsim/instrumentation/km-5-2");
if( mk2 == nil ) return;
help.tks();	# show help string
if( getprop("tu154/switches/pu-11-gpk") == 1 ) { # GA-3 correction
# parameters GA-3
   var gpk_1 = getprop("fdm/jsbsim/instrumentation/ga3-corrected-1");
   var gpk_2 = getprop("fdm/jsbsim/instrumentation/ga3-corrected-2");
   if( gpk_1 == nil ) return;
   if( gpk_2 == nil ) return;
   if( getprop("tu154/switches/pu-11-corr") == 0 ) # kontr
	{
	if( getprop("instrumentation/heading-indicator[1]/serviceable" ) != 1 ) return;
	var delta = gpk_2 - mk2;
	if( abs( delta ) < 0.5 ) return; 		# not adjust small values
	if( delta > 360.0 ) delta = delta - 360.0;	# bias control
	if( delta < 0.0 ) delta = delta + 360.0;
	if( delta > 180 ) delta = 0.5; else delta = -0.5;# find short way	
	var offset = getprop("instrumentation/heading-indicator[1]/offset-deg");
	if( offset == nil ) return;
	setprop("instrumentation/heading-indicator[1]/offset-deg", offset+delta );
	return;
	}
else	{ # osn
	if( getprop("instrumentation/heading-indicator[0]/serviceable" ) != 1 ) return;
	var delta = gpk_1 - mk1;
	if( abs( delta ) < 1.0 ) return; 		# not adjust small values
	if( delta > 360.0 ) delta = delta - 360.0;	# bias control
	if( delta < 0.0 ) delta = delta + 360.0;
	if( delta > 180 ) delta = 0.5; else delta = -0.5;# find short way	
	var offset = getprop("instrumentation/heading-indicator[0]/offset-deg");
	if( offset == nil ) return;
	setprop("instrumentation/heading-indicator[0]/offset-deg", offset+delta );
	return;
	}
   } # end GA-3 correction
   if( getprop("tu154/switches/pu-11-gpk") == 0 ) { # BGMK correction
# parameters BGMK
   if( getprop("tu154/switches/pu-11-corr") == 0 ) # BGMK-2
	{
        setprop("fdm/jsbsim/instrumentation/bgmk-corrector-2",1);
	}
else	{ # BGMK-1
        setprop("fdm/jsbsim/instrumentation/bgmk-corrector-1",1);
	} 
   } # end BGMK correction
}

# manually adjust gyro heading - GA-3 only
tks_adj = func{
if( getprop("tu154/switches/pu-11-gpk") != 0 ) return;
help.tks();	# show help string
var delta = 0.1;
if( getprop("tu154/switches/pu-11-corr") == 0 ) # kontr
	{
	if( getprop("instrumentation/heading-indicator[1]/serviceable" ) != 1 ) return;
	if( arg[0] == 1 ) # to right
		{
		var offset = getprop("instrumentation/heading-indicator[1]/offset-deg");
		if( offset == nil ) return;
		setprop("instrumentation/heading-indicator[1]/offset-deg", offset+delta );
		return;
		}
	else	{ # to left
		var offset = getprop("instrumentation/heading-indicator[1]/offset-deg");
		if( offset == nil ) return;
		setprop("instrumentation/heading-indicator[1]/offset-deg", offset-delta );
		return;
		}
	}
else	{	# osn
	 if( getprop("instrumentation/heading-indicator[0]/serviceable" ) != 1 ) return;
	if( arg[0] == 1 ) # to right
		{
		var offset = getprop("instrumentation/heading-indicator[0]/offset-deg");
		if( offset == nil ) return;
		setprop("instrumentation/heading-indicator[0]/offset-deg", offset+delta );
		return;
		}
	else	{ # to left
		var offset = getprop("instrumentation/heading-indicator[0]/offset-deg");
		if( offset == nil ) return;
		setprop("instrumentation/heading-indicator[0]/offset-deg", offset-delta );
		return;
		}

	}
}

# TKS power support

tks_power_1 = func{
if( getprop( "tu154/switches/TKC-power-1" ) == 1.0 )
	electrical.AC3x200_bus_1L.add_output( "GA3-1", 10.0);
else electrical.AC3x200_bus_1L.rm_output( "GA3-1" );		
}

tks_bgmk_1 = func{
if( getprop( "tu154/switches/TKC-BGMK-1" ) == 1.0 )
	electrical.AC3x200_bus_1L.add_output( "BGMK-1", 10.0);
else electrical.AC3x200_bus_1L.rm_output( "BGMK-1" );		
}

tks_power_2 = func{
if( getprop( "tu154/switches/TKC-power-2" ) == 1.0 )
	electrical.AC3x200_bus_3R.add_output( "GA3-2", 10.0);
else electrical.AC3x200_bus_3R.rm_output( "GA3-2" );		
}

tks_bgmk_2 = func{
if( getprop( "tu154/switches/TKC-BGMK-2" ) == 1.0 )
	electrical.AC3x200_bus_3R.add_output( "BGMK-2", 10.0);
else electrical.AC3x200_bus_3R.rm_output( "BGMK-2" );		
}


setlistener( "tu154/switches/TKC-power-1", tks_power_1 ,0,0);
setlistener( "tu154/switches/TKC-power-2", tks_power_2 ,0,0);
setlistener( "tu154/switches/TKC-BGMK-1", tks_bgmk_1 ,0,0);
setlistener( "tu154/switches/TKC-BGMK-2", tks_bgmk_2 ,0,0);

# Aug 2009
# Azimuthal error for gyroscope

var last_point = geo.Coord.new();
var current_point = geo.Coord.new();

# Initialise
last_point = geo.aircraft_position();
current_point = last_point;
setprop("/fdm/jsbsim/instrumentation/az-err", 0.0 );

# Azimuth error handler
var tks_az_handler = func{
settimer(tks_az_handler, 60.0 );
current_point = geo.aircraft_position();
if( last_point.distance_to( current_point ) < 1000.0 ) return; # skip small distance

az_err = getprop("/fdm/jsbsim/instrumentation/az-err" );
var zipu = last_point.course_to( current_point );
var ozipu = current_point.course_to( last_point );
az_err += zipu - (ozipu - 180.0);
if( az_err > 180.0 ) az_err -= 360.0;
if( -180.0 > az_err ) az_err += 360.0;
setprop("/fdm/jsbsim/instrumentation/az-err", az_err );
last_point = current_point;
}

settimer(tks_az_handler, 60.0 );


# ************************* End TKS staff ***********************************
