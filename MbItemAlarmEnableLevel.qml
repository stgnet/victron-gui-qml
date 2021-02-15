import QtQuick 1.1

// Setting for an alarm condition which has a pre-alarm and alarm level.
// This option makes it configurable if pre-alarms / alarms should be ignored.

MbItemOptions {
	possibleValues:[
		MbOption { description: qsTr("Disabled"); value: 0 },
		MbOption { description: qsTr("Alarm only"); value: 1 }, // no pre-alarms
		MbOption { description: qsTr("Alarms & warnings"); value: 2 }
	]
}
