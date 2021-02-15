import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	property VBusItem ipAddressesItem: VBusItem { bind: "com.victronenergy.settings/Settings/Fronius/IPAddresses" }

	title: qsTr("IP addresses")
	model: Utils.stringToIpArray(ipAddressesItem.value)
	pageToolbarHandler: user.accessLevel >= User.AccessInstaller ? froniusToolbarHandler : undefined

	ToolbarHandler {
		id: froniusToolbarHandler

		leftText: qsTr("Add")
		rightText: listview.count ? qsTr("Remove") : ""

		function leftAction()
		{
			addAddress()
		}

		function centerAction()
		{
			if (listview.currentItem)
				listview.currentItem.defaultCenterAction()
		}

		function rightAction()
		{
			removeAddress()
		}
	}

	function addAddress()
	{
		var addrs = model;
		addrs.push("192.168.1.1");
		var t = addrs.join(',');
		ipAddressesItem.setValue(t);
		currentIndex = addrs.length - 1;
	}

	function removeAddress()
	{
		var addrs = model;
		addrs.splice(currentIndex, 1);
		var t = addrs.join(',');
		if (currentIndex > 0 && currentIndex >= addrs.length)
			--currentIndex;
		ipAddressesItem.setValue(t);
	}

	delegate: Component {
		MbEditBoxIp {
			description: qsTr("IP address") + " " + (index + 1)
			writeAccessLevel: User.AccessInstaller
			item.value: modelData
			onEditDone: {
				var addrs = Utils.stringToIpArray(ipAddressesItem.value);
				addrs[index] = newValue;
				ipAddressesItem.setValue(addrs.join(','));
			}
		}
	}
}
