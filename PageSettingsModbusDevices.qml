import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root

	property string settings: "com.victronenergy.settings"
	property variant subpage: PageSettingsModbusAddDevice {}
	property VBusItem devicesItem: VBusItem { bind: Utils.path(settings, "/Settings/ModbusClient/tcp/Devices") }

	title: qsTr("Modbus TCP devices")
	model:	stringToDeviceArray(devicesItem.value)
	pageToolbarHandler: user.accessLevel >= User.AccessInstaller ? modbusToolbarHandler : undefined

	ToolbarHandler {
		id: modbusToolbarHandler

		leftText: qsTr("Add")
		rightText: listview.count ? qsTr("Remove") : ""

		function leftAction(isMouse)
		{
			addDevice();
		}

		function rightAction(isMouse)
		{
			removeDevice();
		}
	}

	function stringToDeviceArray(str)
	{
		var a = [];

		if (str !== undefined && str.length) {
			var s = str.split(',');
			for (var i = 0; i < s.length; i++)
				a.push(s[i].split(':'));
		}

		return a;
	}

	function addDevice()
	{
		pageStack.push(subpage);
	}

	function removeDevice()
	{
		var d = model;
		d.splice(currentIndex, 1);

		var a = [];
		for (var i = 0; i < d.length; i++)
			a.push(d[i].join(':'));

		devicesItem.setValue(a.join(','));
	}

	delegate: Component {
		MbItemRow {
			description: qsTr("Device") + " " + (index + 1)
			values: [
				MbTextBlock { item.value: modelData[1]; width: 160 },
				MbTextBlock { item.value: modelData[2]; width: 60 },
				MbTextBlock { item.value: modelData[3]; width: 40 }
			]
		}
	}
}
