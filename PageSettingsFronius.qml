import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	title: qsTr("PV inverters")
	property string settings: "com.victronenergy.settings"
	property string gateway: "com.victronenergy.fronius"

	VBusItem {
		id: autoDetectItem
		bind: Utils.path(gateway, "/AutoDetect")
	}

	VBusItem {
		id: scanProgressItem
		bind: Utils.path(gateway, "/ScanProgress")
	}

	model: VisualItemModel {
		MbSubMenu {
			id: menuInverters
			description: qsTr("Inverters")
			subpage: Component {
				PageSettingsFroniusInverters { }
			}
		}

		MbOK {
			description: qsTr("Find PV inverters")
			value: autoDetectItem.value ? qsTr("Scanning") + " " + scanProgressItem.text : qsTr("Press to scan")
			writeAccessLevel: User.AccessUser
			onClicked: autoDetectItem.setValue(autoDetectItem.value === 0 ? 1 : 0)
		}

		MbSubMenu {
			description: qsTr("Detected IP addresses")
			subpage: Component {
				PageSettingsFroniusShowIpAdressess { }
			}
		}

		MbSubMenu {
			description: qsTr("Add IP address manually")
			subpage: Component {
				PageSettingsFroniusSetIpAddresses { }
			}
		}

		MbEditBox {
			id: tcpPort
			description: qsTr("TCP port")
			matchString: " 0123456789"
			numericOnlyLayout: true
			show: item.value !== 80
			item.bind: Utils.path(settings, "/Settings/Fronius/PortNumber")

			function editTextToValue() {
				return parseInt(_editText, 10)
			}
		}

		MbSwitch {
			name: qsTr("Automatic scanning")
			bind: Utils.path(settings, "/Settings/Fronius/AutoScan")
		}
	}
}
