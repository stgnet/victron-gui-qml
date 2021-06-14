import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils
import "tanksensor.js" as TankSensor

MbPage {
	id: root

	property variant service
	property string bindPrefix
	property VBusItem volumeUnit: VBusItem { bind: "com.victronenergy.settings/Settings/System/VolumeUnit" }

	title: service.description
	summary: level.item.valid ? level.item.text : status.valid ? status.text : "--"

	model: VisualItemModel {
		MbItemOptions {
			id: status
			description: qsTr("Status")
			bind: service.path("/Status")
			readonly: true
			show: item.valid
			possibleValues: [
				MbOption { description: qsTr("Ok"); value: 0 },
				MbOption { description: qsTr("Disconnected"); value: 1 },
				MbOption { description: qsTr("Short circuited"); value: 2 },
				MbOption { description: qsTr("Reverse polarity"); value: 3 },
				MbOption { description: qsTr("Unknown"); value: 4 },
				MbOption { description: qsTr("Error"); value: 5 }
			]
		}

		MbItemValue {
			id: level
			description: qsTr("Level")
			item.bind: service.path("/Level")
			item.unit: "%"
		}

		MbItemValue {
			id: remaining
			description: qsTr("Remaining")
			item {
				bind: service.path("/Remaining")
				text: TankSensor.formatVolume(volumeUnit.value, item.value)
			}
		}

		MbItemAlarm {
			description: qsTr("Low level alarm")
			bind: service.path("/Alarms/Low/State")
			show: valid
		}

		MbItemAlarm {
			description: qsTr("High level alarm")
			bind: service.path("/Alarms/High/State")
			show: valid
		}

		MbSubMenu {
			id: setupMenu
			description: qsTr("Setup")
			subpage: Component {
				PageTankSetup {
					title: setupMenu.description
					bindPrefix: root.bindPrefix
				}
			}
		}

		MbSubMenu {
			id: deviceMenu
			description: qsTr("Device")
			subpage: Component {
				PageDeviceInfo {
					title: deviceMenu.description
					bindPrefix: root.bindPrefix
				}
			}
		}
	}
}
