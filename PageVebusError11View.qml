import QtQuick 1.1
import "utils.js" as Utils

MbPage {
	id: root

	property string bindPrefix

	property VBusItem firstCode: VBusItem {
		bind: Utils.path(root.bindPrefix, "/Devices/0/ExtendStatus/GridRelayReport/Code")
	}

	model: VisualItemModel {
		MbItemText {
			text: qsTr("VE.Bus Error 11 reporting requires minimum VE.Bus firmware version 454.")
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignLeft
			show: !firstCode.seen
		}
		PageVebusError11Menu {index: 0; bindPrefix: root.bindPrefix}
		PageVebusError11Menu {index: 1; bindPrefix: root.bindPrefix}
		PageVebusError11Menu {index: 2; bindPrefix: root.bindPrefix}
		PageVebusError11Menu {index: 3; bindPrefix: root.bindPrefix}
		PageVebusError11Menu {index: 4; bindPrefix: root.bindPrefix}
		PageVebusError11Menu {index: 5; bindPrefix: root.bindPrefix}
		PageVebusError11Menu {index: 6; bindPrefix: root.bindPrefix}
		PageVebusError11Menu {index: 7; bindPrefix: root.bindPrefix}
		PageVebusError11Menu {index: 8; bindPrefix: root.bindPrefix}
		PageVebusError11Menu {index: 9; bindPrefix: root.bindPrefix}
		PageVebusError11Menu {index: 10; bindPrefix: root.bindPrefix}
		PageVebusError11Menu {index: 11; bindPrefix: root.bindPrefix}
		PageVebusError11Menu {index: 12; bindPrefix: root.bindPrefix}
		PageVebusError11Menu {index: 13; bindPrefix: root.bindPrefix}
		PageVebusError11Menu {index: 14; bindPrefix: root.bindPrefix}
		PageVebusError11Menu {index: 15; bindPrefix: root.bindPrefix}
		PageVebusError11Menu {index: 16; bindPrefix: root.bindPrefix}
		PageVebusError11Menu {index: 17; bindPrefix: root.bindPrefix}
	}
}
