import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root

	property string bindPrefix

	model: VisualItemModel {
		MbItemValue {
			description: qsTr("Model Name")
			item.bind: Utils.path(bindPrefix, "/ModelName")
		}

		MbEditBox {
			description: qsTr("Custom Name")
			item.bind: Utils.path(bindPrefix, "/CustomName")
		}

		MbItemText {
			text: qsTr("Careful, for ESS systems, as well as systems with a managed battery, the CAN-bus device " +
				 "instance must remain configured to 0. See GX manual for more information.")
			wrapMode: Text.WordWrap
		}

		MbSpinBox {
			description: "Device Instance"
			bind: Utils.path(bindPrefix, "/DeviceInstance")
			numOfDecimals: 0
			stepSize: 1
		}

		MbItemValue {
			description: qsTr("Manufacturer")
			item.bind: Utils.path(bindPrefix, "/Manufacturer")
		}

		MbItemValue {
			description: qsTr("Network Address")
			item.bind: Utils.path(bindPrefix, "/Nad")
		}

		MbItemValue {
			description: qsTr("Firmware Version")
			item.bind: Utils.path(bindPrefix, "/FirmwareVersion")
		}

		MbItemValue {
			description: qsTr("Serial Number")
			item.bind: Utils.path(bindPrefix, "/Serial")
		}

		MbItemValue {
			description: qsTr("Unique Identity Number ")
			item.bind: Utils.path(bindPrefix, "/N2kUniqueNumber")
		}
	}
}
