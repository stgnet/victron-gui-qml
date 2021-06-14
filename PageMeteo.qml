import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root

	property variant service
	property string bindPrefix

	property VBusItem deviceInstance: VBusItem { bind: Utils.path(bindPrefix, "/DeviceInstance") }
	property string settingsPrefix: Utils.path("com.victronenergy.settings/Settings/Service/meteo/", deviceInstance.value)

	title: service.description
	summary: irradiance.item.text

	model: VisualItemModel {
		MbItemValue {
			id: irradiance
			description: qsTr("Irradiance")
			item.bind: service.path("/Irradiance")
			item.unit: "W/m2"
			item.decimals: 1
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Cell temperature")
			item.bind: service.path("/CellTemperature")
			item.unit: "°C"
			item.decimals: 1
			show: item.valid
		}

		MbItemValue {
			description: qsTr("External temperature")
			item.bind: service.path("/ExternalTemperature")
			item.unit: "°C"
			item.decimals: 1
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Wind speed")
			item.bind: service.path("/WindSpeed")
			item.unit: "m/s"
			item.decimals: 1
			show: item.valid
		}

		MbSubMenu {
			id: settingsMenu
			description: qsTr("Settings")
			subpage: Component {
				PageMeteoSettings {
					title: settingsMenu.description
					meteoSettingsPrefix: root.settingsPrefix
				}
			}
		}
	}
}
