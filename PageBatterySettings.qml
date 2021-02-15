import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	property string bindPrefix

	model: VisualItemModel {
		MbSubMenu {
			id: battery
			description: qsTr("Battery")
			subpage: Component {
				PageBatterySettingsBattery {
					title: battery.description
					bindPrefix: root.bindPrefix
				}
			}
		}

		MbSubMenu {
			id: alarms
			description: qsTr("Alarms")
			subpage: Component {
				PageBatterySettingsAlarm {
					title: alarms.description
					bindPrefix: root.bindPrefix
				}
			}
		}

		MbSubMenu {
			id: relay
			description: qsTr("Relay (on battery monitor)")
			subpage: Component {
				PageBatterySettingsRelay {
					title: relay.description
					bindPrefix: root.bindPrefix
				}
			}
		}

		MbItemOptions {
			description: qsTr("Restore factory defaults")
			bind: Utils.path(root.bindPrefix, "/Settings/RestoreDefaults")
			text: qsTr("Press to restore")
			possibleValues: [
				MbOption { description: qsTr("Cancel"); value: 0 },
				MbOption { description: qsTr("Restore"); value: 1 }
			]
		}
	}
}
