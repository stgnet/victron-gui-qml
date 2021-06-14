import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	id: pageGateway

	model: VisualItemModel {
		MbItemValue {
			description: qsTr("Hostname")
			item.value: Qwacs.hostname
		}

		MbItemValue {
			description: qsTr("Uplink Status")
			item.value: Qwacs.uplinkStatus
			showAccessLevel: User.AccessService
		}

		MbSwitch {
			id: uplinkOnOff
			name: qsTr("Uplink")
			checked: Qwacs.uplink
			enabled: true
			Binding {
				target: Qwacs
				property: "uplink"
				value: uplinkOnOff.checked
			}
			showAccessLevel: User.AccessService
		}

		MbItemValue {
			description: qsTr("Common Name")
			item.value: Qwacs.commonName
			showAccessLevel: User.AccessService
		}

		MbItemValue {
			description: qsTr("Firmware Version")
			item.value: Qwacs.firmwareVersion
		}

		MbItemValue {
			description: qsTr("Architecture Flavor Version")
			item.value: Qwacs.archFlavVers
		}

		MbItemValue {
			description: qsTr("Serial Number")
			item.value: Qwacs.serialNr
		}

		MbItemValue {
			description: qsTr("Part Number")
			item.value: Qwacs.partNr
		}

		MbItemValue {
			description: qsTr("Days up")
			item.value: Qwacs.updays
			showAccessLevel: User.AccessService
		}

		MbItemValue {
			description: qsTr("Hours up")
			item.value: Qwacs.uphours
			showAccessLevel: User.AccessService
		}
	}
}
