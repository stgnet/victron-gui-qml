import QtQuick 1.1
import "utils.js" as Utils

MbPage {
	id: root
	property string bindPrefix

	model: VisualItemModel {

		MbItemValue {
			description: qsTr("VE.Bus Quirks")
			item.bind: service.path("/Quirks")
		}

		MbItemOptions {
			description: "Power Type"
			bind: service.path("/Ac/PowerMeasurementType")
			readonly: true
			possibleValues: [
				MbOption { value: 0; description: "Apparent power, phase masters" },
				MbOption { value: 1; description: "Real power, phase master, no snapshot" },
				MbOption { value: 2; description: "Real power, all devices, no snapshot" },
				MbOption { value: 3; description: "Real power, phase masters, snapshot" },
				MbOption { value: 4; description: "Real power, all devices, snapshot" }
			]
		}

		MbItemValue {
			description: "AC-IN1 to Inverter"
			item.bind: Utils.path(bindPrefix, "/AcIn1ToInverter")
		}

		MbItemValue {
			description: "AC-IN2 to Inverter"
			item.bind: Utils.path(bindPrefix, "/AcIn2ToInverter")
		}

		MbItemValue {
			description: "AC-IN1 to AC-OUT"
			item.bind: Utils.path(bindPrefix, "/AcIn1ToAcOut")
		}

		MbItemValue {
			description: "AC-IN2 to AC-OUT"
			item.bind: Utils.path(bindPrefix, "/AcIn2ToAcOut")
		}

		MbItemValue {
			description: "Inverter to AC-IN1"
			item.bind: Utils.path(bindPrefix, "/InverterToAcIn1")
		}

		MbItemValue {
			description: "Inverter to AC-IN2"
			item.bind: Utils.path(bindPrefix, "/InverterToAcIn2")
		}

		MbItemValue {
			description: "AC-OUT to AC-IN1"
			item.bind: Utils.path(bindPrefix, "/AcOutToAcIn1")
		}

		MbItemValue {
			description: "AC-OUT to AC-IN2"
			item.bind: Utils.path(bindPrefix, "/AcOutToAcIn2")
		}

		MbItemValue {
			description: "Inverter to AC-OUT"
			item.bind: Utils.path(bindPrefix, "/InverterToAcOut")
		}

		MbItemValue {
			description: "AC-OUT to Inverter"
			item.bind: Utils.path(bindPrefix, "/OutToInverter")
		}
	}
}
