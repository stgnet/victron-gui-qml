import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	property string service: "com.victronenergy.modbusclient.tcp"
	property string settings: "com.victronenergy.settings/Settings/ModbusClient/tcp"
	property VBusItem scanItem: VBusItem { bind: Utils.path(service, "/Scan") }
	property VBusItem scanProgressItem: VBusItem { bind: Utils.path(service, "/ScanProgress") }

	title: qsTr("Modbus TCP devices")

	model: VisualItemModel {
		MbSwitch {
			name: qsTr("Automatic scanning")
			bind: Utils.path(settings, "/AutoScan")
		}

		MbOK {
			description: qsTr("Scan for devices")
			value: scanItem.value ? qsTr("Scanning") + " " + scanProgressItem.text : qsTr("Press to scan")
			onClicked: scanItem.setValue(!scanItem.value)
			show: userHasWriteAccess
		}

		MbSubMenu {
			description: qsTr("Devices")
			subpage: Component {
				PageSettingsModbusDevices { }
			}
		}
	}
}
