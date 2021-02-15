import QtQuick 1.1
import "utils.js" as Utils

MbSubMenu {
	id: root

	function name() {
		return "Phase L" + ((index % 3) + 1) + ", device " + (Math.floor(index / 3) + 1) + " (" + index + ")"
	}

	property int index: 0
	property string bindPrefix
	property string devPrefix: Utils.path(root.bindPrefix, "/Devices/", index)

	property VBusItem code: VBusItem {
		bind: Utils.path(devPrefix, "/ExtendStatus/GridRelayReport/Code")
		text: valid ? "0x" + value.toString(16) : invalidText
	}

	property VBusItem counter: VBusItem {
		bind: Utils.path(devPrefix, "/ExtendStatus/GridRelayReport/Count")
		text: valid ? "#" + value : invalidText
	}

	description: name()
	item.value: [counter.text, code.text]
	show: code.valid

	subpage: Component {
		PageVebusError11Device {
			bindPrefix: devPrefix
			title: description
		}
	}
}
