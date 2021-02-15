import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	property string uniqueId
	property string bindPrefix: Utils.path("com.victronenergy.settings/Settings/Fronius/Inverters/", uniqueId)
	property VBusItem phaseCountItem: VBusItem { bind: Utils.path(bindPrefix, "/PhaseCount") }
	property int phaseCount: phaseCountItem.valid ? phaseCountItem.value : 1

	VBusItem {
		id: phaseItem
		bind: Utils.path(bindPrefix, "/Phase")
	}

	model: VisualItemModel {
		MbItemOptions {
			description: qsTr("Position")
			bind: Utils.path(bindPrefix, "/Position")
			possibleValues: [
				MbOption { description: qsTr("AC Input 1"); value: 0 },
				MbOption { description: qsTr("AC Input 2"); value: 2 },
				MbOption { description: qsTr("AC Output"); value: 1 }
			]
		}

		MbItemValue {
			description: qsTr("Phase")
			show: phaseCount > 1
			item.value: "Multiphase"
		}

		MbItemOptions {
			description: qsTr("Phase")
			bind: Utils.path(bindPrefix, "/Phase")
			show: phaseCount == 1
			possibleValues: [
				MbOption { description: qsTr("L1"); value: 1; readonly: phaseCount > 1 },
				MbOption { description: qsTr("L2"); value: 2; readonly: phaseCount > 1 },
				MbOption { description: qsTr("L3"); value: 3; readonly: phaseCount > 1 },
				MbOption { description: qsTr("Split-phase (L1+L2)"); value: 0 }
			]
		}

		MbItemNoYes {
			description: qsTr("Show")
			bind: Utils.path(bindPrefix, "/IsActive")
		}
	}
}
