import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	property string bindPrefix: "com.victronenergy.settings"

	title: qsTr("Online updates")

	model: VisualItemModel {
		MbItemOptions {
			id: autoUpdate
			description: qsTr("Auto update")
			bind: Utils.path(bindPrefix, "/Settings/System/AutoUpdate")
			writeAccessLevel: User.AccessUser
			possibleValues: [
				MbOption{description: qsTr("Disabled"); value: 0},
				MbOption{description: qsTr("Check only"); value: 2},
				MbOption{description: qsTr("Check and download only"); value: 3; readonly: true},
				MbOption{description: qsTr("Check and update"); value: 1}
			]
		}

		MbItemOptions {
			description: "Update feed"
			bind: Utils.path(bindPrefix, "/Settings/System/ReleaseType")
			possibleValues: [
				MbOption{description: qsTr("Latest release"); value: Updater.FirmwareRelease},
				MbOption{description: "Latest release candidate"; value: Updater.FirmwareCandidate},
				MbOption{description: "Testing"; value: Updater.FirmwareTesting; readonly: user.accessLevel < User.AccessService},
				MbOption{description: "Develop"; value: Updater.FirmwareDevelop; readonly: true}
			]
		}

		MbOK {
			id: checkUpdates
			description: qsTr("Check for updates")
			value: qsTr("Press to check")
			editable: !updater.running && !updater.runningOffline && !updater.updateTriggered
			writeAccessLevel: User.AccessUser
			onClicked: updater.checkUpdates()
		}

		MbOK {
			id: installUpdate
			description: qsTr("Update available")
			value: (updater.running || updater.status === 2) && updater.status !== 0 ?
					   updater.statusDescription : qsTr("Press to update to %1").arg(updater.availableUpdate)
			editable: !updater.running && !updater.runningOffline && !updater.updateTriggered
			writeAccessLevel: User.AccessUser
			onClicked: updater.doUpdate()
			show: updater.availableUpdate !== ""
		}

		MbItemValue {
			description: qsTr("Update build date/time")
			item.value: updater.availableUpdateBuild
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
			if (updater.running && !updater.updateTriggered) {
				holdStatus.restart()
				checkUpdates.value = updater.status === 0 && updater.availableUpdate === "" ?
							qsTr("No newer version available") :
							updater.status === 0 ? qsTr("Press to check") :
												   updater.statusDescription
			}
		}
	}
}
