import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	property string devicePath
	property int hub4PhaseCompensation: 1
	property int hub4PhaseSplit: 2
	property string serviceType: classAndVrmInstanceItem.valid ? classAndVrmInstanceItem.value.split(":")[0] : ""
	property int deviceInstance: classAndVrmInstanceItem.valid ? classAndVrmInstanceItem.value.split(":")[1] : 0
	property VBusItem classAndVrmInstanceItem: VBusItem { bind: Utils.path(devicePath, "/ClassAndVrmInstance") }
	property VBusItem multiPhaseSupport: VBusItem {	bind: Utils.path(devicePath, "/SupportMultiphase") }
	property VBusItem isMultiPhaseItem: VBusItem { bind: Utils.path(devicePath, "/IsMultiphase") }

	function updateRole(role)
	{
		classAndVrmInstanceItem.setValue(role + ":" + deviceInstance)
	}

	model: VisualItemModel {
		MbItemOptions {
			id: mode
			description: qsTr("Role")
			localValue: serviceType
			possibleValues: [
				MbOption { description: qsTr("Grid meter"); value: "grid" },
				MbOption { description: qsTr("PV inverter"); value: "pvinverter" },
				MbOption { description: qsTr("Generator"); value: "genset" }
			]
			onOptionSelected: updateRole(value)
		}

		MbItemOptions {
			description: qsTr("Position")
			bind: Utils.path(devicePath, "/Position")
			show: serviceType === "pvinverter"
			possibleValues: [
				MbOption { description: qsTr("AC Input 1"); value: 0 },
				MbOption { description: qsTr("AC Input 2"); value: 2 },
				MbOption { description: qsTr("AC Output"); value: 1 }
			]
		}

		MbItemOptions {
			description: qsTr("Phase type")
			bind: Utils.path(devicePath, "/IsMultiphase")
			readonly: !userHasWriteAccess || !multiPhaseSupport.value
			possibleValues: [
				MbOption { description: qsTr("Single phase"); value: 0 },
				MbOption { description: qsTr("Multi phase"); value: 1 }
			]
		}

		MbSwitch {
			id: pvOnL2
			name: qsTr("PV inverter on phase 2")
			bind: Utils.path(devicePath, "_S/Enabled")
			show: multiPhaseSupport.valid &&
				  multiPhaseSupport.value &&
				  isMultiPhaseItem.valid &&
				  !isMultiPhaseItem.value &&
				  serviceType === "grid"
		}

		MbItemOptions {
			description: qsTr("PV inverter on phase 2 Position")
			bind: Utils.path(devicePath, "_S/Position")
			show: pvOnL2.checked
			possibleValues: [
				MbOption { description: qsTr("AC Input 1"); value: 0 },
				MbOption { description: qsTr("AC Input 2"); value: 2 },
				MbOption { description: qsTr("AC Output"); value: 1 }
			]
		}
	}
}
