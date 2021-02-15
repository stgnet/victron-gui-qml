import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	title: qsTr("Stored backup firmware")
	property string bindPrefix: "com.victronenergy.settings"
	property bool autoUpdateDisabled: autoUpdate.valid && autoUpdate.value !== 1
	property bool switchingEnabled: updater.availableRootfsBuildNumbers[1] !== "" &&
									updater.availableRootfsBuildNumbers[0] !== updater.availableRootfsBuildNumbers[1]

	VBusItem {
		id: autoUpdate
		bind: Utils.path(bindPrefix, "/Settings/System/AutoUpdate")
	}

	model: VisualItemModel {
		MbItemText {
			text: qsTr("This option allows you to switch between the current and the previous firmware version. No internet or sdcard needed.")
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignLeft
		}

		MbOK {
			id: availableVersion
			description: qsTr("Firmware %1 (%2)").arg(updater.availableRootfsVersions[1]).arg(updater.availableRootfsBuildNumbers[1]);
			value: autoUpdateDisabled ? qsTr("Press to boot") : qsTr("Disabled")
			editable: true
			show: switchingEnabled
			onClicked: {
				if (autoUpdateDisabled) {
					updater.switchVersion()
					value = ""
					toast.createToast("Rebooting to %1".arg(updater.availableRootfsVersions[1]), 5000, "icon-restart-active")
				} else {
					toast.createToast("Switching firmware version is not possible when auto update is set to \"Check and update\". " +
									  "Set auto update to \"Disabled\" or \"Check only\" to enable this option.", 10000)
				}
			}
		}

		MbOK {
			id: currentVersion
			description: qsTr("Firmware %1 (%2)").arg(updater.availableRootfsVersions[0]).arg(updater.availableRootfsBuildNumbers[0]);
			value: qsTr("Running")
			editable: false
			show: updater.availableRootfsVersions[0] !== "" && switchingEnabled
		}

		MbItemText {
			text: qsTr("Backup firmware not available")
			show: !currentVersion.show && !availableVersion.show
		}
	}
}
