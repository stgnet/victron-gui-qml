import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	property string bindPrefix

	model: VisualItemModel {
		MbItemValue {
			description: qsTr("Deepest discharge")
			item.bind: Utils.path(bindPrefix, "/History/DeepestDischarge")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Last discharge")
			item.bind: Utils.path(bindPrefix, "/History/LastDischarge")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Average discharge")
			item.bind: Utils.path(bindPrefix, "/History/AverageDischarge")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Total charge cycles")
			item.bind: Utils.path(bindPrefix, "/History/ChargeCycles")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Number of full discharges")
			item.bind: Utils.path(bindPrefix, "/History/FullDischarges")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Cumulative Ah drawn")
			item.bind: Utils.path(bindPrefix, "/History/TotalAhDrawn")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Minimum voltage")
			item.bind: Utils.path(bindPrefix, "/History/MinimumVoltage")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Maximum voltage")
			item.bind: Utils.path(bindPrefix, "/History/MaximumVoltage")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Minimum cell voltage")
			item.bind: Utils.path(bindPrefix, "/History/MinimumCellVoltage")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Maximum cell voltage")
			item.bind: Utils.path(bindPrefix, "/History/MaximumCellVoltage")
			show: item.valid
		}

		MbItemTimeSpan {
			description: qsTr("Time since last full charge")
			item.bind: Utils.path(bindPrefix, "/History/TimeSinceLastFullCharge")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Synchronisation count")
			item.bind: Utils.path(bindPrefix, "/History/AutomaticSyncs")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Low voltage alarms")
			item.bind: Utils.path(bindPrefix, "/History/LowVoltageAlarms")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("High voltage alarms")
			item.bind: Utils.path(bindPrefix, "/History/HighVoltageAlarms")
			show: item.valid
		}

		MbItemValue {
			id: lowStarterVoltageAlarm
			VBusItem {
				id: hasStarterVoltage
				bind: Utils.path(bindPrefix, "/Settings/HasStarterVoltage")
			}
			description: qsTr("Low starter bat. voltage alarms")
			item.bind: show ? Utils.path(bindPrefix, "/History/LowStarterVoltageAlarms") : ""
			show: hasStarterVoltage.valid && hasStarterVoltage.value
		}

		MbItemValue {
			description: qsTr("High starter bat. voltage alarms")
			item.bind: show ? Utils.path(bindPrefix, "/History/HighStarterVoltageAlarms") : ""
			show: lowStarterVoltageAlarm.show
		}

		MbItemValue {
			description: qsTr("Minimum starter bat. voltage")
			item.bind: show ? Utils.path(bindPrefix, "/History/MinimumStarterVoltage") : ""
			show: lowStarterVoltageAlarm.show
		}

		MbItemValue {
			description: qsTr("Maximum starter bat. voltage")
			item.bind: show ? Utils.path(bindPrefix, "/History/MaximumStarterVoltage") : ""
			show: lowStarterVoltageAlarm.show
		}

		MbItemValue {
			VBusItem {
				id: hasTemperature
				bind: Utils.path(bindPrefix, "/Settings/HasTemperature")
			}
			description: qsTr("Minimum temperature")
			item.bind: Utils.path(bindPrefix, "/History/MinimumTemperature")
			item.unit: "°C"
			show: hasTemperature.value === 1 && item.valid
		}

		MbItemValue {
			description: qsTr("Maximum temperature")
			item.bind: Utils.path(bindPrefix, "/History/MaximumTemperature")
			item.unit: "°C"
			show: hasTemperature.value === 1 && item.valid
		}

		MbItemValue {
			description: qsTr("Discharged energy")
			item.bind: Utils.path(bindPrefix, "/History/DischargedEnergy")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Charged energy")
			item.bind: Utils.path(bindPrefix, "/History/ChargedEnergy")
			show: item.valid
		}

		MbItemText {
			text: qsTr("Info: Reset history on the monitor itself")
			show: !clearHistory.show
		}

		MbOK {
			id: clearHistory
			description: qsTr("Clear History")
			value: editable ? qsTr("Press to clear") : qsTr("Clearing")
			cornerMark: false

			VBusItem {
				id: clear
				bind: Utils.path(bindPrefix, "/History/Clear")
			}

			VBusItem {
				id: canBeCleared
				bind: Utils.path(bindPrefix, "/History/CanBeCleared")
			}

			VBusItem {
				id: connected
				bind: Utils.path(bindPrefix, "/Connected")
			}

			Timer {
				id: timer
				interval: 2000
			}
			editable: !timer.running

			onClicked: {
				/*
				 * Write some value to the item as the clear command does not need
				 * to have a value. Do make sure to only write the value when the
				 * button is pressed and not when released.
				 */
				clear.setValue(1)
				timer.start()
			}

			show: connected.value === 1 && canBeCleared.value === 1
		}
	}
}
