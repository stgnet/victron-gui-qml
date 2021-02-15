import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	title: qsTr("Energy meters")
	model: Utils.stringToArray(deviceIdsItem.value)

	property string basePath: "com.victronenergy.settings/Settings/CGwacs"
	property VBusItem deviceIdsItem: VBusItem { bind: "com.victronenergy.settings/Settings/CGwacs/DeviceIds" }

	function getDescription(customName, productName) {
		if (customName !== undefined && customName.length > 0)
			return customName;
		if (productName !== undefined && productName.length > 0)
			return productName;
		return '--'
	}

	function getModeName(serviceType) {
		switch (serviceType)
		{
		case "grid":
			return qsTr("Grid meter");
		case "pvinverter":
			return qsTr("PV inverter");
		case "genset":
			return qsTr("Generator");
		default:
			return '--';
		}
	}

	function getMenuName(serviceType, l2ServiceType)
	{
		var result = getModeName(serviceType)
		if (l2ServiceType !== undefined && l2ServiceType.length > 0)
			result += " + " + getModeName(l2ServiceType)
		return result
	}

	delegate: Component {
		MbSubMenu {
			id: menu
			description: getDescription(customNameItem.value, modelData)
			item.value: getMenuName(serviceType.value, l2ServiceType.value)

			property string devicePath: Utils.path("com.victronenergy.settings/Settings/Devices/cgwacs_", modelData)
			property VBusItem customNameItem: VBusItem { bind: Utils.path(devicePath, "/CustomName") }
			property VBusItem serviceType: VBusItem { bind: Utils.path(devicePath, "/ServiceType") }
			property VBusItem l2ServiceType: VBusItem { bind: Utils.path(devicePath, "/L2/ServiceType") }

			subpage: Component {
				PageSettingsCGwacs {
					title: menu.description
					devicePath: menu.devicePath
				}
			}
		}
	}
}
