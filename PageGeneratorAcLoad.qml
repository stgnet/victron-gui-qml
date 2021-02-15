import QtQuick 1.1
import "utils.js" as Utils

MbPage {
	id: root

	property string bindPrefix
	property string name: description
	property string description: qsTr("AC load")

	title: qsTr("AC output")


	function minValueWarning()
	{
		toast.createToast(qsTr("Value must be greater than stop value"), 3000, undefined, false)
	}

	function maxValueWarning()
	{
		toast.createToast(qsTr("Value must be lower than start value"), 3000, undefined, false)
	}

	model: VisualItemModel {

		MbSwitch {
			id: enableSwich
			name: qsTr("Use AC Load to start/stop")
			bind: Utils.path(bindPrefix, "/Enabled")
			enabled: valid
		}

		MbItemOptions {
			id: startOn
			description: qsTr("Measurement")
			bind:  Utils.path(bindPrefix, "/Measurement")
			possibleValues: [
				MbOption{ description: qsTr("Total consumption"); value: 0 },
				MbOption{ description: qsTr("Inverter total AC out"); value: 1 },
				MbOption{ description: qsTr("Inverter AC out highest phase"); value: 2 }
			]
		}

		MbSpinBox {
			id: startValue
			description: qsTr("Start when power is higher than")
			bind: Utils.path(bindPrefix,"/StartValue")
			unit: "W"
			numOfDecimals: 0
			stepSize: 5
			min: stopValue.value + stepSize
			max: item.max
			onMinValueReached: minValueWarning()
			show: valid
		}

		MbSpinBox {
			id: quietHoursStartValue
			description: qsTr("Start value during quiet hours")
			bind: Utils.path(bindPrefix,"/QuietHoursStartValue")
			unit: "W"
			numOfDecimals: 0
			stepSize: 5
			min: quietHoursStopValue.value + stepSize
			max: item.max
			onMinValueReached: minValueWarning()
			show: valid
		}

		MbSpinBox {
			id: startTime
			description: qsTr("Start after the condition is reached for")
			bind: Utils.path(bindPrefix,"/StartTimer")
			numOfDecimals: 0
			unit: "s"
			stepSize: 1
			show: valid
		}

		MbSpinBox {
			id: stopValue
			description: qsTr("Stop when power is lower than")
			bind: Utils.path(bindPrefix, "/StopValue")
			unit: "W"
			numOfDecimals: 0
			stepSize: 5
			max: startValue.item.valid ? startValue.value - stepSize : 1000000
			min: 0
			onMaxValueReached: maxValueWarning()
			show: valid
		}

		MbSpinBox {
			id: quietHoursStopValue
			description: qsTr("Stop value during quiet hours")
			bind: Utils.path(bindPrefix, "/QuietHoursStopValue")
			unit: "W"
			numOfDecimals: 0
			stepSize: 5
			max: quietHoursStartValue.item.valid ? quietHoursStartValue.value - stepSize : 1000000
			min: 0
			onMaxValueReached: maxValueWarning()
			show: valid
		}

		MbSpinBox {
			id: stopTime
			description: qsTr("Stop after the condition is reached for")
			bind: Utils.path(bindPrefix, "/StopTimer")
			numOfDecimals: 0
			stepSize: 1
			unit: "s"
			show: valid
		}
	}
}
