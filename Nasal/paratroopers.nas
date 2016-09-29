
#########################################################################################
#
#  DE L'HAMAIDE Clément for Douglas DC-3 C47
#  modified by HerbyW 01/2015 and D-LEON
#
#########################################################################################
#
#  Copyright (C) Herbert Wagner Dec2014-2016
#  see Read-Me.txt for all copyrights in the base folder of this aircraft
#
#########################################################################################

var jumper = aircraft.light.new("controls/paratroopers/trigger", [0.5,0.5], "controls/paratroopers/jump-signal");


var listener_id = setlistener("sim/weight[2]/weight-lb" , func {setprop("controls/paratroopers/paratroopers", getprop("/sim/weight[2]/weight-lb") / 120)},  0, 0);



setlistener("controls/paratroopers/trigger/state", func(state){
  if(state.getValue()){
    if(getprop("sim/model/door-positions/baie/position-norm") < 0.75){
      jumper.switch(0);
      setprop("controls/paratroopers/trigger/state", 0);
      setprop("sim/messages/copilot", "Paratroopers door is closed ! Paratroopers can't jump");
    }else{
      var nb_para = getprop("controls/paratroopers/paratroopers") - 1;
      setprop("controls/paratroopers/paratroopers", nb_para);
      var weight = getprop("/sim/weight[2]/weight-lb") - 120;
      setprop("/sim/weight[2]/weight-lb", weight);
      if(getprop("controls/paratroopers/paratroopers") > 0){
        setprop("sim/messages/copilot", getprop("controls/paratroopers/paratroopers")~" Paratroopers remaining");
      }else{
        jumper.switch(0);
        setprop("sim/messages/copilot", "There are no Paratroopers inside");
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