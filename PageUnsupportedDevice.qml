import QtQuick 1.1
import "utils.js" as Utils

MbPage {
	id: root
	title: service.description
	summary: qsTr("Unsupported")
	property variant service
	property string bindPrefix

	model: VisualItemModel {
		MbItemText {
			property VBusItem reason: VBusItem { bind: Utils.path(root.bindPrefix, "/Reason"); invalidText: "" }

			text: qsTr("Unsupported device found") + (reason.text ? ": " + reason.text : "")
			wrapMode: Text.Wrap
		}

		MbSubMenu {
			description: qsTr("Device")
			subpage: Component {
				PageDeviceInfo {
					title: root.title
					bindPrefix: root.bindPrefix
				}
			}
		}
	}
}
