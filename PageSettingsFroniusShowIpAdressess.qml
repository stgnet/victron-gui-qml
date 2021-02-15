import QtQuick 1.1

import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	property string settingsPrefix: "com.victronenergy.settings"
	property VBusItem ipAddressesItem: VBusItem { bind: Utils.path(settingsPrefix, "/Settings/Fronius/KnownIPAddresses") }
	property VBusItem scanItem: VBusItem { bind: "com.victronenergy.fronius/AutoDetect" }

	title: qsTr("Detected IP addresses")
	model: Utils.stringToIpArray(ipAddressesItem.value)
	pageToolbarHandler: user.accessLevel >= User.AccessInstaller ? froniusToolbarHandler : undefined

	ToolbarHandler {
		id: froniusToolbarHandler

		leftText: qsTr("Rescan")
		rightText: listview.count ? qsTr("Remove") : ""

		function leftAction(isMouse)
		{
			rescan()
		}

		function rightAction(isMouse)
		{
			removeHost()
		}
	}

	function removeHost()
	{
		var d = model
		d.splice(currentIndex, 1)
		ipAddressesItem.setValue(d.join(','))
	}

	function rescan()
	{
		ipAddressesItem.setValue('')
		scanItem.setValue(1)
	}

	delegate: Component {
		MbItemValue {
			description: qsTr("IP address") + " " + (index + 1)
			item.value: modelData
		}
	}
}
