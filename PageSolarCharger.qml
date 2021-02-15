import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	id: root

	property variant service
	property string bindPrefix

	title: service.description
	summary: (errorCode.valid && errorCode.value !== 0 ? "Error " + errorCode.value : totalPower.text)

	property VBusItem errorCode: VBusItem { bind: service.path("/ErrorCode") }
	property VBusItem productName: VBusItem { bind: service.path("/ProductName") }
	property VBusItem productId: VBusItem { bind: service.path("/ProductId") }
	property VBusItem firmwareVersion: VBusItem { bind: service.path("/FirmwareVersion") }
	property VBusItem nrOfTrackers: VBusItem { bind: service.path("/NrOfTrackers") }
	property int trackers: nrOfTrackers.valid ? nrOfTrackers.value : 1
	property VBusItem totalPower: VBusItem { bind: service.path("/Yield/Power") }


	function isModelSupported()
	{
		if (!productId.valid || !firmwareVersion.valid)
			return true

		/* MPPT 70/15 (product id 0x300) has limited VE.Text support */
		if (productId.value === 0x300)
			return false

		/* Reserved space for VE.Direct Solar chargers 0xA040..0xA07F: 64 items */
		if (productId.value >= 0xA040 && productId.value <= 0xA07F) {
			/* Fw versions < v1.09 are not supported */
			return firmwareVersion.value >= 0x109
		}

		/* Supported: e.g. VE.Can */
		return true
	}

	model: isModelSupported() ? supportedProduct : unsupportedProduct

	/* This model is loaded when an unsupported product is connected */
	VisualItemModel {
		id: unsupportedProduct

		MbItemText {
			wrapMode: Text.WordWrap
			text: getText()

			function getText()
			{
				var text = "Unfortunately the connected MPPT Solar Charger is not compatible. ";

				switch (productId.value)
				{
				case 0x300:		/* MPPT 70/15 */
					text += "The 70/15 needs to be from year/week 1308 or later. " +
							"MPPT 70/15's currently shipped from our warehouse are compatible."
					break;
				default:
					if (firmwareVersion.value < 0x109) {
						text += "The firmware version in the MPPT Solar Charger must be v1.09 or later. " +
								"Contact Victron Service for update instructions and files."
					}
				}

				return text
			}
		}

		MbSubMenu {
			id: deviceItem
			description: qsTr("Device")
			subpage: Component {
				PageDeviceInfo {
					title: deviceItem.description
					bindPrefix: root.bindPrefix
				}
			}
		}
	}

	/* This model is loaded when an supported product is connected */
	VisualItemModel {
		id: supportedProduct

		MbItemValue {
			SystemState {
				id: state
				bind: root.service.path("/State")
			}
			description: qsTr("State")
			item.text: state.text
		}
/*
		MbItemOptions {
			description: qsTr("Switch")
			bind: root.service.path("/Mode"
			possibleValues: [
				MbOption{description: qsTr("Off"); value: 4},
				MbOption{description: qsTr("On"); value: 1}
			]
			show: valid
		}
*/
		MbItemRow {
			description: qsTr("PV")
			values: [
				/* PV voltage and current are not visible in parallel mode */
				MbTextBlock { item.bind: service.path("/Pv/V"); width: 90; visible: item.valid; height: 25 },
				MbTextBlock { item.bind: service.path("/Pv/I"); width: 90; visible: item.valid; height: 25 },
				MbTextBlock { item: totalPower; width: 90; height: 25 }
			]
			show: trackers < 2
		}

		MbItemRow {
			description: qsTr("Total PV power")
			values: [
				MbTextBlock { item: totalPower; width: 90; height: 25 }
			]
			show: trackers >= 2
		}

		MbItemRow {
			description: qsTr("Tracker 1")
			show: trackers >= 2
			values: [
				MbTextBlock { item.bind: service.path("/Pv/0/V"); width: 90; height: 25 },
				MbTextBlock { item.bind: service.path("/Pv/0/I"); width: 90; height: 25 },
				MbTextBlock { item.bind: service.path("/Pv/0/P"); width: 90; height: 25 }
			]
		}
		MbItemRow {
			description: qsTr("Tracker 2")
			show: trackers >= 2
			values: [
				MbTextBlock { item.bind: service.path("/Pv/1/V"); width: 90; height: 25 },
				MbTextBlock { item.bind: service.path("/Pv/1/I"); width: 90; height: 25 },
				MbTextBlock { item.bind: service.path("/Pv/1/P"); width: 90; height: 25 }
			]
		}
		MbItemRow {
			description: qsTr("Tracker 3")
			show: trackers >= 3
			values: [
				MbTextBlock { item.bind: service.path("/Pv/2/V"); width: 90; height: 25 },
				MbTextBlock { item.bind: service.path("/Pv/2/I"); width: 90; height: 25 },
				MbTextBlock { item.bind: service.path("/Pv/2/P"); width: 90; height: 25 }
			]
		}
		MbItemRow {
			description: qsTr("Tracker 4")
			show: trackers >= 4
			values: [
				MbTextBlock { item.bind: service.path("/Pv/3/V"); width: 90; height: 25 },
				MbTextBlock { item.bind: service.path("/Pv/3/I"); width: 90; height: 25 },
				MbTextBlock { item.bind: service.path("/Pv/3/P"); width: 90; height: 25 }
			]
		}

		MbItemRow {
			description: qsTr("Battery")
			values: [
				MbTextBlock { item.bind: service.path("/Dc/0/Voltage"); width: 90; height: 25 },
				MbTextBlock { item.bind: service.path("/Dc/0/Current"); width: 90; height: 25 },

				/* Only available on CANbus chargers */
				MbTextBlock {
					item {
						bind: service.path("/Dc/0/Temperature");
						unit: "°C"
					}
					width: 90; height: 25; visible: item.valid
				}
			]
		}

		/* This is actually the user resettable yield */
		MbItemValue {
			description: qsTr("Total yield")
			item.bind: root.service.path("/Yield/User")
		}

		MbItemValue {
			description: qsTr("System yield")
			item.bind: root.service.path("/Yield/System")
			show: item.valid
		}

		/* Only available on 15A chargers */
		MbItemOptions {
			description: qsTr("Load")
			bind: root.service.path("/Load/State")
			readonly: true
			possibleValues:[
				MbOption{description: qsTr("Off"); value: 0},
				MbOption{description: qsTr("On"); value: 1}
			]
			show: valid

			/* If load is on and current present, show current.
			 * Otherwise show the state of the load output. */
			text: valid && value && loadCurrent.valid ?
					loadCurrent.text : getText(value)

			VBusItem {
				id: loadCurrent
				bind: service.path("/Load/I")
			}
		}

		MbItemAlarm {
			description: qsTr("Low battery voltage alarm")
			bind: root.service.path("/Alarms/LowVoltage")
			show: valid
		}

		MbItemAlarm {
			description: qsTr("High battery voltage alarm")
			bind: root.service.path("/Alarms/HighVoltage")
			show: valid
		}

		MbItemChargerError {
			description: qsTr("Error")
			item.bind: root.service.path("/ErrorCode")
		}

		/* This is the master´s relay state */
		MbItemOptions {
			description: qsTr("Relay state")
			bind: root.service.path("/Relay/0/State")
			readonly: true
			possibleValues:[
				MbOption{description: qsTr("Off"); value: 0},
				MbOption{description: qsTr("On"); value: 1}
			]
			show: valid
		}

		MbSubMenu {
			description: qsTr("Daily history")
			subpage: Component {
				PageSolarHistory {
					title: qsTr("Daily history")
					bindPrefix: root.bindPrefix
				}
			}
		}

		MbSubMenu {
			description: qsTr("Daily tracker history")
			subpage: Component {
				PageSolarTrackerHistory {
					title: qsTr("Daily tracker history")
					bindPrefix: root.bindPrefix
				}
			}
			show: trackers > 1
		}

		MbSubMenu {
			description: qsTr("Overall history")
			subpage: Component {
				PageSolarStats {
					title: qsTr("Overall history")
					bindPrefix: root.bindPrefix
				}
			}
		}

		MbSubMenu {
			id: parallelOperationItem
			description: qsTr("Networked operation")
			subpage: Component {
				PageSolarParallelOperation {
					title: parallelOperationItem.description
					service: root.service
				}
			}
			// Use this item to check if the sub menu should be shown,
			// but do not actually show the value
			property VBusItem linkNetworkStatus: VBusItem {	bind: service.path("/Link/NetworkStatus") }
			show: linkNetworkStatus.valid
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
