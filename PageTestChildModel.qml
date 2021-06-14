import QtQuick 1.1
import com.victron.velib 1.0

/*
 *
 *
 * dbus com.victronenergy.settings /Settings AddSettings '%[{"path": "Gui/Test/Items/3/Value", "default": 0}]'
 * dbus com.victronenergy.settings /Settings AddSettings '%[{"path": "Gui/Test/Items/4/Value", "default": 4}]'
 *
 * dbus com.victronenergy.settings /Settings RemoveSettings '%["Gui/Test/Items/3/Value", "Gui/Test/Items/4/Value"]'
 */

MbPage {
	title: "Child Model"

	VeQItemSortTableModel {
		id: items

		filterFlags: VeQItemSortTableModel.FilterOffline
		dynamicSortFilter: true

		model: VeQItemTableModel {
			uids: ["dbus/com\.victronenergy\.settings/Settings/Gui/Test/Items"]
			flags:  VeQItemTableModel.AddChildren |
					VeQItemTableModel.DontAddItem |
					VeQItemTableModel.AddNonLeaves
		}
	}

	VeQItemChildModel {
		id: values
		model: items
		childId: "Value"
	}

	VeQItemSortTableModel {
		id: sorted
		model: values
		filterFlags: VeQItemSortTableModel.FilterInvalid
		sortColumn: 1
		dynamicSortFilter: true
	}

	model: sorted

	delegate: MbItemValue {
		width: 480
		description: "item: " + index + " " + model.item.itemParent().id + "/" + model.item.id + " -> " + model.item.value

		MouseArea {
			width: 480
			height: parent.height
		}
	}
}
