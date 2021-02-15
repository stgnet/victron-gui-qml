import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	title: qsTr("Modbus/TCP")

	property string serviceName: "com.victronenergy.modbustcp"

	VBusItem {
		id: lastError
		bind: Utils.path(serviceName, "/LastError/Message")
	}

	VBusItem {
		id: timestamp
		bind: Utils.path(serviceName, "/LastError/Timestamp")
	}

	model: VisualItemModel {
		MbSwitch {
			id: enableModbusTcp
			name: qsTr("Enable Modbus/TCP")
			bind: "com.victronenergy.settings/Settings/Services/Modbus"
		}

		MbItemText {
			wrapMode: Text.WordWrap
			text: lastError.valid ? lastError.value : qsTr("No errors reported")
			show: enableModbusTcp.checked
		}

		MbItemValue {
			description: qsTr("Time of last error")
			item.value: timestamp.valid ? Qt.formatDateTime(new Date(timestamp.value * 1000), "yyyy-MM-dd hh:mm:ss") : ""
			show: enableModbusTcp.checked && lastError.valid
		}

		MbOK {
			description: qsTr("Clear error")
			value: qsTr("Press to clear")
			show: enableModbusTcp.checked && lastError.valid
			cornerMark: false
			onClicked: {
				lastError.setValue(undefined)
				timestamp.setValue(undefined)
				listview.decrementCurrentIndex()
				listview.decrementCurrentIndex()
			}
		}

		MbSubMenu {
			description: qsTr("Available services")
			show: enableModbusTcp.checked
			subpage: Component {
				PageSettingsModbusTcpServices {}
			}
		}
	}
}
