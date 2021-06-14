import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	property string bindPrefix: "com.victronenergy.settings/Settings/Fronius"
	property VBusItem inverterIdsItem: VBusItem { bind: Utils.path(bindPrefix, "/InverterIds") }

	title: qsTr("Inverters")
	model: Utils.stringToArray(inverterIdsItem.value)

	function convertPhase(phase)
	{
		if (phase === undefined)
			return '--';
		if (phase === 0)
			return qsTr("MP");
		return "L" + phase;
	}

	function convertPosition(pos)
	{
		switch (pos) {
		case 0:
			return qsTr("In1");
		case 1:
			return qsTr("Out");
		case 2:
			return qsTr("In2");
		default:
			return '--';
		}
	}

	function getDescription(customName, serialNumber)
	{
		if (customName !== undefined && customName.length > 0)
			return customName;
		if (serialNumber !== undefined && serialNumber.length > 0)
			return serialNumber;
		return '--'
	}

	delegate: Component {
		MbSubMenu {
			id: menu

			property string uniqueId: modelData
			property string inverterPath: Utils.path(bindPrefix, "/Inverters/", uniqueId)
			property VBusItem customNameItem: VBusItem { bind: Utils.path(inverterPath, "/CustomName") }
			property VBusItem phaseItem: VBusItem { bind: Utils.path(inverterPath, "/Phase") }
			property VBusItem positionItem: VBusItem { bind: Utils.path(inverterPath, "/Position") }
			property VBusItem serialNumberItem: VBusItem { bind: Utils.path(inverterPath, "/SerialNumber") }

			// Note: the names of all children of /Settings/Fronius/Inverters
			// start with an 'I', which is not part of the uniqueId of the
			// inverter, so we strip it here.
			description: getDescription(customNameItem.value, serialNumberItem.value)
			item.text: qsTr("AC") + "-" + convertPosition(positionItem.value) + " " + convertPhase(phaseItem.value)
			item.textValid: true

			subpage: Component {
				PageSettingsFroniusInverter {
					title: menu.description
					uniqueId: menu.uniqueId
				}
			}
		}
	}
}
