import QtQuick 1.1

MbPage {
	id: root

	property variant service
	property string bindPrefix

	title: service.description
	summary: rpm.item.text

	model: VisualItemModel {

		MbItemValue {
			id: rpm
			description: qsTr("Motor RPM")
			item { bind: service.path("/Motor/RPM"); unit: "RPM" }
		}

		MbItemValue {
			description: qsTr("Motor temperature")
			item { bind: service.path("/Motor/Temperature"); unit: "°C" }
		}

		MbItemValue {
			description: qsTr("Power")
			item { bind: service.path("/Dc/0/Power"); unit: "W" }
		}

		MbItemValue {
			description: qsTr("Voltage")
			item { bind: service.path("/Dc/0/Voltage"); decimals: 2; unit: "V" }
		}

		MbItemValue {
			description: qsTr("Current")
			item { bind: service.path("/Dc/0/Current"); decimals: 2; unit: "A" }
		}

		MbItemValue {
			description: qsTr("Controller temperature")
			item { bind: service.path("/Controller/Temperature"); unit: "°C" }
		}

		MbSubMenu {
			id: deviceItem
			description: qsTr("Device")
			subpage: Component {
				PageDeviceInfo {
					title: deviceItem.description
					bindPrefix: root.bindPrefix
				}
			}
		}
	}
}
