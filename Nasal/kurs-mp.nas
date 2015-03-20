#
# NASAL instruments for TU-154B
# Yurik V. Nikiforoff, yurik.nsk@gmail.com
# Novosibirsk, Russia
# jun 2007, dec 2013
#


######################################################################

#                           KURS-MP frequency support

var kursmp_sync = func{
var frequency = 0.0;
var heading = 0.0;
if( arg[0] == 0 )	# proceed captain panel
	{ #frequency
	var freq_hi = getprop("tu154/instrumentation/kurs-mp-1/digit-f-hi");
	if( freq_hi == nil ) return;
	var freq_low = getprop("tu154/instrumentation/kurs-mp-1/digit-f-low");
	if( freq_low == nil ) return;
	frequency = freq_hi + freq_low/100.0;
	setprop("instrumentation/nav[0]/frequencies/selected-mhz", frequency );
	# heading
	var hdg_ones = getprop("tu154/instrumentation/kurs-mp-1/digit-h-ones");
	if( hdg_ones == nil ) return;
	var hdg_dec = getprop("tu154/instrumentation/kurs-mp-1/digit-h-dec");
	if( hdg_dec == nil ) return;
	var hdg_hund = getprop("tu154/instrumentation/kurs-mp-1/digit-h-hund");
	if( hdg_hund == nil ) return;
	heading = hdg_hund * 100 + hdg_dec * 10 + hdg_ones;
	if( heading > 359.0 ) { 
		heading = 0.0;
                setprop("tu154/instrumentation/kurs-mp-1/digit-h-hund", 0.0 );
                setprop("tu154/instrumentation/kurs-mp-1/digit-h-dec", 0.0 );
                setprop("tu154/instrumentation/kurs-mp-1/digit-h-ones", 0.0 );
		}
	setprop("instrumentation/nav[0]/radials/selected-deg", heading );
	return;
	}
if( arg[0] == 1 ) # co-pilot
	{ #frequency
	var freq_hi = getprop("tu154/instrumentation/kurs-mp-2/digit-f-hi");
	if( freq_hi == nil ) return;
	var freq_low = getprop("tu154/instrumentation/kurs-mp-2/digit-f-low");
	if( freq_low == nil ) return;
	frequency = freq_hi + freq_low/100.0;
	setprop("instrumentation/nav[1]/frequencies/selected-mhz", frequency );
	# heading
	var hdg_ones = getprop("tu154/instrumentation/kurs-mp-2/digit-h-ones");
	if( hdg_ones == nil ) return;
	var hdg_dec = getprop("tu154/instrumentation/kurs-mp-2/digit-h-dec");
	if( hdg_dec == nil ) return;
	var hdg_hund = getprop("tu154/instrumentation/kurs-mp-2/digit-h-hund");
	if( hdg_hund == nil ) return;
	heading = hdg_hund * 100 + hdg_dec * 10 + hdg_ones;
		if( heading > 359.0 ) { 
		heading = 0.0;
                setprop("tu154/instrumentation/kurs-mp-2/digit-h-hund", 0.0 );
                setprop("tu154/instrumentation/kurs-mp-2/digit-h-dec", 0.0 );
                setprop("tu154/instrumentation/kurs-mp-2/digit-h-ones", 0.0 );
		}
	setprop("instrumentation/nav[1]/radials/selected-deg", heading );
	}
}

# initialize KURS-MP frequencies & headings
var kursmp_init = func{
var freq = getprop("instrumentation/nav[0]/frequencies/selected-mhz");
if( freq == nil ) { settimer( kursmp_init, 1.0 ); return; } # try until success
setprop("tu154/instrumentation/kurs-mp-1/digit-f-hi", int(freq) );
setprop("tu154/instrumentation/kurs-mp-1/digit-f-low", (freq - int(freq) ) * 100 );
var hdg = getprop("instrumentation/nav[0]/radials/selected-deg");
if( hdg == nil ) { settimer( kursmp_init, 1.0 ); return; }
setprop("tu154/instrumentation/kurs-mp-1/digit-h-hund", int(hdg/100) );
setprop("tu154/instrumentation/kurs-mp-1/digit-h-dec", int( (hdg/10.0)-int(hdg/100.0 )*10.0) );
setprop("tu154/instrumentation/kurs-mp-1/digit-h-ones", int(hdg-int(hdg/10.0 )*10.0) );
# second KURS-MP
freq = getprop("instrumentation/nav[1]/frequencies/selected-mhz");
if( freq == nil ) { settimer( kursmp_init, 1.0 ); return; } # try until success
setprop("tu154/instrumentation/kurs-mp-2/digit-f-hi", int(freq) );
setprop("tu154/instrumentation/kurs-mp-2/digit-f-low", (freq - int(freq) ) * 100 );
hdg = getprop("instrumentation/nav[1]/radials/selected-deg");
if( hdg == nil ) { settimer( kursmp_init, 1.0 ); return; }
setprop("tu154/instrumentation/kurs-mp-2/digit-h-hund", int( hdg/100) );
setprop("tu154/instrumentation/kurs-mp-2/digit-h-dec",int( ( hdg / 10.0 )-int( hdg / 100.0 ) * 10.0 ) );
setprop("tu154/instrumentation/kurs-mp-2/digit-h-ones", int( hdg-int( hdg/10.0 )* 10.0 ) );

}

var kursmp_watchdog_1 = func{
#settimer( kursmp_watchdog_1, 0.5 );
if( getprop("instrumentation/nav[0]/in-range" ) == 1 ) return;
 if( getprop("tu154/instrumentation/pn-5/gliss" ) == 1.0 ) absu.absu_reset();
 if( getprop("tu154/instrumentation/pn-5/az-1" ) == 1.0 ) absu.absu_reset();
 if( getprop("tu154/instrumentation/pn-5/zahod" ) == 1.0 ) absu.absu_reset();
}

var kursmp_watchdog_2 = func{
#settimer( kursmp_watchdog_2, 0.5 );
if( getprop("instrumentation/nav[1]/in-range" ) == 1 ) return;
if( getprop("tu154/instrumentation/pn-5/az-2" ) == 1.0 ) absu.absu_reset();
}

setlistener( "instrumentation/nav[0]/in-range", kursmp_watchdog_1, 0,0 );
setlistener( "instrumentation/nav[1]/in-range", kursmp_watchdog_2, 0,0 );

var kursmp_power_1 = func{
if( getprop( "tu154/switches/KURS-MP-1" ) == 1.0 )
	electrical.AC3x200_bus_1L.add_output( "KURS-MP-1", 20.0);
else electrical.AC3x200_bus_1L.rm_output( "KURS-MP-1" );		
}

var kursmp_power_2 = func{
if( getprop( "tu154/switches/KURS-MP-2" ) == 1.0 )
	electrical.AC3x200_bus_3R.add_output( "KURS-MP-2", 20.0);
else electrical.AC3x200_bus_3R.rm_output( "KURS-MP-2" );		
}

setlistener( "tu154/switches/KURS-MP-1", kursmp_power_1 ,0,0);
setlistener( "tu154/switches/KURS-MP-2", kursmp_power_2 ,0,0);
#kursmp_watchdog_1();
#kursmp_watchdog_2();
kursmp_init();

# ******************************** end KURS-MP *******************************
