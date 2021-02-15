import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	id: root

	property variant service

	model: VisualItemModel {
		MbItemOptions {
			id: networkModeEnabled
			description: qsTr("Networked")
			bind: root.service.path("/Link/NetworkMode")
			value: valid ? (item.value & 1) : localValue
			readonly: true
			show: valid
			possibleValues:[
				MbOption { description: qsTr("No"); value: 0 },
				MbOption { description: qsTr("Yes"); value: 1}
			]
		}

		MbItemOptions {
			description: qsTr("Network status")
			bind: root.service.path("/Link/NetworkStatus")
			readonly: true
			show: valid
			possibleValues:[
				MbOption { description: qsTr("Slave"); value: 0 },
				MbOption { description: qsTr("Group Master"); value: 1 },
				MbOption { description: qsTr("Instance Master"); value: 2 },
				MbOption { description: qsTr("Group & Instance Master"); value: 3 },
				MbOption { description: qsTr("Standalone"); value: 4}
			]
		}

		MbItemOptions {
			id: networkModeMode
			description: qsTr("Mode setting")
			bind: root.service.path("/Link/NetworkMode")
			value: valid ? (item.value & 0xE) : localValue
			readonly: true
			show: valid && networkModeEnabled.value
			possibleValues:[
				MbOption { description: qsTr("Standalone"); value: 0 },
				MbOption { description: qsTr("Charge"); value: 2 },
				MbOption { description: qsTr("External control"); value: 4 },
				MbOption { description: qsTr("Charge & HUB-1"); value: 6 },
				MbOption { description: qsTr("BMS"); value: 8 },
				MbOption { description: qsTr("Charge & BMS"); value: 0xA },
				MbOption { description: qsTr("Ext. Control & BMS"); value: 0xC },
				MbOption { description: qsTr("Charge, Hub-1 & BMS"); value: 0xE}
			]
		}

		MbItemOptions {
			description: qsTr("Master setting")
			bind: root.service.path("/Link/NetworkMode")
			value: valid ? (item.value & 0x30) : localValue
			readonly: true
			show: valid && networkModeEnabled.value && value > 0x00
			possibleValues:[
				MbOption { description: qsTr("Slave"); value: 0x00 },
				MbOption { description: qsTr("Group master"); value: 0x10 },
				MbOption { description: qsTr("Charge master"); value: 0x20 },
				MbOption { description: qsTr("Group & Charge master"); value: 0x30}
			]
		}

		MbItemValue {
			description: qsTr("Charge voltage")
			item.bind: root.service.path("/Link/ChargeVoltage")
			show: item.valid && networkModeEnabled.value > 0 && (networkModeMode.value & 0x04)
		}

		MbItemValue {
			description: qsTr("Charge current")
			item.bind: root.service.path("/Link/ChargeCurrent")
			show: item.valid && networkModeEnabled.value > 0 && (networkModeMode.value & 0x08)
		}

		MbItemNoYes {
			id: bmsControlled
			description: qsTr("BMS Controlled")
			bind: root.service.path("/Settings/BmsPresent")
			readonly: true
			show: valid
		}

		MbItemText {
			text: qsTr("BMS control is enabled automatically when a BMS is present. Reset it if the system configuration changed or if there is no BMS present.")
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignHCenter
			show: bmsControlled.value === 1
		}

		MbOK {
			description: qsTr("BMS control")
			value: qsTr("Press to reset")
			show: bmsControlled.value === 1
			cornerMark: true
			onClicked: bmsControlled.item.setValue(0)
		}
	}
}
