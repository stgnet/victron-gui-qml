import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	id: root

	property variant service
	property string bindPrefix
	property InverterData inverter: InverterData { bindPrefix: root.bindPrefix }

	title: service.description
	summary: acPower.item.text

	model: VisualItemModel {
		MbItemOptions {
			description: qsTr("Switch")
			bind: service.path("/Mode")
			show: !inverter.isInverterCharger
			possibleValues: [
				MbOption { description: qsTr("Off"); value: 4 },
				MbOption { description: qsTr("On"); value: 2 },
				MbOption { description: qsTr("Eco"); value: 5 }
			]
		}

		MbItemOptions {
			description: qsTr("Switch")
			bind: service.path("/Mode")
			show: inverter.isInverterCharger
			possibleValues: [
				MbOption { description: qsTr("Off"); value: 4 },
				MbOption { description: qsTr("Charger Only"); value: 1 },
				MbOption { description: qsTr("Inverter Only"); value: 2 },
				MbOption { description: qsTr("On"); value: 3 }
			]
		}

		MbItemValue {
			SystemState {
				id: state
				bind: root.service.path("/State")
			}
			description: qsTr("State")
			item.text: state.text
		}

		MbItemRow {
			description: qsTr("AC-Out")
			values: [
				MbTextBlock {
					id: acVoltage
					item.text: inverter.acOut.voltage.text
					width: 90
					height: 25
				},
				MbTextBlock {
					id: acCurrent
					item.text: inverter.acOut.current.text
					width: 90
					height: 25
				},
				MbTextBlock {
					id: acPower
					item.text: inverter.acOut.power.text
					width: 90
					height: 25
				}
			]
		}

		MbItemRow {
			description: qsTr("DC")
			values: [
				MbTextBlock { item.bind: service.path("/Dc/0/Voltage"); width: 90; },
				MbTextBlock { item.bind: service.path("/Dc/0/Current"); width: 90; visible: item.valid; }
			]
		}

		MbItemRow {
			description: qsTr("PV")
			show: pvV.item.valid || pvYield.item.valid
			values: [
				MbTextBlock { id: pvV; item.bind: service.path("/Pv/V"); width: 90; },
				MbTextBlock { id: pvYield; item.bind: service.path("/Yield/Power"); width: 90; }
			]
		}

		MbItemValue {
			description: qsTr("State of charge")
			item.bind: service.path("/Soc")
			item.unit: "%"
			show: inverter.isInverterCharger
		}

		MbItemValue {
			description: qsTr("Battery temperature")
			item {
				bind: service.path("/Dc/0/Temperature")
				unit: "°C"
			}
			show: item.valid
		}

		MbItemOptions {
			description: qsTr("Relay state")
			bind: service.path("/Relay/0/State")
			readonly: true
			show: valid
			possibleValues: [
				MbOption { description: qsTr("Off"); value: 0 },
				MbOption { description: qsTr("On"); value: 1 }
			]
		}

		MbSubMenu {
			id: supportedDeviceItem
			description: qsTr("Device")
			subpage: Component {
				PageDeviceInfo {
					title: supportedDeviceItem.description
					bindPrefix: root.bindPrefix
				}
			}
		}
	}
}
