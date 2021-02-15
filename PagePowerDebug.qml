import QtQuick 1.1
import "utils.js" as Utils

MbPage {
	id: root
	title: "Power of hub2"

	property variant service
	property string qwacsPvInverterPrefix: "com.victronenergy.pvinverter.qwacs_di1"
	property string sensorsPvInverterPrefix: "com.victronenergy.pvinverter.vebusacsensor_output"
	property string vebusPrefix: "com.victronenergy.vebus.ttyO1"
	property int rowWidth: 70

	QtObject {
		id: sensorPvInverter
		property VBusItem powerL1: VBusItem { bind: Utils.path(sensorsPvInverterPrefix, "/Ac/L1/Power") }
		property VBusItem powerL2: VBusItem { bind: Utils.path(sensorsPvInverterPrefix,"/Ac/L2/Power") }
		property VBusItem powerL3: VBusItem { bind: Utils.path(sensorsPvInverterPrefix, "/Ac/L3/Power") }
	}

	QtObject {
		id: qwacsPvInverter
		property VBusItem powerL1: VBusItem { bind: Utils.path(qwacsPvInverterPrefix, "/Ac/L1/Power") }
		property VBusItem powerL2: VBusItem { bind: Utils.path(qwacsPvInverterPrefix, "/Ac/L2/Power") }
		property VBusItem powerL3: VBusItem { bind: Utils.path(qwacsPvInverterPrefix, "/Ac/L3/Power") }
		property VBusItem currentL1: VBusItem { bind: Utils.path(qwacsPvInverterPrefix, "/Ac/L1/Current") }
		property VBusItem currentL2: VBusItem { bind: Utils.path(qwacsPvInverterPrefix, "/Ac/L2/Current") }
		property VBusItem currentL3: VBusItem { bind: Utils.path(qwacsPvInverterPrefix, "/Ac/L3/Current") }
		property VBusItem voltageL1: VBusItem { bind: Utils.path(qwacsPvInverterPrefix, "/Ac/L1/Voltage") }
		property VBusItem voltageL2: VBusItem { bind: Utils.path(qwacsPvInverterPrefix, "/Ac/L2/Voltage") }
		property VBusItem voltageL3: VBusItem { bind: Utils.path(qwacsPvInverterPrefix, "/Ac/L3/Voltage") }
		property string apperentL1: apparentPower(currentL1, voltageL1)
		property string apperentL2: apparentPower(currentL2, voltageL2)
		property string apperentL3: apparentPower(currentL3, voltageL3)
	}

	QtObject {
		id: acOut
		property VBusItem powerL1: VBusItem { bind: Utils.path(vebusPrefix, "/Ac/Out/L1/P") }
		property VBusItem powerL2: VBusItem { bind: Utils.path(vebusPrefix, "/Ac/Out/L2/P") }
		property VBusItem powerL3: VBusItem { bind: Utils.path(vebusPrefix, "/Ac/Out/L3/P") }
		property VBusItem apparentL1: VBusItem { bind: Utils.path(vebusPrefix, "/Ac/Out/L1/S") }
		property VBusItem apparentL2: VBusItem { bind: Utils.path(vebusPrefix, "/Ac/Out/L2/S") }
		property VBusItem apparentL3: VBusItem { bind: Utils.path(vebusPrefix, "/Ac/Out/L3/S") }
	}

	function powerDiff(a, b) {
		if (!a.valid || !b.valid)
			return "---"
		return (a.value - b.value).toFixed(0) + "W"
	}

	function apparentPower(V, I) {
		if (!V.valid || !I.valid)
			return "---"
		return (V.value * I.value).toFixed(0) + "VA"
	}

	model: VisualItemModel {
		MbItemRow {
			description: qsTr("P")
			values: [
				MbTextValueSmall { text: "AC Out"; width: rowWidth },
				MbTextValueSmall { text: "AC Out"; width: rowWidth },
				MbTextValueSmall { text: "Qwacs"; width: rowWidth },
				MbTextValueSmall { text: "Qwacs"; width: rowWidth },
				MbTextValueSmall { text: "Sensors"; width: rowWidth },
				MbTextValueSmall { text: "Diff"; width: rowWidth }
			]
		}

		MbItemRow {
			description: qsTr("L1")
			values: [
				MbTextValueSmall { text: acOut.powerL1.uiText; width: rowWidth },
				MbTextValueSmall { text: acOut.apparentL1.uiText; width: rowWidth },
				MbTextValueSmall { text: qwacsPvInverter.powerL1.uiText; width: rowWidth },
				MbTextValueSmall { text: qwacsPvInverter.apperentL1; width: rowWidth },
				MbTextValueSmall { text: sensorPvInverter.powerL1.uiText; width: rowWidth },
				MbTextValueSmall { text: powerDiff(sensorPvInverter.powerL1, qwacsPvInverter.powerL1); width: rowWidth }
			]
		}

		MbItemRow {
			description: qsTr("L2")
			values: [
				MbTextValueSmall { text: acOut.powerL2.uiText; width: rowWidth },
				MbTextValueSmall { text: acOut.apparentL2.uiText; width: rowWidth },
				MbTextValueSmall { text: qwacsPvInverter.powerL2.uiText; width: rowWidth },
				MbTextValueSmall { text: qwacsPvInverter.apperentL2; width: rowWidth },
				MbTextValueSmall { text: sensorPvInverter.powerL2.uiText; width: rowWidth },
				MbTextValueSmall { text: powerDiff(sensorPvInverter.powerL2, qwacsPvInverter.powerL2); width: rowWidth }
			]
		}

		MbItemRow {
			description: qsTr("L3")
			values: [
				MbTextValueSmall { text: acOut.powerL3.uiText; width: rowWidth },
				MbTextValueSmall { text: acOut.apparentL3.uiText; width: rowWidth },
				MbTextValueSmall { text: qwacsPvInverter.powerL3.uiText; width: rowWidth },
				MbTextValueSmall { text: qwacsPvInverter.apperentL3; width: rowWidth },
				MbTextValueSmall { text: sensorPvInverter.powerL3.uiText; width: rowWidth },
				MbTextValueSmall { text: powerDiff(sensorPvInverter.powerL3, qwacsPvInverter.powerL3); width: rowWidth }
			]
		}
	}
}
