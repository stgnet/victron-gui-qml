import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root

	property variant service
	property string bindPrefix
	property list<MbOption> temperatureTypes: [
		MbOption {description: qsTr("Battery"); value: 0},
		MbOption {description: qsTr("Fridge"); value: 1},
		MbOption {description: qsTr("Generic"); value: 2}
	]
	property VBusItem customName: VBusItem { bind: Utils.path(bindPrefix, "/CustomName") }

	title: getTitle()
	summary: temperature.item.valid ? temperature.item.text : status.valid ? status.text : "--"

	function getTitle()
	{
		if (customName.valid && customName.value !== "")
			return customName.value

		var inputNumber = devInstance.valid ? devInstance.value : ""
		var inputNumberStr = ""

		if (inputNumber !== "")
			inputNumberStr = " (" + inputNumber + ")"

		if (temperatureType.valid)
			return qsTr("%1 temperature sensor").arg(temperatureTypeText(temperatureType.value)) + inputNumberStr
		return service.description + inputNumberStr
	}

	function temperatureTypeText(value)
	{
		if (value < temperatureTypes.length)
			return temperatureTypes[value].description
		return qsTr("Unknown")
	}

	VBusItem {
		id: temperatureType
		bind: service.path("/TemperatureType")
	}

	VBusItem {
		id: devInstance
		bind: Utils.path(root.bindPrefix, "/DeviceInstance")
	}

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
				MbOption { description: qsTr("Unknown"); value: 4 }
			]
		}

		MbItemValue {
			id: temperature
			description: qsTr("Temperature")
			item.bind: service.path("/Temperature")
			item.unit: "°C"
		}

		MbSubMenu {
			id: setupMenu
			description: qsTr("Setup")
			subpage: Component {
				PageTemperatureSensorSetup {
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
