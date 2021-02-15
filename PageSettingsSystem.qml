import QtQuick 1.1
import "utils.js" as Utils
import com.victron.velib 1.0

MbPage {
	id: root

	property string bindPrefix: "com.victronenergy.settings"
	property string availableMonitors: availableBatteryServices.valid ? availableBatteryServices.value : ""
	property string autoSelectedMonitorName: autoSelectedBatteryService.valid ? autoSelectedBatteryService.value : "---"
	property VBusItem availableBatteryServices: VBusItem {bind: Utils.path("com.victronenergy.system", "/AvailableBatteryServices")}
	property VBusItem autoSelectedBatteryService: VBusItem {bind: Utils.path("com.victronenergy.system", "/AutoSelectedBatteryService")}
	property VBusItem acInput1: VBusItem {bind: Utils.path(bindPrefix, "/Settings/SystemSetup/AcInput1")}
	property VBusItem acInput2: VBusItem {bind: Utils.path(bindPrefix, "/Settings/SystemSetup/AcInput2")}

	property bool isGrid: acInput1.value === 1 || acInput2.value === 1
	property bool isShore: acInput1.value === 3 || acInput2.value === 3

	onAvailableMonitorsChanged: if (availableMonitors !== "") monitorOptions.possibleValues = getMonitorList()

	Component {
		id: mbOptionLoader

		MbOption {}
	}

	// As we don't know previously the key names of the json object
	// we need to get the list of keynames and then use it to get
	// the values
	function getMonitorList() {
		var fullList = []
		var jsonObject = JSON.parse(availableMonitors)
		var keylist = Object.keys(jsonObject)

		for (var i = 0; i < keylist.length; i++) {
			var params = {
				"description": jsonObject[keylist[i]],
				"value": keylist[i]
			}
			var option = mbOptionLoader.createObject(monitorOptions, params)
			fullList.push(option)
		}

		return fullList
	}

	model: VisualItemModel {
		// Note: these settings can also be used to add a icon / text to the
		// overview. Mind it that translation of these description can get long.
		// Futhermore there should be a enum defined for this. As it is not used
		// hide the options for now.

		MbItemOptions {
			id: systemName

			property variant defaultNames: ["", "Hub-1", "Hub-2", "Hub-3", "Hub-4", "ESS", qsTr("Vehicle"), qsTr("Boat")]
			property bool customName: defaultNames.indexOf(item.value) < 0

			description: qsTr("System name")
			unknownOptionText: qsTr("User defined")
			bind: Utils.path(bindPrefix, "/Settings/SystemSetup/SystemName")
			writeAccessLevel: User.AccessUser
			possibleValues: [
				MbOption { description: qsTr("Automatic"); value: systemName.defaultNames[0] },
				MbOption { description: systemName.defaultNames[1]; value: systemName.defaultNames[1] },
				MbOption { description: systemName.defaultNames[2]; value: systemName.defaultNames[2] },
				MbOption { description: systemName.defaultNames[3]; value: systemName.defaultNames[3] },
				MbOption { description: systemName.defaultNames[4]; value: systemName.defaultNames[4] },
				MbOption { description: systemName.defaultNames[5]; value: systemName.defaultNames[5] },
				MbOption { description: systemName.defaultNames[6]; value: systemName.defaultNames[6] },
				MbOption { description: systemName.defaultNames[7]; value: systemName.defaultNames[7] },
				MbOption { description: qsTr("User defined"); value: "custom" }
			]
		}

		MbEditBox {
			description: qsTr("User defined name")
			show: systemName.customName
			maximumLength: 20
			item.bind: Utils.path(bindPrefix, "/Settings/SystemSetup/SystemName")
			writeAccessLevel: User.AccessUser
		}

		// The systemcalc uses these values as well. Not available is defined
		// to the second out of device with a single input can be set to ignored.
		MbItemOptions {
			description: qsTr("AC input 1")
			bind: Utils.path(bindPrefix, "/Settings/SystemSetup/AcInput1")
			possibleValues: [
				MbOption {description: qsTr("Not available"); value: 0},
				MbOption {description: qsTr("Grid"); value: 1},
				MbOption {description: qsTr("Generator"); value: 2},
				MbOption {description: qsTr("Shore power"); value: 3}
			]
		}

		MbItemOptions {
			description: qsTr("AC input 2")
			bind: Utils.path(bindPrefix, "/Settings/SystemSetup/AcInput2")
			possibleValues: [
				MbOption {description: qsTr("Not available"); value: 0},
				MbOption {description: qsTr("Grid"); value: 1},
				MbOption {description: qsTr("Generator"); value: 2},
				MbOption {description: qsTr("Shore power"); value: 3}
			]
		}

		MbItemOptions {
			description: isGrid ? qsTr("Monitor for grid failure") : qsTr("Monitor for shore disconnect")
			show: isGrid || isShore
			bind: Utils.path(bindPrefix, "/Settings/Alarm/System/GridLost")
			possibleValues: [
				MbOption {description: qsTr("Disabled"); value: 0},
				MbOption {description: qsTr("Enabled"); value: 1}
			]
		}

		MbItemOptions {
			id: monitorOptions
			description: qsTr("Battery monitor")
			bind: Utils.path("com.victronenergy.settings", "/Settings/SystemSetup/BatteryService")
			unknownOptionText: qsTr("Unavailable monitor, set another")
		}

		MbItemText {
			text: qsTr("Auto selected: %1").arg(autoSelectedMonitorName)
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignLeft
			show: monitorOptions.value === "default"
		}

		MbSwitch {
			bind: Utils.path(bindPrefix, "/Settings/SystemSetup/HasDcSystem")
			name: qsTr("Has DC system")
		}

		MbSubMenu {
			id: mfd
			description: qsTr("Marine MFD App configuration")
			subpage: Component {
				PageSettingsBatteries {
					title: mfd.description
				}
			}
		}

		MbSubMenu {
			description: "System Status"
			show: user.accessLevel >= User.AccessSuperUser
			subpage: Component {
				PageSettingsSystemStatus {}
			}
		}
	}
}
