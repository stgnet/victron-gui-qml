import QtQuick 1.1
import "utils.js" as Utils

MbPage {
	id: root

	property string bindPrefix: "com.victronenergy.settings"

	title: qsTr("Periodic run")

	model: VisualItemModel {
		id: vItemModel
		MbSwitch {
			id: enableSwich
			name: qsTr("Enable")
			bind: Utils.path(root.bindPrefix, "/TestRun/Enabled")
			enabled: valid
		}

		MbSpinBox {
			description: qsTr("Run interval")
			bind: Utils.path(root.bindPrefix, "/TestRun/Interval")
			unit: qsTr(" days")
			numOfDecimals: 0
			stepSize: 1
			max: 30
		}

		MbItemOptions {
			description: qsTr("Skip run if has been running for")
			bind:  Utils.path(root.bindPrefix, "/TestRun/SkipRuntime")
			possibleValues: [
				MbOption { description: qsTr("Start always"); value: 0 },
				MbOption { description: qsTr("1 Hour"); value: 3600 },
				MbOption { description: qsTr("2 Hours"); value: 7200 },
				MbOption { description: qsTr("4 Hours"); value: 14400 },
				MbOption { description: qsTr("6 Hours"); value: 21600 },
				MbOption { description: qsTr("8 Hours"); value: 28800 },
				MbOption { description: qsTr("10 Hours"); value: 36000 }
			]
		}

		MbEditBoxDateTime {
			description: qsTr("Run interval start date")
			format: "yyyy-MM-dd"
			item.bind: Utils.path(root.bindPrefix, "/TestRun/StartDate")
		}

		MbEditBoxTime {
			description: qsTr("Start time")
			item.bind: Utils.path(root.bindPrefix, "/TestRun/StartTime")
		}
		MbEditBoxTime {
			id: testDuration
			description: qsTr("Run duration (hh:mm)")
			item.bind: Utils.path(bindPrefix, "/TestRun/Duration")
			show: !runTillBatteryFull.checked
		}
		MbSwitch {
			id: runTillBatteryFull
			name: qsTr("Run until battery is fully charged")
			bind: Utils.path(root.bindPrefix, "/TestRun/RunTillBatteryFull")
			enabled: valid
		}
	}
}
