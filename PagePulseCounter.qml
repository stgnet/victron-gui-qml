import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root

	property variant service
	property string bindPrefix
	property string settingsBindPreffix: "com.victronenergy.settings/Settings/DigitalInput/" + inputNumber
	property variant units: ["m<sup>3</sup>", "L", "gal", "gal"]
	property int inputNumber: instance.valid ? instance.value : 0

	title: service.description
	summary: aggregate.item.text

	VBusItem {
		id: unit
		bind: Utils.path("com.victronenergy.settings/Settings/System/VolumeUnit")
	}

	VBusItem {
		id: instance
		bind: service.path("/DeviceInstance")
	}

	VBusItem {
		id: productName
		bind: service.path("/ProductName")
	}

	model: VisualItemModel {
		MbItemValue {
			id: aggregate
			description: qsTr("Aggregate")
			item.bind: service.path("/Aggregate")
			item.decimals: 0
			item.unit: unit.valid ? units[unit.value] : ""
		}

		MbSubMenu {
			id: setupMenu
			description: qsTr("Setup")
			subpage: Component {
				PagePulseCounterSetup {
					bindPrefix: root.settingsBindPreffix
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
