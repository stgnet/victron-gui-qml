import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {

	property bool checkOnCompleted: false

	title: qsTr("Install firmware from SD/USB")
	objectName: "offlineFwUpdatePage"

	Component.onCompleted: if (checkOnCompleted) updater.checkOfflineUpdates()

	model: VisualItemModel {
		MbOK {
			id: checkUpdates
			description: qsTr("Check for firmware on SD/USB")
			value: qsTr("Press to check")
			editable: !updater.running
			writeAccessLevel: User.AccessUser
			onClicked: updater.checkOfflineUpdates()
		}

		MbOK {
			id: installUpdate
			description: qsTr("Firmware found")
			value: (updater.running || updater.status === 2) && updater.status !== 0 ?
					   updater.statusDescription : qsTr("Press to install %1").arg(updater.offlineAvailableUpdate)
			editable: !updater.running && !updater.runningOffline && !updater.updateTriggered
			writeAccessLevel: User.AccessUser
			onClicked: updater.doOfflineUpdate()
			show: updater.offlineAvailableUpdate !== ""
		}

		MbItemValue {
			description: qsTr("Firmware build date/time")
			item.value: updater.offlineAvailableUpdateBuild
			show: installUpdate.visible && user.accessLevel >= User.AccessSuperUser
		}
	}

	Timer {
		id: holdStatus
		interval: 10000
		onTriggered: checkUpdates.value = qsTr("Press to check")
	}

	Connections {
		target: updater
		onStatusChanged: {
			if (updater.runningOffline && !updater.updateTriggered) {
				holdStatus.restart()
				checkUpdates.value = updater.status === 0 && updater.offlineAvailableUpdate === "" ?
							qsTr("No firmware found") :
							updater.status === 0 ? qsTr("Press to check") :
												   updater.statusDescription
			}
		}
	}
}
