import QtQuick 1.1

// Status indicator for alarm level
MbItemOptions {
	readonly: true
	possibleValues:[
		MbOption { description: qsTr("Ok"); value: 0 },
		MbOption { description: qsTr("Warning"); value: 1 },
		MbOption { description: qsTr("Alarm"); value: 2 }
	]
}
