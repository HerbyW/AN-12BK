
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

 var oilTempTimer = maketimer(5.0, func { 
var factor = 2;
interpolate("engines/engine/oil-temperature-degf", getprop("engines/engine/fuel-flow-gph")*factor, 5.0);
interpolate("engines/engine[1]/oil-temperature-degf", getprop("engines/engine[1]/fuel-flow-gph")*factor, 5.0);
interpolate("engines/engine[2]/oil-temperature-degf", getprop("engines/engine[2]/fuel-flow-gph")*factor, 5.0);
interpolate("engines/engine[3]/oil-temperature-degf", getprop("engines/engine[3]/fuel-flow-gph")*factor, 5.0);
}
);

oilTempTimer.start(); 
