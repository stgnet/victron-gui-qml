import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	property string bindPrefix
	property string bindPage: "/Settings/Relay/"

	/* Show setting depending on the mode */
	function showSetting() {
		for (var i = 0; i < arguments.length; i++) {
			if (arguments[i] === mode.value)
				return true;
		}
		return false
	}

	model: VisualItemModel {
		MbItemOptions {
			id: mode
			description: qsTr("Relay function")
			bind: Utils.path(bindPrefix, bindPage, "Mode")
			possibleValues:[
				MbOption{description: qsTr("Alarm"); value: 0},
				MbOption{description: qsTr("Charger or generator start/stop"); value: 1},
				MbOption{description: qsTr("Manual control"); value: 2},
				MbOption{description: qsTr("Always open (don't use the relay)"); value: 3}
			]
			show: valid
		}

		MbSwitch {
			name: qsTr("State")
			bind: Utils.path(bindPrefix, "/Relay/0/State")
			enabled: mode.valid && mode.value === 2
			show: valid
		}

		MbItemText {
			text: qsTr("Note that changing the Low state-of-charge setting " +
				"also changes the Time-to-go discharge floor setting in the battery menu")
			wrapMode: Text.WordWrap
			show: dischargeFloorLinkedToRelay.valid && dischargeFloorLinkedToRelay.value !== 0 && lowSoc.show

			VBusItem {
				id: dischargeFloorLinkedToRelay
				bind: Utils.path(bindPrefix, "/Settings/", "DischargeFloorLinkedToRelay")
			}
		}

		MbRangeSlider {
			id: lowSoc
			description: qsTr("Low state-of-charge")
			unit: "%"
			lowColor: "indianred"
			highColor: "lightgreen"
			lowBind: Utils.path(bindPrefix, bindPage, "LowSoc")
			highBind: Utils.path(bindPrefix, bindPage, "LowSocClear")
			show: valid && showSetting(0, 1)
		}

		MbRangeSlider {
			description: qsTr("Low battery voltage")
			unit: "V"
			numOfDecimals: 1
			stepSize: 0.1
			lowColor: "indianred"
			highColor: "lightgreen"
			lowBind: Utils.path(bindPrefix, bindPage, "LowVoltage")
			highBind: Utils.path(bindPrefix, bindPage, "LowVoltageClear")
			show: valid && showSetting(0, 1)
		}

		MbRangeSlider {
			description: qsTr("High battery voltage")
			unit: "V"
			numOfDecimals: 1
			stepSize: 0.1
			lowColor: "lightgreen"
			highColor: "indianred"
			lowBind: Utils.path(bindPrefix, bindPage, "HighVoltageClear")
			highBind: Utils.path(bindPrefix, bindPage, "HighVoltage")
			show: valid && showSetting(0)
		}

		MbRangeSlider {
			description: qsTr("Low starter battery voltage")
			unit: "V"
			numOfDecimals: 1
			stepSize: 0.1
			lowColor: "indianred"
			highColor: "lightgreen"
			lowBind: Utils.path(bindPrefix, bindPage, "LowStarterVoltage")
			highBind: Utils.path(bindPrefix, bindPage, "LowStarterVoltageClear")
			show: valid && showSetting(0)
		}

		MbRangeSlider {
			description: qsTr("High starter battery voltage")
			unit: "V"
			numOfDecimals: 1
			stepSize: 0.1
			lowColor: "lightgreen"
			highColor: "indianred"
			lowBind: Utils.path(bindPrefix, bindPage, "HighStarterVoltageClear")
			highBind: Utils.path(bindPrefix, bindPage, "HighStarterVoltage")
			show: valid && showSetting(0)
		}

		MbSwitch {
			name: qsTr("Fuse blown")
			bind: Utils.path(bindPrefix, bindPage, "FuseBlown")
			show: valid && showSetting(0)
		}

		MbRangeSlider {
			description: qsTr("Low battery temperature")
			unit: "K"
			lowColor: "indianred"
			highColor: "lightgreen"
			lowBind: Utils.path(bindPrefix, bindPage, "LowBatteryTemperature")
			highBind: Utils.path(bindPrefix, bindPage, "LowBatteryTemperatureClear")
			show: valid && showSetting(0)
		}

		MbRangeSlider {
			description: qsTr("High battery temperature")
			unit: "K"
			lowColor: "lightgreen"
			highColor: "indianred"
			lowBind: Utils.path(bindPrefix, bindPage, "HighBatteryTemperatureClear")
			highBind: Utils.path(bindPrefix, bindPage, "HighBatteryTemperature")
			show: valid && showSetting(0)
		}
	}
}
