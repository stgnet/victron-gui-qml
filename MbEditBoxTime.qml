import QtQuick 1.1

/* Note: select time of the day in hh:mm */
MbEditBoxDateTime {
	format: "hh:mm"
	invalidText: "--:--"
	textInput.color: "black"
	utc: true

	function getTimeSeconds(str) {
		var a = str.split(':')
		return parseInt(a[0], 10) * 60 * 60 + parseInt(a[1], 10) * 60
	}
}
