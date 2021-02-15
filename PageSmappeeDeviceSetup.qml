import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	title: "Device " + (devIndex + 1)

	property string bindPrefix
	property int devIndex
	property string devPrefix: Utils.path(bindPrefix, "/Device/", devIndex)

	model: VisualItemModel {
		MbItemValue {
			description: qsTr("Type")
			item.bind: Utils.path(root.devPrefix, "/Type")
		}

		MbSubMenu {
			description: qsTr("Current transformers")
			item.bind: Utils.path(root.devPrefix, "/Slots")
			subpage: Component {
				MbPage {
					model: VeQItemTableModel {
						uids: [Utils.path("dbus/", root.devPrefix, "/Channel")]
						flags: VeQItemTableModel.AddChildren |
							   VeQItemTableModel.AddNonLeaves |
							   VeQItemTableModel.DontAddItem
					}
					delegate: MbItemValue {
						property VBusItem type: VBusItem {
							bind: Utils.path(bindPrefix, "/CT/", item.value, "/Type")
						}
						description: model.id + ": " + type.text
						item.bind: Utils.path(model.uid, "/Slot")
					}
				}
			}
		}

		MbItemValue {
			description: qsTr("Firmware version")
			item.bind: Utils.path(root.devPrefix, "/FirmwareVersion")
		}

		MbItemValue {
			description: qsTr("Serial number")
			item.bind: Utils.path(root.devPrefix, "/Serial")
		}
	}
}
