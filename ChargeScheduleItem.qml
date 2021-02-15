import QtQuick 1.1
import "utils.js" as Utils

MbSubMenu {
	id: root
	property string bindPrefix
	property int scheduleNumber: 0

	description: qsTr("Schedule %1").arg(scheduleNumber + 1)
	userHasWriteAccess: true
	item {
		text: getItemText()
	}

	// Negative values means disabled. We preserve the day by just flipping the sign.
	function toggleDay(v)
	{
		// Sunday (0) is special since -0 is equal, map it to -10 and vice versa.
		if (v === -10)
			return 0;
		if (v === 0)
			return -10;
		return -v
	}

	function getItemText()
	{
		if (itemDay.valid && itemDay.value >= 0) {
			var day = itemDay.text
			var start = startTime.item.text
			var durationSecs = Utils.secondsToString(duration.item.value)
			// This is stupid, but QString.arg apparently can't handle an
			// integer mixed in with some strings.
			if (socLimit.valid && socLimit.value >= 100) {
				return qsTr("%1 %2 (%3)").arg(day).arg(start).arg(durationSecs)
			}
			return qsTr("%1 %2 (%3 or %4%)").arg(day).arg(start).arg(durationSecs).arg(""+socLimit.value)
		}

		return qsTr("Disabled")
	}

	subpage: MbPage {
		title: root.description
		model: VisualItemModel {
			MbSwitch {
				id: itemEnabled
				name: qsTr("Enabled")
				enabled: true
				checked: itemDay.value >= 0
				onCheckedChanged: {
					if (checked ^ itemDay.value >= 0)
						itemDay.item.setValue(toggleDay(itemDay.value))
				}
			}

			MbItemOptions {
				id: itemDay
				description: qsTr("Day")
				bind: Utils.path(bindPrefix, scheduleNumber, "/Day")
				show: itemEnabled.checked
				unknownOptionText: "--"
				possibleValues: [
					MbOption { description: qsTr("Every day"); value: 7 },
					MbOption { description: qsTr("Weekdays"); value: 8 },
					MbOption { description: qsTr("Weekends"); value: 9 },
					MbOption { description: qsTr("Monday"); value: 1 },
					MbOption { description: qsTr("Tuesday"); value: 2 },
					MbOption { description: qsTr("Wednesday"); value: 3 },
					MbOption { description: qsTr("Thursday"); value: 4 },
					MbOption { description: qsTr("Friday"); value: 5 },
					MbOption { description: qsTr("Saturday"); value: 6 },
					MbOption { description: qsTr("Sunday"); value: 0 }
				]
			}

			MbEditBoxTime {
				id: startTime
				description: qsTr("Start time")
				item.bind: Utils.path(bindPrefix, scheduleNumber, "/Start")
				show: itemEnabled.checked
			}

			MbEditBoxTime {
				id: duration
				description: qsTr("Duration (hh:mm)")
				item.bind: Utils.path(bindPrefix, scheduleNumber, "/Duration")
				show: itemEnabled.checked
			}

			MbSwitch {
				id: socLimitEnabled
				name: qsTr("Stop on SOC")
				enabled: true
				show: itemEnabled.checked
				checked: socLimit.value < 100
				onCheckedChanged: {
					if (checked && socLimit.value >= 100)
						socLimit.item.setValue(95)
					else if (!checked && socLimit.value < 100)
						socLimit.item.setValue(100)
				}
			}

			MbSpinBox {
				id: socLimit
				description: qsTr("SOC limit")
				bind: Utils.path(bindPrefix, scheduleNumber, "/Soc")
				show: itemEnabled.checked && socLimitEnabled.checked
				numOfDecimals: 0
				unit: "%"
				min: 5
				max: 95
				stepSize: 5
			}
		}
	}
}

