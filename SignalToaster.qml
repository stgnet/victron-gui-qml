import QtQuick 1.1
import "utils.js" as Utils

Item {

	Connections {
		target: storageEvents

		onUncleanDiskUnmount: {
			toast.createToast(qsTr("<b>Disk not ejected properly.</b><br>This can cause data corruption. " +
							  "Next time, press eject in the VRM settings menu before removing the disk."),
							  15000, "icon-items-alert-big-inverted")
		}

		onVrmStorageAttached: {
			var freeSpace = Utils.qtyToString(availableSpace, qsTr("byte"), qsTr("bytes"))
			toast.createToast(qsTr("Using external storage for data logging.<br> Available space: %1").arg(freeSpace),
							  5000, "icon-info-active")
		}

		onVrmStorageError: {
			var msg = ""
			switch(error) {
			case 1:
				msg = qsTr("No space available for data logging on attached storage.")
				break;
			case 4:
				msg = qsTr("Attached storage contains a firmware image, not using for data logging.")
				break;
			default:
				break;
			}
			if (msg !== "")
				toast.createToast(msg, 5000, "icon-info-active")
		}
	}

	// Toast updater notifications
	Connections {
		target: updater
		onNotificationChanged: {
			if (updater.notification !== "")
				toast.createToast(updater.notification, 10000, "icon-firmwareupdate-active")
		}
	}
}

