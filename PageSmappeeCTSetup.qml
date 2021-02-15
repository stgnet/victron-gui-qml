import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	title: "CT " + (ctIndex + 1)

	property string bindPrefix
	property int ctIndex
	property string ctPrefix: Utils.path(bindPrefix, "/CT/", ctIndex)

	function makeOptionList(names) {
		if (!names)
			return [];

		var comp = Qt.createComponent("MbOption.qml");
		var options = [];

		for (var i = 0; i < names.length; i++) {
			var params = {
				"description": names[i],
				"value": i,
			}
			options.push(comp.createObject(root, params));
		}

		return options;
	}

	VBusItem {
		id: blink
		bind: Utils.path(root.ctPrefix, "/Identify")
	}

	onActiveChanged: blink.setValue(active)

	model: VisualItemModel {
		MbItemOptions {
			id: type
			description: qsTr("Type")
			bind: Utils.path(root.ctPrefix, "/Type")
			property VBusItem types: VBusItem {
				bind: Utils.path(bindPrefix, "/CTTypes")
				onValueChanged: type.possibleValues = makeOptionList(value)
			}
		}

		MbItemOptions {
			description: qsTr("Phase")
			bind: Utils.path(root.ctPrefix, "/Phase")
			possibleValues: [
				MbOption { description: "None"; value: -1 },
				MbOption { description: "L1"; value: 0 },
				MbOption { description: "L2"; value: 1 },
				MbOption { description: "L3"; value: 2 }
			]
		}

		MbSubMenu {
			id: menu
			description: qsTr("Device")
			item.bind: Utils.path(root.ctPrefix, "/Device")
			item.text: item.valid ? item.value + 1 : "--"
			subpage: Component {
				PageSmappeeDeviceSetup {
					bindPrefix: root.bindPrefix
					devIndex: menu.item.value
				}
			}
		}

		MbItemText {
			text: qsTr("Flashing LED indicates this CT")
		}
	}
}
