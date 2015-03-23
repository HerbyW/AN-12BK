

# ARK support setprop("tu154/instrumentation/ark-15[0]/powered", 1 );

ark_1_2_handler = func {
	var ones = getprop("tu154/instrumentation/ark-15[0]/digit-2-1");
	if( ones == nil ) ones = 0.0;
	var dec = getprop("tu154/instrumentation/ark-15[0]/digit-2-2");
	if( dec == nil ) dec = 0.0;
	var hund = getprop("tu154/instrumentation/ark-15[0]/digit-2-3");
	if( hund == nil ) hund = 0.0;
	var freq = hund * 100 + dec * 10 + ones;
	if( getprop("tu154/switches/adf-1-selector") == 1 )
		setprop("instrumentation/adf[0]/frequencies/selected-khz", freq );
}

ark_1_1_handler = func {
	var ones = getprop("tu154/instrumentation/ark-15[0]/digit-1-1");
	if( ones == nil ) ones = 0.0;
	var dec = getprop("tu154/instrumentation/ark-15[0]/digit-1-2");
	if( dec == nil ) dec = 0.0;
	var hund = getprop("tu154/instrumentation/ark-15[0]/digit-1-3");
	if( hund == nil ) hund = 0.0;
	var freq = hund * 100 + dec * 10 + ones;
	if( getprop("tu154/switches/adf-1-selector") == 0 )
		setprop("instrumentation/adf[0]/frequencies/selected-khz", freq );
}

ark_2_2_handler = func {
	var ones = getprop("tu154/instrumentation/ark-15[1]/digit-2-1");
	if( ones == nil ) ones = 0.0;
	var dec = getprop("tu154/instrumentation/ark-15[1]/digit-2-2");
	if( dec == nil ) dec = 0.0;
	var hund = getprop("tu154/instrumentation/ark-15[1]/digit-2-3");
	if( hund == nil ) hund = 0.0;
	var freq = hund * 100 + dec * 10 + ones;
	if( getprop("tu154/switches/adf-2-selector") == 1 )
		setprop("instrumentation/adf[1]/frequencies/selected-khz", freq );
}

ark_2_1_handler = func {
	var ones = getprop("tu154/instrumentation/ark-15[1]/digit-1-1");
	if( ones == nil ) ones = 0.0;
	var dec = getprop("tu154/instrumentation/ark-15[1]/digit-1-2");
	if( dec == nil ) dec = 0.0;
	var hund = getprop("tu154/instrumentation/ark-15[1]/digit-1-3");
	if( hund == nil ) hund = 0.0;
	var freq = hund * 100 + dec * 10 + ones;
	if( getprop("tu154/switches/adf-2-selector") == 0 )
		setprop("instrumentation/adf[1]/frequencies/selected-khz", freq );
}


ark_1_power = func{
    if( getprop("tu154/switches/gauge-light") == 1 )
	{
    	if( getprop("tu154/switches/gauge-light") == 1 )
		{
	     
	     setprop("instrumentation/adf[0]/serviceable", 1 );
		}
 	else {
	     
	     setprop("instrumentation/adf[0]/serviceable", 0 );
	     }
	} 
   else {
	
	setprop("instrumentation/adf[0]/serviceable", 0 );
	}
}

ark_2_power = func{
    if( getprop("tu154/switches/gauge-light") == 1 )
	{
    	if( getprop("tu154/switches/gauge-light") == 1 )
		{
	     
	     setprop("instrumentation/adf[1]/serviceable", 1 );
		}
 	else {
	     
	     setprop("instrumentation/adf[1]/serviceable", 0 );
		}
	} 
   else {
	
	setprop("instrumentation/adf[1]/serviceable", 0 );
	}
}



# read selected and standby ADF frequencies and copy it to ARK
ark_init = func{
var freq = getprop("instrumentation/adf[0]/frequencies/selected-khz");
if( freq == nil ) freq = 0.0;
setprop("tu154/instrumentation/ark-15[0]/digit-1-3", 
int( (freq/100.0) - int( freq/1000.0 )*10.0 ) );
setprop("tu154/instrumentation/ark-15[0]/digit-1-2", 
int( (freq/10.0) - int( freq/100.0 )*10.0 ) );
setprop("tu154/instrumentation/ark-15[0]/digit-1-1", 
int( freq - int( freq/10.0 )*10.0 ) );

freq = getprop("instrumentation/adf[0]/frequencies/standby-khz");
if( freq == nil ) freq = 0.0;
setprop("tu154/instrumentation/ark-15[0]/digit-2-3", 
int( (freq/100.0) - int( freq/1000.0 )*10.0 ) );
setprop("tu154/instrumentation/ark-15[0]/digit-2-2", 
int( (freq/10.0) - int( freq/100.0 )*10.0 ) );
setprop("tu154/instrumentation/ark-15[0]/digit-2-1", 
int( freq - int( freq/10.0 )*10.0 ) );

freq = getprop("instrumentation/adf[1]/frequencies/selected-khz");
if( freq == nil ) freq = 0.0;
setprop("tu154/instrumentation/ark-15[1]/digit-1-3", 
int( (freq/100.0) - int( freq/1000.0 )*10.0 ) );
setprop("tu154/instrumentation/ark-15[1]/digit-1-2", 
int( (freq/10.0) - int( freq/100.0 )*10.0 ) );
setprop("tu154/instrumentation/ark-15[1]/digit-1-1", 
int( freq - int( freq/10.0 )*10.0 ) );

freq = getprop("instrumentation/adf[1]/frequencies/standby-khz");
if( freq == nil ) freq = 0.0;
setprop("tu154/instrumentation/ark-15[1]/digit-2-3", 
int( (freq/100.0) - int( freq/1000.0 )*10.0 ) );
setprop("tu154/instrumentation/ark-15[1]/digit-2-2", 
int( (freq/10.0) - int( freq/100.0 )*10.0 ) );
setprop("tu154/instrumentation/ark-15[1]/digit-2-1", 
int( freq - int( freq/10.0 )*10.0 ) );

}

ark_init();

setlistener("tu154/switches/gauge-light", ark_1_power ,0,0);
setlistener("tu154/switches/gauge-light", ark_2_power ,0,0);

setlistener( "tu154/switches/adf-1-selector", ark_1_1_handler ,0,0);
setlistener( "tu154/switches/adf-1-selector", ark_1_2_handler ,0,0);

setlistener( "tu154/switches/adf-2-selector", ark_2_1_handler ,0,0);
setlistener( "tu154/switches/adf-2-selector", ark_2_2_handler ,0,0);

setlistener( "tu154/instrumentation/ark-15[0]/digit-1-1", ark_1_1_handler ,0,0);
setlistener( "tu154/instrumentation/ark-15[0]/digit-1-2", ark_1_1_handler ,0,0);
setlistener( "tu154/instrumentation/ark-15[0]/digit-1-3", ark_1_1_handler ,0,0);

setlistener( "tu154/instrumentation/ark-15[0]/digit-2-1", ark_1_2_handler ,0,0);
setlistener( "tu154/instrumentation/ark-15[0]/digit-2-2", ark_1_2_handler ,0,0);
setlistener( "tu154/instrumentation/ark-15[0]/digit-2-3", ark_1_2_handler ,0,0);

setlistener( "tu154/instrumentation/ark-15[1]/digit-1-1", ark_2_1_handler ,0,0);
setlistener( "tu154/instrumentation/ark-15[1]/digit-1-2", ark_2_1_handler ,0,0);
setlistener( "tu154/instrumentation/ark-15[1]/digit-1-3", ark_2_1_handler ,0,0);

setlistener( "tu154/instrumentation/ark-15[1]/digit-2-1", ark_2_2_handler ,0,0);
setlistener( "tu154/instrumentation/ark-15[1]/digit-2-2", ark_2_2_handler ,0,0);
setlistener( "tu154/instrumentation/ark-15[1]/digit-2-3", ark_2_2_handler ,0,0);

