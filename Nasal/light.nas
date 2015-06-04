
#    #########################################################################################
#    Antonov-Aircrafts and SpaceShuttle :: Herbert Wagner November2014-June2015
#    Animations, FDM, Instrumentation, Rembrandt, ALS, Paratroopers, Cargo, Sounds
#    all with full Multiplayer Support.
#    Development is ongoing, see latest version: https://github.com/HerbyW?tab=repositories
#    This file is licenced under the terms of the GNU General Public Licence V3 or later
#    D-Leon: technical assistance
#    Firefly: 3D model improvment
#    Eagel: Liveries
#    Michat, Joe, Miguel, 3m, D-07007 and many others: testing and giving hints for impovements
#    Instruments from; Tu-154b, Il-76D, 707
#    ##########################################################################################

var sbc1 = aircraft.light.new( "/sim/model/lights/sbc1", [0.5, 0.3] );
sbc1.interval = 0.1;
sbc1.switch( 1 );

var sbc2 = aircraft.light.new( "/sim/model/lights/sbc2", [0.2, 0.3], "/sim/model/lights/sbc1/state" );
sbc2.interval = 0;
sbc2.switch( 1 );

setlistener( "/sim/model/lights/sbc2/state", func(n) {
  var bsbc1 = sbc1.stateN.getValue();
  var bsbc2 = n.getBoolValue();
  var b = 0;
  if( bsbc1 and bsbc2 and getprop( "/controls/lighting/beacon") ) {
    b = 1;
  } else {
    b = 0;
  }
  setprop( "/sim/model/lights/beacon/enabled", b );

  if( bsbc1 and !bsbc2 and getprop( "/controls/lighting/strobe" ) ) {
    b = 1;
  } else {
    b = 0;
  }
  setprop( "/sim/model/lights/strobe/enabled", b );
});

var beacon = aircraft.light.new( "/sim/model/lights/beacon", [0.05, 0.05] );
beacon.interval = 0;

var strobe = aircraft.light.new( "/sim/model/lights/strobe", [0.05, 0.05, 0.05, 1] );
strobe.interval = 0;
