import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	property string bindPrefix: "com.victronenergy.settings"
	property VBusItem autoUpdate: VBusItem { bind: Utils.path(bindPrefix, "/Settings/System/AutoUpdate")}

	model: VisualItemModel {
		MbItemValue {
			description: qsTr("Firmware version")
			item.value: vePlatform.version
		}

		MbItemValue {
			description: qsTr("Build date/time")
			item.value: vePlatform.versionDate
		}

		MbSubMenu {
			description: qsTr("Online updates")
			subpage: Component { PageSettingsFirmwareOnline {} }
		}

		MbSubMenu {
			description: qsTr("Install firmware from SD/USB")
			subpage: Component { PageSettingsFirmwareOffline {} }
		}

		MbSubMenu {
			description: qsTr("Stored backup firmware")
			subpage: Component {
				PageSettingsRootfsSelect {}
			}
		}
	}
}
