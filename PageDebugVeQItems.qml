import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	id: root

	property string bindPrefix: "dbus"

	title: bindPrefix
	model: VeQItemTableModel {
		uids: [bindPrefix]
		flags: VeQItemTableModel.AddChildren |
			   VeQItemTableModel.AddNonLeaves |
			   VeQItemTableModel.DontAddItem
	}

	delegate: MbSubMenu {
		id: submenu
		description: id
		hasSubpage: subModel.rowCount > 0

		property VeQItemTableModel subModel: VeQItemTableModel {
			uids: [uid]
			flags: root.model.flags
			onRowsInserted: hasSubpage = subModel.rowCount > 0
		}

		Component.onCompleted: {
			item.bind = model.uid
		}

		function open()
		{
			var component = Qt.createComponent("PageDebugVeQItems.qml");
			var page = component.createObject(submenu, {"bindPrefix": uid})
			pageStack.push(page)
		}
	}
}
