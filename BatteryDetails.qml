import QtQuick 1.1
import "utils.js" as Utils

Item {
	id: itemContainer
	property string bindPrefix
	property bool anyItemValid: false

	property VBusItemCheckValid modulesOnline: VBusItemCheckValid {
		bind: Utils.path(bindPrefix, "/System/NrOfModulesOnline")
		text: valid ? value + " " + qsTr("online") : invalidText
	}
	property VBusItemCheckValid modulesOffline: VBusItemCheckValid {
		bind: Utils.path(bindPrefix, "/System/NrOfModulesOffline")
		text: valid ? value + " " + qsTr("offline") : invalidText
	}
	property VBusItemCheckValid nrOfModulesBlockingCharge: VBusItemCheckValid {
		bind: Utils.path(bindPrefix, "/System/NrOfModulesBlockingCharge")
	}
	property VBusItemCheckValid nrOfModulesBlockingDischarge: VBusItemCheckValid {
		bind: Utils.path(bindPrefix, "/System/NrOfModulesBlockingDischarge")
	}
	property VBusItemCheckValid nrOfModulesOnline: VBusItemCheckValid {
		bind: Utils.path(bindPrefix, "/System/NrOfModulesOnline")
	}
	property VBusItemCheckValid nrOfModulesOffline: VBusItemCheckValid {
		bind: Utils.path(bindPrefix, "/System/NrOfModulesOffline")
	}
	property VBusItemCheckValid minCellVoltage: VBusItemCheckValid {
		bind: Utils.path(bindPrefix, "/System/MinCellVoltage")
	}
	property VBusItemCheckValid maxCellVoltage: VBusItemCheckValid {
		bind: Utils.path(bindPrefix, "/System/MaxCellVoltage")
	}
	property VBusItemCheckValid minCellTemperature: VBusItemCheckValid {
		bind: Utils.path(bindPrefix, "/System/MinCellTemperature")
		unit: "°C"
	}
	property VBusItemCheckValid maxCellTemperature: VBusItemCheckValid {
		bind: Utils.path(bindPrefix, "/System/MaxCellTemperature")
		unit: "°C"
	}
	property VBusItemCheckValid minVoltageCellId: VBusItemCheckValid {
		bind: Utils.path(bindPrefix, "/System/MinVoltageCellId")
	}
	property VBusItemCheckValid maxVoltageCellId: VBusItemCheckValid {
		bind: Utils.path(bindPrefix, "/System/MaxVoltageCellId")
	}
	property VBusItemCheckValid minTemperatureCellId: VBusItemCheckValid {
		bind: Utils.path(bindPrefix, "/System/MinTemperatureCellId")
	}
	property VBusItemCheckValid maxTemperatureCellId: VBusItemCheckValid {
		bind: Utils.path(bindPrefix, "/System/MaxTemperatureCellId")
	}
	property VBusItemCheckValid installedCapacity: VBusItemCheckValid {
		bind: Utils.path(bindPrefix, "/InstalledCapacity")
	}
}
