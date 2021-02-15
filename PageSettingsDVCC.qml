import QtQuick 1.1
import "utils.js" as Utils

MbPage {
	property VBusItem maxChargeCurrent: VBusItem {bind: Utils.path("com.victronenergy.settings", "/Settings/SystemSetup/MaxChargeCurrent")}
	property variant availableSensors: availableTemperatureSensors.valid ? availableTemperatureSensors.value : {}
	property VBusItem availableTemperatureSensors: VBusItem {bind: Utils.path("com.victronenergy.system", "/AvailableTemperatureServices")}
	property VBusItem autoSelectedTemperatureService: VBusItem {bind: Utils.path("com.victronenergy.system", "/AutoSelectedTemperatureService")}

	onAvailableSensorsChanged: updateTemperatureSensorList(sensorOptions, availableSensors)

	Component {
		id: mbOptionLoader

		MbOption {}
	}

	function updateTemperatureSensorList(parent, sensorInfo) {
		var options = []
		for (var i in sensorInfo) {
			var params = {
				"description": sensorInfo[i],
				"value": i
			}
			var option = mbOptionLoader.createObject(parent, params)
			options.push(option)
		}
		parent.possibleValues = options
	}

	model: VisualItemModel {
		MbItemText {
			text: qsTr("<b>CAUTION:</b> Read the manual before adjusting")
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignLeft
			show: dvccSwitch.userHasWriteAccess
		}

		MbSwitchForced {
			id: dvccSwitch
			name: qsTr("DVCC")
			item.bind: Utils.path(bindPrefix, "/Settings/Services/Bol")
			onCheckedChanged: {
				if (item.valid && !checked) {
					toast.createToast("Make sure to also reset the VE.Bus system after disabling DVCC.", 5000)
				}
			}
		}

		MbSwitch {
			function edit() {
				maxChargeCurrent.setValue(maxChargeCurrent.value < 0 ? 50 : -1)
			}

			id: maxChargeCurrentSwitch
			name: qsTr("Limit charge current")
			checked: maxChargeCurrent.value >= 0
			enabled: userHasWriteAccess
			show: dvccSwitch.checked
		}

		MbSpinBox {
			id: startValue
			description: "Maximum charge current"
			bind: maxChargeCurrent.bind
			unit: "A"
			numOfDecimals: 0
			stepSize: 1
			min: 0
			show: maxChargeCurrentSwitch.show && maxChargeCurrentSwitch.checked
		}

		MbSwitchForced {
			name: qsTr("SVS - Shared voltage sense")
			item.bind: Utils.path(bindPrefix, "/Settings/SystemSetup/SharedVoltageSense")
			show: dvccSwitch.checked
		}

		MbSwitchForced {
			id: sts
			name: qsTr("STS - Shared temperature sense")
			item.bind: Utils.path(bindPrefix, "/Settings/SystemSetup/SharedTemperatureSense")
			show: dvccSwitch.checked
		}

		MbItemOptions {
			id: sensorOptions
			show: sts.checked && dvccSwitch.checked
			description: qsTr("Temperature sensor")
			bind: Utils.path("com.victronenergy.settings", "/Settings/SystemSetup/TemperatureService")
			unknownOptionText: qsTr("Unavailable sensor, set another")
		}

		MbItemText {
			text: qsTr("Used sensor: %1").arg(autoSelectedTemperatureService.text)
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignLeft
			show: sensorOptions.value === "default" && sts.checked && dvccSwitch.checked
		}

		MbSwitch {
			id: sccsSwitch
			name: qsTr("SCS - Shared current sense")
			bind: Utils.path(bindPrefix, "/Settings/SystemSetup/BatteryCurrentSense")
			show: dvccSwitch.checked
		}

		MbItemOptions {
			description: qsTr("SCS status")
			bind: "com.victronenergy.system/Control/BatteryCurrentSense"
			show: sccsSwitch.show && sccsSwitch.checked
			readonly: true
			possibleValues: [
				MbOption { description: qsTr("Disabled"); value: 0 },
				MbOption { description: qsTr("Disabled (External control)"); value: 1 },
				MbOption { description: qsTr("Disabled (no chargers)"); value: 2 },
				MbOption { description: qsTr("Disabled (no battery monitor)"); value: 3 },
				MbOption { description: qsTr("Active"); value: 4 }
			]
		}
	}
}
