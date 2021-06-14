import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root

	property string gateway
	property string bindPrefix: Utils.path("dbus/com.victronenergy.vecan.", gateway)

	title: "VE.CAN devices"
	model: VeQItemSortTableModel {
		filterFlags: VeQItemSortTableModel.FilterOffline
		dynamicSortFilter: true

		model: VeQItemTableModel {
			uids: [Utils.path(bindPrefix, "/Devices")]
			flags: VeQItemTableModel.AddChildren |
				   VeQItemTableModel.AddNonLeaves |
				   VeQItemTableModel.DontAddItem
		}
	}
	pageToolbarHandler: helpHandler

	ToolbarHandlerPages {
		id: helpHandler
		leftIcon: "icon-toolbar-info"
		leftText: "Help"
		rightIcon: "icon-toolbar-edit"
		rightText: "Edit"

		function leftAction()
		{
			toast.createToast("Use this menu to see the list of devices on the NMEA2000 / VE.Can" +
							  " network as well as configure their NMEA2000 device instance. " +
							  "Note that this does not change any data instances; read this section " +
							  "for more information: https://ve3.nl/gx-n2k", 120000)
		}

		function rightAction(isMouse)
		{
			if (listview.currentItem)
				listview.currentItem.edit(isMouse)
		}

		function centerAction()
		{
			if (listview.currentItem)
				listview.currentItem.defaultCenterAction()
		}
	}

	delegate: MbSpinBox {
		id: device

		property VBusItem modelName: VBusItem { bind: [model.uid, "/ModelName"] }
		property VBusItem customName: VBusItem { bind: [model.uid, "/CustomName"] }
		property VBusItem uniqueNumber: VBusItem { bind: [model.uid, "/N2kUniqueNumber"] }
		property VBusItem deviceInstance: VBusItem { bind: [model.uid, "/DeviceInstance"] }
		property string uid: model.uid
		property string name: customName.valid && customName.value !== "" ? customName.value : modelName.text

		numOfDecimals: 0
		stepSize: 1

		bind: deviceInstance.bind
		description: name + " <font color='" + (device.isCurrentItem === true ? "#fff" : "#555") + "'>[" + uniqueNumber.text + "]</font>"

		MbTextValue {
			style.isCurrentItem: device.isCurrentItem === true
			item.text: "Device#"
		}

		subpage: Component {
			PageSettingsVecanDevice {
				bindPrefix: device.uid
				title: device.description
			}
		}
	}
}
