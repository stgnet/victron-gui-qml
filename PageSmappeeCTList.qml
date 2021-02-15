import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	title: qsTr("Current transformers")

	property string bindPrefix

	model: VeQItemTableModel {
		uids: [Utils.path("dbus/", root.bindPrefix, "/CT")]
		flags: VeQItemTableModel.AddChildren |
			   VeQItemTableModel.AddNonLeaves |
			   VeQItemTableModel.DontAddItem
	}

	delegate: MbSubMenu {
		id: menu
		property int ctIndex: model.id
		property VBusItem type: VBusItem {
			bind: [model.uid, "/Type"]
		}
		item.bind: Utils.path(model.uid, "/Phase")
		description: (ctIndex + 1) + ": " + type.text
		subpage: Component {
			PageSmappeeCTSetup {
				bindPrefix: root.bindPrefix
				ctIndex: menu.ctIndex
			}
		}
	}
}
