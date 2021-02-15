/*
 * Build a complete item path from the parts in array.
 *
 * When concatenating qml properties, such an expression is typically evaluated
 * multi times (once for every property changes). As a consequence, items are
 * (temporarily) bound to the wrong or invalid paths. This function prevents that
 * by only returning the concatenated string when all parts are non-empty, e.g.
 *
 *   property string prefix: "prefix"
 *   property string append: "append"
 *
 *   will be empty or the full path, but never partial. Mind that it needs to be commas,
 *   so the function sees all arguments seperatly (a plus will first concat and thereafter
 *   call the function.
 *
 *   item.bind: Utils.path(prefix, "/", append)
 *
 * Since this implicitly builds an array, a different functions was added, which explicitly
 * does that, which is:
 *
 *   item.bind: Utils.pathFromArray([prefix, "/", append])
 *
 * while by itself that is syntactically worse then the former, it gets called implicitly now
 * when the vbusitem bind property is set to an array, so the following is now valid as well
 * (and does exactly the same as both explicit calls mentioned above)
 *
 *   item.bind: [prefix, "/", append]
 */
.pragma library

// These values are defined in /usr/sbin/resolv-watch script
// that monitors which connection is the one active from
// all the avaiable ones.

var NetworkConnection = {
	None: 0,
	Ethernet: 1,
	WiFi: 2,
	GSM: 3
}

function path()
{
	return pathFromArray(arguments)
}

function pathFromArray(array)
{
	var str = "";

	for (var i = 0; i < array.length; i++) {
		if (array[i] === undefined || array[i] === "")
			return "";
		str += array[i]
	}

	return str
}

// returns the sign of a number..
function sign(val)
{
	if (val < 0)
		return -1
	if (val > 0)
		return 1
	return 0
}

function pad(number, length)
{
	var str = '' + parseInt(number, 10);

	while (str.length < length)
		str = '0' + str;

	return str;
}

// Convert a comma separated string to an array
function stringToArray(commaSeperatedString)
{
	var ret = [];
	if (commaSeperatedString !== undefined && commaSeperatedString.length > 0) {
		var split = commaSeperatedString.split(',');
		for (var i = 0; i < split.length; i++)
			ret.push(split[i]);
	}
	return ret
}

// Convert a comma separated string of ip-addresses to an array
function stringToIpArray(commaSeperatedString)
{
	var ret = stringToArray(commaSeperatedString)
	for (var i = 0; i < ret.length; i++)
			ret[i] = ret[i];
	return ret
}

// Convert a timestamp into a relative readable string, for example '1d 2h'
function timeAgo(timestamp)
{
	var timeNow = Math.round(+new Date() / 1000);
	var timeAgo = "---";
	if (timestamp !== undefined && timestamp > 0)
		timeAgo = secondsToString(timeNow - timestamp);
	return timeAgo;
}

// Convert number of seconds into readable string
function secondsToString(secs)
{
	if (secs === undefined)
		return "---"
	var days = Math.floor(secs / 86400);
	var hours = Math.floor((secs - (days * 86400)) / 3600);
	var minutes = Math.floor((secs - (hours * 3600)) / 60);
	var seconds = Math.floor(secs - (minutes * 60));
	if (days > 0)
		return qsTr("%1d %2h").arg(days).arg(hours);
	if (hours)
		return qsTr("%1h %2m").arg(hours).arg(minutes);
	if (minutes)
		return qsTr("%1m %2s").arg(minutes).arg(seconds);
	return qsTr("%1s").arg(seconds);
}

// Convert number of seconds into readable string
function secondsToNoSecsString(secs)
{
	if (secs === undefined)
		return "---"
	var days = Math.floor(secs / 86400);
	var hours = Math.floor((secs - (days * 86400)) / 3600);
	var minutes = Math.floor((secs - (hours * 3600)) / 60);
	if (days > 0)
		return qsTr("%1d %2h").arg(days).arg(hours);
	if (hours)
		return qsTr("%1h %2m").arg(hours).arg(minutes);
	if (minutes)
		return qsTr("%1m").arg(minutes);
	return qsTr("0m")
}

// Convert 1000000 to '10M items' or '1 file', etc.
function qtyToString(qty, unitSingle, unitMultiple)
{
	if (qty > 1000000)
		return "%1M %2".arg(Math.round((qty * 100) / 1000000) / 100).arg(unitMultiple);
	else if (qty > 1000)
		return "%1k %2".arg(Math.round((qty * 100) / 1000) / 100).arg(unitMultiple);
	else if (qty > 1 || qty === 0)
		return "%1 %2".arg(qty).arg(unitMultiple);
	else if (qty === 1)
		return "1 %1".arg(unitSingle);
	else
		return "---"
}

function qmltypeof(obj, className)
{
	if (obj === undefined)
		return ""

	// className plus "(" is the class instance without modification
	// className plus "_QML" is the class instance with user-defined properties
	var str = obj.toString();
	return str.indexOf(className + "(") === 0 || str.indexOf(className + "_QML") === 0;
}

function simplifiedNetworkType(t)
{
	if (!t)
		return ""
	switch (t) {
	case "NONE":
		return ""
	case "GPRS":
	case "GSM":
		return "G"
	case "EDGE":
		return "E"
	case "CDMA":
	case "1xRTT":
	case "IDEN":
		return "2G";
	case "UMTS":
	case "EVDO_0":
	case "EVDO_A":
	case "HSDPA":
	case "HSUPA":
	case "HSPA":
	case "EVDO_B":
	case "EHRPD":
	case "HSPAP":
		return "3G";
	case "LTE":
		return "4G";
	default:
		return t;
	}
}

function between(x, min, max) {
	return x >= min && x <= max;
}
