import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	title: qsTr("Smappee bus devices")

	property string bindPrefix

	model: VeQItemSortTableModel {
		filterFlags: VeQItemSortTableModel.FilterOffline
		model: VeQItemTableModel {
			uids: [Utils.path("dbus/", root.bindPrefix, "/Device")]
			flags: VeQItemTableModel.AddChildren |
				   VeQItemTableModel.AddNonLeaves |
				   VeQItemTableModel.DontAddItem
		}
	}

	delegate: MbSubMenu {
		id: menu
		property int devIndex: model.id
		property VBusItem type: VBusItem {
			bind: [model.uid, "/Type"]
		}
		description: (devIndex + 1) + ": " + type.text
		subpage: Component {
			PageSmappeeDeviceSetup {
				bindPrefix: root.bindPrefix
				devIndex: menu.devIndex
			}
		}
	}
}
