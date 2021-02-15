import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	id: root

	property string settings: "com.victronenergy.settings"

	title: qsTr("Add Modbus TCP device")
	pageToolbarHandler: addDeviceToolbarHandler

	ToolbarHandler {
		id: addDeviceToolbarHandler

		leftText: qsTr("Cancel")
		rightText: qsTr("Add")

		function leftAction(isMouse)
		{
			cancel();
		}

		function centerAction()
		{
			if (listview.currentItem)
				listview.currentItem.defaultCenterAction()
		}

		function rightAction(isMouse)
		{
			addDevice();
		}
	}

	function cancel()
	{
		pageStack.pop();
	}

	function addDevice()
	{
		if (!ip.item.valid || ip.item.value === "0.0.0.0") {
			toast.createToast("Invalid IP address", 3000);
			return;
		}

		if (port.item.value < 1 || port.item.value > 65535) {
			toast.createToast("Invalid port number", 3000);
			return;
		}

		if (unit.item.value < 1 || unit.item.value > 247) {
			toast.createToast("Invalid unit address", 3000);
			return;
		}

		var d = ['tcp', ip.item.value, port.item.value, unit.item.value];
		var s = d.join(':');

		if (devicesItem.value.length)
			s = devicesItem.value + ',' + s;

		devicesItem.setValue(s);
		pageStack.pop();
	}

	VBusItem {
		id: devicesItem
		bind: settings + "/Settings/ModbusClient/tcp/Devices"
	}

	model: VisualItemModel {
		MbEditBoxIp {
			id: ip
			description: qsTr("IP address")
		}

		MbEditBox {
			id: port
			description: qsTr("Port")
			item.value: 502
			matchString: "0123456789"
			maximumLength: 5
			numericOnlyLayout: true
			onClicked: item.value = ""
		}

		MbEditBox {
			id: unit
			description: qsTr("Unit")
			item.value: 1
			matchString: "0123456789"
			maximumLength: 3
			numericOnlyLayout: true
			onClicked: item.value = ""
		}
	}
}
