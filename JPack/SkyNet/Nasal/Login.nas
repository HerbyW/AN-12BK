#var check=func() {
#	setprop("/controls/autoflight/diff_to_climb", 0);
#	setprop("/controls/flight/rudder_comp", getprop("/controls/flight/rudder"));
#	setprop("/controls/flight/rudder", 0);
#	checkData();
#}

#var checkData=func() {
#	print("---------------------------------------------------------------------");
#	print("vertical_mode=", getprop("controls/autoflight/vertical_mode"));
#	print("indicated alt=", getprop("instrumentation/altimeter/indicated-altitude-ft"));
#	print("ap set alt=", getprop("/autopilot/settings/altitude-setting-ft"));
#	print("ap target climb=", getprop("/autopilot/internal/target-climb-rate-fps"));
#	print("vert. speed=", getprop("/velocities/vertical-speed-fps"));
#	print("ap target pitch=", getprop("/autopilot/internal/target-pitch-deg"));
#	print("elevator trim=", getprop("/controls/flight/elevator-trim"));

#	var test=math.abs(getprop("instrumentation/altimeter/indicated-altitude-ft")-getprop("/autopilot/settings/altitude-setting-ft"));
#	if (test<1000) {
#		var test2=getprop("/autopilot/settings/altitude-setting-ft")-getprop("instrumentation/altimeter/indicated-altitude-ft");
#		setprop("/controls/autoflight/diff_to_climb", test2);
#	}
#	if (test<100 and !getprop("controls/autoflight/app-engage") and !getprop("controls/autoflight/vnav-engage")) {
#		var test2=getprop("/autopilot/settings/altitude-setting-ft")-getprop("instrumentation/altimeter/indicated-altitude-ft");
#		setprop("/controls/autoflight/diff_to_climb", test2);
#		setprop("controls/autoflight/fpa-engage", "false");
#		setprop("controls/autoflight/alt-engage", "true");
#		setprop("controls/autoflight/flch-engage", "false");
#		setprop("controls/autoflight/vs-engage", "false");
#		setprop("controls/autoflight/vertical_mode", 2);
#	}
#
#	if (getprop("controls/autoflight/vertical_mode")==0) {
#print("VR=", getprop("/instrumentation/fmc/vspeeds/VR"));
#print("AS=", getprop("/velocities/airspeed-kt"));
#		var spd1=getprop("/instrumentation/fmc/vspeeds/VR");
#		var spd2=getprop("/velocities/airspeed-kt");
#		if (spd1>spd2) {
#			setprop("/controls/autoflight/vr-ref-alt", getprop("/velocities/vertical-speed-fps"));
#print("Auto Take-Off is COLD");
#		} else {
#			setprop("/controls/autoflight/vr-ref-alt", 10000);
#print("Auto Take-Off is HOT");
#		}
#print("-----------------------------------------------------------------------------");
#	}
#
#	settimer (checkData, 1);
#}

var login=func() {
	if (getprop("skynet/login-pending")) {
		var httpstring="http://www.TheJabberwocky.net/SkyNet.php?usr="~getprop("skynet/username")~"&pwd="~getprop("skynet/password");
#print(httpstring);
		var params1=props.Node.new({
			"url"		:	httpstring,
			"targetnode"	:	"/skynet/response",
			"complete"	:	"/skynet/response/complete"
		});
		fgcommand("xmlhttprequest", params1);
		var login_listener=setlistener("skynet/response/complete", login_cb);
	}
}

var tracker=func() {
	if (getprop("skynet/response/login")=="confirmed") {
print("tracker 1");
		var sess=getprop("skynet/session") or "";
		var cmd="SETPOSITION" or "";
		var lat=getprop("position/latitude-deg") or "";
		var lon=getprop("position/longitude-deg") or "";
		var alt=getprop("position/altitude-ft") or 0;
		var hdg=getprop("orientation/heading-deg") or 0;
		var httpstring="http://www.TheJabberwocky.net/SkyNet.php?sess="~sess~"&cmd="~cmd~"&lat="~lat~"&lon="~lon~"&alt="~alt~"&hdg="~hdg;
		var params1=props.Node.new({
			"url"		:	httpstring,
			"targetnode"	:	"/skynet/response",
			"complete"	:	"/skynet/response/complete"
		});
		setprop("skynet/response/complete", 'false');
		fgcommand("xmlhttprequest", params1);
	}
}

var login_cb=func() {
	if (getprop("skynet/login-pending")) {
		var session=getprop("skynet/response/session");
		setprop("skynet/session", getprop("skynet/response/session"));

		var sess=getprop("skynet/session") or "";
		var callsign=getprop("skynet/callsign") or "";
		var cmd="SETCALLSIGN" or "";
		var httpstring="http://www.TheJabberwocky.net/SkyNet.php?sess="~sess~"&cmd="~cmd~"&callsign="~callsign;
		var params2=props.Node.new({
			"url"		:	httpstring,
			"targetnode"	:	"/skynet/response"
		});
		fgcommand("xmlhttprequest", params2);
		var track_listener=setlistener("skynet/response/complete", tracker_cb);
		setprop("skynet/login-pending", 'false');
	}
}

var tracker_cb=func() {
	if (getprop("skynet/response/login")=="confirmed") {
		if (getprop("skynet/response/complete")) {
print("tracker 2");
			settimer(tracker, 5);
		}
	}
}

var login_listener=setlistener("skynet/login-pending", login);

