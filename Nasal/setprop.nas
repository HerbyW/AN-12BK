setprop("/instrumentation/altimeter/mmhg", getprop("/environment/config/interpolated/pressure-inhg") * 25.39999);

setprop("/instrumentation/altimeter/inhg100", getprop("/environment/config/interpolated/pressure-inhg") * 100);