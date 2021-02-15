import QtQuick 1.1
import "utils.js" as Utils

MbSubMenu {
	id: root

	property string bindPrefix
	property string unit: ""
	property string timeUnit: "s"
	property int decimals: 1
	property bool startValueIsGreater: true
	property string name: description

	property string enableDescription: qsTr("Use %1 value to start/stop").arg(name)
	property string startValueDescription: qsTr("Start when %1 %2").arg(root.name).arg(
											   startValueIsGreater ? qsTr("is higher than") : qsTr("is lower than"))
	property string quietStartValueDescription: qsTr("Start value during quiet hours")
	property string startTimeDescription: qsTr("Start after the condition is reached for")
	property string stopValueDescription: qsTr("Stop when %1 %2").arg(root.name).arg(
											  !startValueIsGreater ? qsTr("is higher than") : qsTr("is lower than"))
	property string quietStopValueDescription: qsTr("Stop value during quiet hours")
	property string stopTimeDescription: qsTr("Stop after the condition is reached for")

	// Autocalculate step size based on number of decimals
	property real stepSize: Math.pow(10, -decimals)

	function minValueWarning()
	{
		if (!startValueIsGreater) {
			toast.createToast(qsTr("Value must be lower than stop value"), 3000, undefined, false)
		} else {
			toast.createToast(qsTr("Value must be greater than stop value"), 3000, undefined, false)
		}
	}

	function maxValueWarning()
	{
		if (!startValueIsGreater) {
			toast.createToast(qsTr("Value must be greater than start value"), 3000, undefined, false)
		} else {
			toast.createToast(qsTr("Value must be lower than start value"), 3000, undefined, false)
		}
	}

	item {
		bind: Utils.path(bindPrefix, "/Enabled")
		text: item.value === 1 ? qsTr("Enabled") : qsTr("Disabled")
	}

	subpage: Component {
		 MbPage {
			id: subPage
			title: root.description
			model: VisualItemModel {
				MbSwitch {
					id: enableSwich
					name: enableDescription
					bind: Utils.path(bindPrefix, "/Enabled")
					enabled: valid
				}

				MbSpinBox {
					id: startValue
					description: startValueDescription
					bind: Utils.path(bindPrefix,"/StartValue")
					unit: root.unit
					numOfDecimals: root.decimals
					stepSize: root.stepSize
					min: item.min !== undefined && stopValue.valid ?
							 root.startValueIsGreater ? stopValue.value + stepSize : item.min : 0
					max: item.max !== undefined && stopValue.valid ?
							 root.startValueIsGreater ? item.max : stopValue.value - stepSize : 100
					onMaxValueReached: if (!startValueIsGreater) minValueWarning()
					onMinValueReached: if (startValueIsGreater) minValueWarning()

					show: valid
				}

				MbSpinBox {
					id: quietHoursStartValue
					description: quietStartValueDescription
					bind: Utils.path(bindPrefix,"/QuietHoursStartValue")
					unit: root.unit
					numOfDecimals: root.decimals
					stepSize: root.stepSize
					min: item.min !== undefined && quietHoursStopValue.valid?
							 root.startValueIsGreater ? quietHoursStopValue.value + stepSize : item.min : 0
					max: item.max !== undefined && quietHoursStopValue.valid ?
							 root.startValueIsGreater ? item.max : quietHoursStopValue.value - stepSize : 100
					onMaxValueReached: if (!startValueIsGreater) minValueWarning()
					onMinValueReached: if (startValueIsGreater) minValueWarning()
					show: valid
				}

				MbSpinBox {
					id: startTime
					description: startTimeDescription
					bind: Utils.path(bindPrefix,"/StartTimer")
					numOfDecimals: 0
					unit: root.timeUnit
					stepSize: 1
					show: valid
				}

				MbSpinBox {
					id: stopValue
					description: stopValueDescription
					bind: Utils.path(bindPrefix,"/StopValue")
					unit: root.unit
					numOfDecimals: root.decimals
					stepSize: root.stepSize
					max: item.max !== undefined && startValue.valid ?
							 root.startValueIsGreater ?startValue.value - stepSize : item.max : 100
					min: item.min !== undefined && startValue.valid ?
							 root.startValueIsGreater ? item.min : startValue.value + stepSize : 0
					onMaxValueReached: if (startValueIsGreater) maxValueWarning()
					onMinValueReached: if (!startValueIsGreater) maxValueWarning()
					show: valid
				}

				MbSpinBox {
					id: quietHoursStopValue
					description: quietStopValueDescription
					bind: Utils.path(bindPrefix, "/QuietHoursStopValue")
					unit: root.unit
					numOfDecimals: root.decimals
					stepSize: root.stepSize
					max: item.max !== undefined && quietHoursStartValue.valid ?
							 root.startValueIsGreater ? quietHoursStartValue.value - stepSize : item.max : 100
					min: item.min !== undefined && quietHoursStartValue.valid ?
							 root.startValueIsGreater ? item.min : quietHoursStartValue.value + stepSize : 0
					onMaxValueReached: if (startValueIsGreater) maxValueWarning()
					onMinValueReached: if (!startValueIsGreater) maxValueWarning()
					show: valid
				}

				MbSpinBox {
					id: stopTime
					description: stopTimeDescription
					bind: Utils.path(bindPrefix, "/StopTimer")
					numOfDecimals: 0
					stepSize: 1
					unit: root.timeUnit
					show: valid
				}
			}
		}
	}
}
