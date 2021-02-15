import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	id: root
	title: service.description
	property variant service
	property string bindPrefix
	summary: state.text

	SystemState {
		id: state
		bind: service.path("/State")
	}

	VBusItem {
		id: nrOfOutputs
		bind: service.path("/NrOfOutputs")
	}

	model: VisualItemModel {

		MbSwitch {
			name: qsTr("Switch")
			bind: service.path("/Mode")
			enabled: valid
			valueTrue: 1
			valueFalse: 4
			writeAccessLevel: User.AccessUser
			show: item.valid
		}

		MbItemValue {
			description: qsTr("State")
			item.text: state.text
		}

		MbSpinBox {
			description: qsTr("Input current limit")
			bind: service.path("/Ac/In/CurrentLimit")
			stepSize: 0.1
			unit: "A"
			writeAccessLevel: User.AccessUser
			show: item.valid
		}

		MbItemRow {
			description: qsTr("Battery") + " 1"
			values: [
				MbTextBlock { item.bind: service.path("/Dc/0/Voltage"); width: 90; height: 25 },
				MbTextBlock { item.bind: service.path("/Dc/0/Current"); width: 90; height: 25 }
			]
		}

		MbItemRow {
			description: qsTr("Battery") + " 2"
			values: [
				MbTextBlock { item.bind: service.path("/Dc/1/Voltage"); width: 90; height: 25 },
				MbTextBlock { item.bind: service.path("/Dc/1/Current"); width: 90; height: 25 }
			]
			show: nrOfOutputs.valid && nrOfOutputs.value >= 2
		}

		MbItemRow {
			description: qsTr("Battery") + " 3"
			values: [
				MbTextBlock { item.bind: service.path("/Dc/2/Voltage"); width: 90; height: 25 },
				MbTextBlock { item.bind: service.path("/Dc/2/Current"); width: 90; height: 25 }
			]
			show: nrOfOutputs.valid && nrOfOutputs.value >= 3
		}

		MbItemValue {
			description: qsTr("Battery temperature")
			item {
				bind: service.path("/Dc/0/Temperature")
				unit: "°C"
			}
			show: item.valid
		}

		MbItemValue {
			description: qsTr("AC current")
			item.bind: service.path("/Ac/In/L1/I")
			show: item.valid
		}

		MbItemAlarm {
			description: qsTr("Low battery voltage alarm")
			bind: service.path("/Alarms/LowVoltage")
			show: valid
		}

		MbItemAlarm {
			description: qsTr("High battery voltage alarm")
			bind: service.path("/Alarms/HighVoltage")
			show: valid
		}

		MbItemChargerError {
			description: qsTr("Error")
			item.bind: service.path("/ErrorCode")
		}

		/* This is the master´s relay state */
		MbItemOptions {
			description: qsTr("Relay state")
			bind: service.path("/Relay/0/State")
			readonly: true
			possibleValues:[
				MbOption{description: qsTr("Off"); value: 0},
				MbOption{description: qsTr("On"); value: 1}
			]
			show: valid
		}

		MbSubMenu {
			id: supportedDeviceItem
			description: qsTr("Device")
			subpage: Component {
				PageDeviceInfo {
					title: supportedDeviceItem.description
					bindPrefix: service.path("")
				}
			}
		}
	}
}
