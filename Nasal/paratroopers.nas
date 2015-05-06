
#    ###################################################################################
#    Antonov-Aircrafts and SpaceShuttle :: Herbert Wagner November2014-March2015
#    Development is ongoing, see latest version: www.github.com/HerbyW
#    This file is licenced under the terms of the GNU General Public Licence V3 or later
#    
#    Firefly: 3D model improvment: ruder, speedbreak, ailerions, all gears and doors
#    Eagel: Liveries
#    ###################################################################################


##########################################################
#      DE L'HAMAIDE Clément for Douglas DC-3 C47         # modified by HerbyW 01/2015 and D-LEON
##########################################################

var jumper = aircraft.light.new("controls/paratroopers/trigger", [0.5,0.5], "controls/paratroopers/jump-signal");		# Création du signal qui larguera les parachutistes toutes les 3.5 secondes


var listener_id = setlistener("sim/weight[2]/weight-lb" , func {setprop("controls/paratroopers/paratroopers", getprop("/sim/weight[2]/weight-lb") / 120)},  0, 0);



setlistener("controls/paratroopers/trigger/state", func(state){								# On écoute le switch qui déclenche le signal
  if(state.getValue()){													# Si un parachutiste saute
    if(getprop("sim/model/door-positions/baie/position-norm") < 0.75){						# Si la porte cargo n'est pas ouverte
      jumper.switch(0);													# On annule le larguage des parachutistes
      setprop("controls/paratroopers/trigger/state", 0);
      setprop("sim/messages/copilot", "Paratroopers door is closed ! Paratroopers can't jump");				# On indique le problème
    }else{														# Sinon si la porte est ouverte
      var nb_para = getprop("controls/paratroopers/paratroopers") - 1;							# On calcul combien il reste de parachutiste
      setprop("controls/paratroopers/paratroopers", nb_para);								# On attribut le nombre de parachutiste à la propriété
      var weight = getprop("/sim/weight[2]/weight-lb") - 120;							# On calcul le poids des parachutistes restant
      setprop("/sim/weight[2]/weight-lb", weight);									# On attribut le poids restant à la propriété
      if(getprop("controls/paratroopers/paratroopers") > 0){								# Si il reste encore des parachutistes
        setprop("sim/messages/copilot", getprop("controls/paratroopers/paratroopers")~" Paratroopers remaining");	# On indique le nombre de parachutistes restant  
      }else{                                                     							# Sinon
        jumper.switch(0);                                            							# On arrête le signal de saut
        setprop("sim/messages/copilot", "There are no Paratroopers inside");							# On indique qu'il n'y a plus de parachutistes
      }
    }
  }
});




var storageWeight = 6000;

var listener_id2 = setlistener("sim/weight[3]/weight-lb" , func {setprop("controls/storage/storage", getprop("/sim/weight[3]/weight-lb") / storageWeight)}, 0, 0);

var storageTimerRunning = 0;
var storageTimer = func(){
storageTimerRunning = 1;
var count = getprop("controls/storage/storage");
var state = getprop("controls/storage/trigger/state");
if (count > 0){
var weight = getprop("/sim/weight[3]/weight-lb") - storageWeight;

# roll
interpolate("/sim/weight[3]/weight-lb", weight, 9);
setprop("sim/messages/copilot","Storage rolling");

# jump
settimer(func{
setprop("controls/storage/trigger/state",1);
setprop("sim/messages/copilot","Storage out");
},9);

# prepair next
settimer(func{
setprop("controls/storage/trigger/state",0);
storageTimer();
},10.1);

}else{
setprop("controls/storage/trigger/state",0);
setprop("sim/messages/copilot", "There is no Storage inside");
storageTimerRunning = 0;
}
};

setlistener("controls/storage/jump-signal", func(state){

if (state.getValue()){
 if (state.getValue() == 1){
storageTimer();
}
}

});