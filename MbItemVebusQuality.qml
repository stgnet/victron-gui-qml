import QtQuick 1.1
import "utils.js" as Utils

MbItemValue {
	property int index: 0
	property string bindPrefix
	property string devPrefix: Utils.path(bindPrefix, "/Devices/", index)

	function name() {
		return "Phase L" + ((index % 3) + 1) + ", device " + (Math.floor(index / 3) + 1) + " (" + index + ")"
	}

	description: qsTr("Network quality counter %1").arg(name())
	item.bind: Utils.path(devPrefix, "/ExtendStatus/VeBusNetworkQualityCounter")
	show: item.valid
}
