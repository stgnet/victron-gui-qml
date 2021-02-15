import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	property string bindPrefix
	default property alias content: vModel.children

	model: VisualItemModel {
		id: vModel
		MbItemOptions {
			description: qsTr("Connected")
			bind: Utils.path(root.bindPrefix, "/Connected")
			readonly: true
			editable: false
			possibleValues:[
				MbOption{description: qsTr("No"); value: 0},
				MbOption{description: qsTr("Yes"); value: 1}
			]
		}

		MbItemValue {
			description: qsTr("Connection")
			item.bind: Utils.path(root.bindPrefix, "/Mgmt/Connection")
		}

		MbItemValue {
			description: qsTr("Product")
			item.bind: Utils.path(root.bindPrefix, "/ProductName")
		}

		MbEditBox {
			id: name
			description: qsTr("Name")
			item.bind: Utils.path(root.bindPrefix, "/CustomName")
			show: item.valid
			maximumLength: 32
			enableSpaceBar: true
		}

		MbItemValue {
			description: qsTr("Product ID")
			item.bind: Utils.path(root.bindPrefix, "/ProductId")
		}

		MbItemValue {
			description: qsTr("Firmware version")
			item.bind: Utils.path(root.bindPrefix, "/FirmwareVersion")
		}

		MbItemValue {
			description: qsTr("Hardware version")
			item.bind: Utils.path(root.bindPrefix, "/HardwareVersion")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("VRM instance")
			item.bind: Utils.path(root.bindPrefix, "/DeviceInstance")
		}

		MbItemValue {
			description: qsTr("Serial number")
			item.bind: Utils.path(root.bindPrefix, "/Serial")
			show: item.valid
		}
	}
}
