import QtQuick 1.1
import "utils.js" as Utils

VisualItemModel {
	property int nrOfPhases: phases.valid ? phases.value : 3
	property string gensetStatus: _gensetStatus.text
	property string acTotalPower: calculatePower()
	property variant summary: _gensetStatus.valid ? [gensetStatus, acTotalPower] : qsTr("Not connected")
	property VBusItem phases:  VBusItem { id: phases; bind: service.path("/NrOfPhases") }

	function calculatePower() {
		var power = 0
		if (powerL1.item.valid)
			power += powerL1.item.value
		if (powerL2.item.valid && nrOfPhases > 1)
			power += powerL2.item.value
		if (powerL3.item.valid && nrOfPhases > 2)
			power += powerL3.item.value
		return (power / 1000).toFixed(2) +"kW"
	}

	function formatStatus(text, value)
	{
		return text + " (" + value.toString() + ")";
	}

	MbItemOptions {
		description: qsTr("Mode")
		readonly: !_gensetStatus.valid

		possibleValues: [
			MbOption { description: qsTr("On"); value: 1 },
			MbOption { description: qsTr("Off"); value: 0 },
			MbOption { description: qsTr("Auto start/stop"); value: 2 }
		]
		value: autoStartStopItem.value === 1 ? 2 : modeItem.value
		onLocalValueChanged: {
			if (localValue === 0) {
				autoStartStopItem.setValue(0)
				modeItem.setValue(0)
			}
			if (localValue === 1) {
				if (autoStart.value === 0){
					toast.createToast(qsTr("AutoStart functionality is currently disabled, enable it on the genset panel in"
										   + " order to start the genset from this menu."), 7000, "icon-info-active")
				return
				}
				autoStartStopItem.setValue(0)
				modeItem.setValue(1)
			}
			if (localValue === 2) {
				autoStartStopItem.setValue(1)
			}
		}
		VBusItem {
			id: modeItem
			bind: service.path("/Start")
		}
		VBusItem {
			id: autoStartStopItem
			bind: "com.victronenergy.settings/Settings/Services/FischerPandaAutoStartStop"
		}
		VBusItem {
			id: autoStart
			bind: service.path("/AutoStart")
		}
	}

	MbItemOptions {
		id: _gensetStatus
		description: qsTr("Status")
		bind: service.path("/StatusCode")
		readonly: true
		possibleValues: [
			MbOption { description: qsTr("Standby"); value: 0 },
			MbOption { description: formatStatus(qsTr("Startup"), 1); value: 1 },
			MbOption { description: formatStatus(qsTr("Startup"), 2); value: 2 },
			MbOption { description: formatStatus(qsTr("Startup"), 3); value: 3 },
			MbOption { description: formatStatus(qsTr("Startup"), 4); value: 4 },
			MbOption { description: formatStatus(qsTr("Startup"), 5); value: 5 },
			MbOption { description: formatStatus(qsTr("Startup"), 6); value: 6 },
			MbOption { description: formatStatus(qsTr("Startup"), 7); value: 7 },
			MbOption { description: qsTr("Running"); value: 8 },
			MbOption { description: qsTr("Stopping"); value: 9 },
			MbOption { description: qsTr("Error"); value: 10 }
		]
	}

	MbItemFpGensetError {
		description: qsTr("Error Code")
		bind: show ? service.path("/ErrorCode") : ""
		nrOfPhases: nrOfPhases
	}

	MbOK {
		description: qsTr("Clear error")
		value: qsTr("Press to clear")
		cornerMark: true
		show: _gensetStatus.value === 10
		onClicked: startItem.setValue(0)
		VBusItem {
			id: startItem
			bind: service.path("/Start")
		}
	}

	MbItemRow {
		description: nrOfPhases > 1 ? qsTr("AC Phase L1") :  qsTr("AC")
		values: [
			MbTextBlock { item.bind: service.path("/Ac/L1/Voltage"); width: 80; height: 25 },
			MbTextBlock { item.bind: service.path("/Ac/L1/Current"); width: 100; height: 25 },
			MbTextBlock {
				id: powerL1;
				width: 120
				height: 25
				item.bind: service.path("/Ac/L1/Power")
				item.unit: "kW"
				item.decimals: 2
				item.text: (item.value / 1000).toFixed(2) + item.unit
			}
		]
	}

	MbItemRow {
		description: qsTr("AC Phase L2")
		show: nrOfPhases > 1
		values: [
			MbTextBlock { item.bind: service.path("/Ac/L2/Voltage"); width: 80; height: 25 },
			MbTextBlock { item.bind: service.path("/Ac/L2/Current"); width: 100; height: 25 },
			MbTextBlock {
				id: powerL2
				width: 120
				height: 25
				item.bind: service.path("/Ac/L2/Power")
				item.unit: "kW"
				item.decimals: 2
				item.text: (item.value / 1000).toFixed(item.decimals) + item.unit
			}
		]
	}

	MbItemRow {
		description: qsTr("AC Phase L3")
		show: nrOfPhases > 2
		values: [
			MbTextBlock { item.bind: service.path("/Ac/L3/Voltage"); width: 80; height: 25 },
			MbTextBlock { item.bind: service.path("/Ac/L3/Current"); width: 100; height: 25 },
			MbTextBlock {
				id: powerL3
				width: 120
				height: 25
				item.bind: service.path("/Ac/L3/Power")
				item.unit: "kW"
				item.decimals: 2
				item.text: (item.value / 1000).toFixed(item.decimals) + item.unit
			}
		]
	}

	MbSubMenu {
		description: qsTr("Auto start/stop")
		show: autoStartStopItem.value === 1
		subpage: Component {
			PageGenerator {
				title: qsTr("Auto start/stop")
				settingsBindPrefix: "com.victronenergy.settings/Settings/FischerPanda0"
				startStopBindPrefix: "com.victronenergy.generator.startstop0/FischerPanda0"
				allowDisableAutostart: false
			}
		}
	}

	MbSubMenu {
		description: qsTr("Engine")
		subpage: Component {
			MbPage {
				title: qsTr("Engine")
				model: VisualItemModel {
					MbItemValue {
						description: qsTr("Speed")
						item.bind: service.path("/Engine/Speed")
					}

					MbItemValue {
						description: qsTr("Load")
						item.bind: service.path("/Engine/Load")
					}

					MbItemValue {
						description: qsTr("Coolant temperature")
						item.bind: service.path("/Engine/CoolantTemperature")
						item.unit: "°C"
					}

					MbItemValue {
						description: qsTr("Exhaust temperature")
						item.bind: service.path("/Engine/ExaustTemperature")
						item.unit: "°C"
					}

					MbItemValue {
						description: qsTr("Winding temperature")
						item.bind: service.path("/Engine/WindingTemperature")
						item.unit: "°C"
					}

					MbItemValue {
						description: qsTr("Operating time")
						item.bind: service.path("/Engine/OperatingHours")
						item.text: Utils.secondsToString(item.value)
					}

					MbItemValue {
						description: qsTr("Starter battery voltage")
						item.bind: service.path("/StarterVoltage")
					}
				}
			}
		}
	}

	MbSubMenu {
		description: qsTr("Device")
		subpage: Component {
			PageDeviceInfo {
				title: qsTr("Device")
				bindPrefix: root.bindPrefix
			}
		}
	}
}

