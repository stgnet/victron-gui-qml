import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	property variant batteryService

	title: qsTr("Grid Setpoint")

	Component.onCompleted: {
		updateBattery()
	}

	Connections {
		target: DBusServices
		onDbusServiceConnected: updateBattery()
		onDbusServiceDisconnected: updateBattery()
	}

	function updateBattery()
	{
		// Find the active battery service. This function will simply pick the first battery service
		// on the D-Bus. We should use systemcalc (/AutoSelectedBatteryMeasurement and
		// /ServiceMappping/...), but there's an update problem when a battery service is restarted.
		// After the service reappears, the correct value of the relevant /ServiceMapping/...
		// is not set in the VeItem (it remains undefined instead).
		for (var i = 0; i < DBusServices.count; ++i) {
			var service = DBusServices.at(i)
			if (service.connected && service.type === DBusService.DBUS_SERVICE_BATTERY) {
				batteryService = service.name
				break
			}
		}
	}

	model: VisualItemModel {

		MbSpinBox {
			id: gridSetpoint
			description: qsTr("Grid setpoint")
			enabled: userHasWriteAccess
			bind: "com.victronenergy.settings/Settings/CGwacs/AcPowerSetPoint"
			numOfDecimals: 0
			unit: "W"
			min: -15000
			max: 15000
			stepSize: 10
		}

		MbItemSlider {
			id: sliderL1
			enabled: userHasWriteAccess
			item: VBusItem {
				bind: "com.victronenergy.settings/Settings/CGwacs/AcPowerSetPoint"
				min: -15000
				max: 15000
				step: 50
				decimals: 0
			}
		}

		MbItemValue {
			description: qsTr("AC-In setpoint")
			item.bind: "com.victronenergy.vebus.ttyO1/Hub4/L1/AcPowerSetpoint"
		}

		MbItemRow {
			description: "Battery"

			MbTextValue { item.value: "Current: "; width: 100; height: 30 }
			MbTextBlock { item.bind: Utils.path(batteryService, "/Dc/0/Current"); width: 100; height: 30 }
			MbTextValue { item.value: "Voltage: "; width: 100; height: 30 }
			MbTextBlock { item.bind: Utils.path(batteryService, "/Dc/0/Voltage"); width: 100; height: 30 }
		}

		MbItemRow {
			description: "Limits (I)"

			MbTextValue { item.value: "Charge: "; width: 100; height: 30 }
			MbTextBlock { item.bind: Utils.path(batteryService, "/Info/MaxChargeCurrent"); width: 100; height: 30 }
			MbTextValue { item.value: "Discharge: "; width: 100; height: 30 }
			MbTextBlock { item.bind: Utils.path(batteryService, "/Info/MaxDischargeCurrent"); width: 100; height: 30 }
		}

		MbItemRow {
			description: "Limits (P)"

			MbTextValue { item.value: "Charge: "; width: 100; height: 30 }
			MbTextBlock { item.bind: "com.victronenergy.settings/Settings/CGwacs/MaxChargePower"; width: 100; height: 30 }
			MbTextValue { item.value: "Discharge: "; width: 100; height: 30 }
			MbTextBlock { item.bind: "com.victronenergy.settings/Settings/CGwacs/MaxDischargePower"; width: 100; height: 30 }
		}
	}
}
