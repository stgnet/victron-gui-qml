import QtQuick 1.1

MbPage {
	model: VisualItemModel {
		MbItemOptions {
			description: qsTr("Synchronize VE.Bus SOC with battery")
			bind: "com.victronenergy.system/Control/VebusSoc"
			readonly: true
			possibleValues: [
				MbOption { description: qsTr("Off"); value: 0 },
				MbOption { description: qsTr("On"); value: 1 }
			]
		}

		MbItemOptions {
			description: qsTr("Use solar charger current to improve VE.Bus SOC")
			bind: "com.victronenergy.system/Control/ExtraBatteryCurrent"
			readonly: true
			possibleValues: [
				MbOption { description: qsTr("Off"); value: 0 },
				MbOption { description: qsTr("On"); value: 1 }
			]
		}

		MbItemOptions {
			description: qsTr("Solar charger voltage control")
			bind: "com.victronenergy.system/Control/SolarChargeVoltage"
			readonly: true
			possibleValues: [
				MbOption { description: qsTr("Off"); value: 0 },
				MbOption { description: qsTr("On"); value: 1 }
			]
		}

		MbItemOptions {
			description: qsTr("Solar charger current control")
			bind: "com.victronenergy.system/Control/SolarChargeCurrent"
			readonly: true
			possibleValues: [
				MbOption { description: qsTr("Off"); value: 0 },
				MbOption { description: qsTr("On"); value: 1 }
			]
		}

		MbItemOptions {
			description: qsTr("BMS control")
			bind: "com.victronenergy.system/Control/BmsParameters"
			readonly: true
			possibleValues: [
				MbOption { description: qsTr("Off"); value: 0 },
				MbOption { description: qsTr("On"); value: 1 }
			]
		}
	}
}
