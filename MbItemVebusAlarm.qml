import QtQuick 1.1
import "utils.js" as Utils

MbItemRow {

	property string bindPrefix
	property string alarm
	property int numOfPhases: 1
	property bool multiPhase: numOfPhases > 1
	property bool errorItem: false

	values: MbColumn {
		spacing: 2
		MbRow {
			// Note: multi's connected to the CAN-bus still report these and don't
			// report per phase alarms, so hide it if per phase L1 is available.
			MbTextBlock {
				item.bind: Utils.path(bindPrefix, "/Alarms/", alarm)
				item.text: getText(item.value)
				visible: item.valid && !l1Alarm.visible
			}
			MbTextBlock {
				id: l1Alarm
				item.bind: Utils.path(bindPrefix, "/Alarms", "/L1/", alarm)
				item.text: ( numOfPhases === 1 ? "" : "L1: " ) + getText(item.value)
				visible: item.valid
			}
			MbTextBlock { item.bind: Utils.path(bindPrefix, "/Alarms", "/L2/", alarm)
				item.text: "L2: " + getText(item.value)
				visible: item.valid && numOfPhases >= 2 && multiPhase
			}
			MbTextBlock {
				item.bind: Utils.path(bindPrefix, "/Alarms", "/L3/", alarm)
				item.text: "L3: " + getText(item.value)
				visible: item.valid && numOfPhases >= 3 && multiPhase
			}
		}
	}

	function getText(value)
	{
		switch(value) {
		case 0:
			return qsTr("Ok")
		case 1:
			return qsTr("Warning")
		case 2:
			return errorItem ? qsTr("Error") : qsTr("Alarm")
		default:
			return qsTr("--")
		}
	}
}

