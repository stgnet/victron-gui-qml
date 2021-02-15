import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	id: root

	property variant service
	property string bindPrefix

	property VBusItem hasSettings: VBusItem { bind: service.path("/Settings/HasSettings") }
	property VBusItem dcVoltage: VBusItem { bind: service.path("/Dc/0/Voltage") }
	property VBusItem dcCurrent: VBusItem { bind: service.path("/Dc/0/Current") }
	property VBusItem midVoltage: VBusItem { bind: service.path("/Dc/0/MidVoltage") }
	property VBusItem productId: VBusItem { bind: service.path("/ProductId") }

	property bool isLynxIon: productId.value === 0x0142 || productId.value === 0xA130 || (productId.value & 0xFFF0) === 0xA390
	property bool isFiamm48TL: productId.value === 0xB012

	title: service.description
	summary: [soc.item.format(0), dcVoltage.text, dcCurrent.text]

	model: VisualItemModel {
		MbItemOptions {
			description: qsTr("State")
			bind: service.path("/State")
			readonly: true
			show: isLynxIon
			possibleValues:[
				MbOption { description: qsTr("Initializing"); value: 0 },
				MbOption { description: qsTr("Initializing"); value: 1 },
				MbOption { description: qsTr("Initializing"); value: 2 },
				MbOption { description: qsTr("Initializing"); value: 3 },
				MbOption { description: qsTr("Initializing"); value: 4 },
				MbOption { description: qsTr("Initializing"); value: 5 },
				MbOption { description: qsTr("Initializing"); value: 6 },
				MbOption { description: qsTr("Initializing"); value: 7 },
				MbOption { description: qsTr("Initializing"); value: 8 },
				MbOption { description: qsTr("Running"); value: 9 },
				MbOption { description: qsTr("Error"); value: 10 },
//				MbOption { description: qsTr("Unknown"); value: 11 },
				MbOption { description: qsTr("Shutdown"); value: 12 },
				MbOption { description: qsTr("Updating"); value: 13 },
				MbOption { description: qsTr("Standby"); value: 14 },
				MbOption { description: qsTr("Going to run"); value: 15 },
				MbOption { description: qsTr("Pre-Charging"); value: 16 }
			]
		}

		MbItemBmsError {
			description: qsTr("Error")
			item.bind: service.path("/ErrorCode")
			show: isLynxIon && item.valid
		}

		MbItemRow {
			description: qsTr("Battery")
			values: [
				MbTextBlock { item: dcVoltage; width: 90; height: 25 },
				MbTextBlock { item: dcCurrent; width: 90; height: 25 },
				MbTextBlock { item.bind: service.path("/Dc/0/Power"); width: 90; height: 25 }
			]
		}

		MbItemValue {
			id: soc
			description: qsTr("State of charge")
			item.bind: service.path("/Soc")
			item.unit: "%"
		}

		MbItemValue {
			description: qsTr("State of health")
			item.bind: service.path("/Soh")
			show: item.valid
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
			description: qsTr("Air temperature")
			item {
				bind: service.path("/AirTemperature")
				unit: "°C"
			}
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Starter voltage")
			item.bind: service.path("/Dc/1/Voltage")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Bus voltage")
			item.bind: service.path("/BusVoltage")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Top section voltage")
			item {
				value: midVoltage.valid && dcVoltage.valid ? dcVoltage.value - midVoltage.value : undefined
				unit: "V"
				decimals: 2
			}
			show: midVoltage.valid
		}

		MbItemValue {
			description: qsTr("Bottom section voltage")
			item: midVoltage
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Mid-point deviation")
			item.bind: service.path("/Dc/0/MidVoltageDeviation")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Consumed AmpHours")
			item.bind: service.path("/ConsumedAmphours")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Bus voltage")
			item.bind: service.path("/BussVoltage")
			show: item.valid
		}

		/* Time to go also needs to display infinite value */
		MbItemTimeSpan {
			description: qsTr("Time-to-go")
			item.bind: service.path("/TimeToGo")
			show: item.seen
		}

		MbItemOptions {
			description: qsTr("Relay state")
			bind: service.path("/Relay/0/State")
			readonly: true
			possibleValues:[
				MbOption { description: qsTr("Off"); value: 0 },
				MbOption { description: qsTr("On"); value: 1 }
			]
			show: valid
		}

		MbItemOptions {
			description: qsTr("Alarm state")
			bind: service.path("/Alarms/Alarm")
			readonly: true
			possibleValues:[
				MbOption { description: qsTr("Ok"); value: 0 },
				MbOption { description: qsTr("Alarm"); value: 1 }
			]
			show: valid
		}

		MbSubMenu {
			description: qsTr("Details")
			show: details.anyItemValid

			property BatteryDetails details: BatteryDetails { id: details; bindPrefix: service.path("") }

			subpage: Component {
				PageBatteryDetails {
					bindPrefix: service.path("")
					details: details
				}
			}
		}

		MbSubMenu {
			description: qsTr("Alarms")
			subpage: Component {
				PageBatteryAlarms {
					title: qsTr("Alarms")
					bindPrefix: service.path("")
				}
			}
		}

		MbSubMenu {
			description: qsTr("History")
			subpage: Component {
				PageBatteryHistory {
					title: qsTr("History")
					bindPrefix: service.path("")
				}
			}
			show: !isFiamm48TL
		}

		MbSubMenu {
			id: settings
			description: qsTr("Settings")
			show: hasSettings.value === 1
			subpage: Component {
				PageBatterySettings {
					title: settings.description
					bindPrefix: service.path("")
				}
			}
		}

		MbSubMenu {
			description: qsTr("Diagnostics")
			subpage: Component {
				PageLynxIonDiagnostics {
					title: qsTr("Diagnostics")
					bindPrefix: service.path("")
				}
			}
			show: isLynxIon
		}

		MbSubMenu {
			description: qsTr("Diagnostics")
			subpage: Component {
				Page48TlDiagnostics {
					title: qsTr("Diagnostics")
					bindPrefix: service.path("")
				}
			}
			show: isFiamm48TL
		}

		MbSubMenu {
			description: qsTr("IO")
			subpage: Component {
				PageLynxIonIo {
					title: qsTr("IO")
					bindPrefix: service.path("")
				}
			}
			show: isLynxIon
		}

		MbSubMenu {
			description: qsTr("System")
			subpage:  Component {
				PageLynxIonSystem {
					title: qsTr("System")
					bindPrefix: service.path("")
				}
			}
			show: isLynxIon
		}

		MbSubMenu {
			description: qsTr("Device")
			subpage: Component {
				PageDeviceInfo {
					title: qsTr("Device")
					bindPrefix: service.path("")
				}
			}
		}

		MbSubMenu {
			property VBusItem maxChargeCurrent: VBusItem { bind: service.path("/Info/MaxChargeCurrent") }
			description: qsTr("Parameters")
			show: maxChargeCurrent.valid
			subpage: Component {
				PageBatteryParameters {
					title: qsTr("Parameters")
					service: root.service
				}
			}
		}

		MbOK {
			VBusItem {
				id: redetect
				bind: service.path("/Redetect")
			}

			description: qsTr("Redetect Battery")
			value: qsTr("Press to redetect")
			editable: redetect.value === 0
			show: redetect.valid
			cornerMark: false
			writeAccessLevel: User.AccessUser
			onClicked: {
				redetect.setValue(1)
				toast.createToast(qsTr("Redetecting the battery may take up time 60 seconds. Meanwhile the name of the battery may be incorrect."), 10000);
			}
		}
	}
}