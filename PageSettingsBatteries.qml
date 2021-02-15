import QtQuick 1.1
import "utils.js" as Utils

MbPage {
	property string systemPrefix: "com.victronenergy.system"
	property string settingsPrefix: "com.victronenergy.settings"
	property VBusItem batteryItem: VBusItem { bind: Utils.path(systemPrefix, "/AvailableBatteries") }
	property VBusItem activeBatteryService: VBusItem { bind: Utils.path(systemPrefix, "/ActiveBatteryService") }
	property variant availableBatteries: getAvailableBatteries(batteryItem.value)

	title: qsTr("Battery measurements")
	model: Object.keys(availableBatteries)

	function getAvailableBatteries(v) {
		try {
			return JSON.parse(v)
		} catch(e) {
			return {}
		}
	}

	function batteryTitle(service_id) {
		var b = availableBatteries[service_id]
		if (b === null || b.name === null)
			return ""

		if (b.channel !== null && b.channel !== undefined) {
			if (b.type == "battery")
				return qsTr("%1 (Auxiliary measurement)").arg(b.name);
			return qsTr("%1 (Output %2)").arg(b.name).arg(b.channel+1);
		}

		return b.name
	}

	function isActiveBattery(modelData) {
		return activeBatteryService.valid && (activeBatteryService.value === modelData)
	}

	delegate: Component {
		MbSubMenu {
			id: menu

			property string configId: modelData.replace(/\./g, "_")
			property bool activeBattery: isActiveBattery(modelData)

			description: batteryTitle(modelData)
			item {
				bind: Utils.path(settingsPrefix, "/Settings/SystemSetup/Batteries/Configuration/", configId, "/Enabled")
				text: item.valid ? (item.value || activeBattery ? qsTr("Visible") : qsTr("Hidden")) : item.invalidText
			}

			subpage: Component {
				MbPage {
					title: menu.description
					model: VisualItemModel {
						MbItemValue {
							description: qsTr("Visible")
							item.value: qsTr("Active battery monitor")
							show: activeBattery
						}

						MbSwitch {
							name: qsTr("Visible")
							enabled: true
							show: !activeBattery
							bind: Utils.path(settingsPrefix, "/Settings/SystemSetup/Batteries/Configuration/", configId, "/Enabled")
						}

						MbEditBox {
							description: qsTr("Name")
							item.bind: Utils.path(settingsPrefix, "/Settings/SystemSetup/Batteries/Configuration/", configId, "/Name")
							show: item.valid
							maximumLength: 32
							enableSpaceBar: true
						}
					}
				}
			}
		}
	}
}
