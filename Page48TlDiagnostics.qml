import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	id: root
	property string bindPrefix

	model: VisualItemModel {
		id: vModel

		MbItemRow {
			description: qsTr("Status LEDs")
			values: [
				Led {
					bind: service.path("/Diagnostics/LedStatus/Green")
					onColor: "#00FF00"
					radius: 10
				},
				Led {
					bind: service.path("/Diagnostics/LedStatus/Amber")
					onColor: "#FFBF00"
					radius: 10
				},
				Led {
					bind: service.path("/Diagnostics/LedStatus/Blue")
					onColor: "#0000FF"
					radius: 10
				},
				Led {
					bind: service.path("/Diagnostics/LedStatus/Red")
					onColor: "#FF0000"
					radius: 10
				}
			]
		}

		MbItemOptions {
			description: qsTr("Alarm")
			bind: service.path("/Diagnostics/IoStatus/AlarmOutActive")
			readonly: true
			possibleValues: [
				MbOption { description: qsTr("Active"); value: false },
				MbOption { description: qsTr("None"); value: true }
			]
		}

		MbItemOptions {
			description: qsTr("Main Switch")
			bind: service.path("/Diagnostics/IoStatus/MainSwitchClosed")
			readonly: true
			possibleValues: [
				MbOption { description: qsTr("Open"); value: false },
				MbOption { description: qsTr("Closed"); value: true }
			]
		}

		MbItemOptions {
			description: qsTr("Heater")
			bind: service.path("/Diagnostics/IoStatus/HeaterOn")
			readonly: true

			possibleValues: [
				MbOption { description: qsTr("Off"); value: false },
				MbOption { description: qsTr("On"); value: true }
			]
		}

		MbItemOptions {
			description: qsTr("Internal Fan")
			bind: service.path("/Diagnostics/IoStatus/InternalFanActive")
			readonly: true
			possibleValues: [
				MbOption { description: qsTr("Off"); value: false },
				MbOption { description: qsTr("On"); value: true }
			]
		}

		MbItemValue {
			description: qsTr("Warning Flags")
			item.bind: service.path("/Diagnostics/WarningFlags")
		}

		MbItemValue {
			description: qsTr("Alarm Flags")
			item.bind: service.path("/Diagnostics/AlarmFlags")
		}
	}
}
