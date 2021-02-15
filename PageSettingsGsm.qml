import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	title: "GSM"
	property string bindPrefix: "com.victronenergy.modem"
	property string settingsBindPrefix: "com.victronenergy.settings/Settings/Modem"

	VBusItem {
		id: simStatus
		bind: Utils.path(bindPrefix, "/SimStatus")
	}

	VBusItem {
		id: apnSetting
		bind: Utils.path(settingsBindPrefix, "/APN")
	}

	VBusItem {
		id: networkType
		bind: Utils.path(bindPrefix, "/NetworkType")
	}

	function getScaledStrength(strength) {

		if (Utils.between(strength, 0, 3 ))
			return 0
		if (Utils.between(strength, 4, 9))
			return 1
		if (Utils.between(strength, 10, 14))
			return 2
		if (Utils.between(strength, 15, 19) )
			return 3
		if (Utils.between(strength, 21, 31))
			return 4
		return 0
	}

	model: simStatus.valid ? modemConnected : notConnected


	VisualItemModel {
		id: notConnected

		MbItemText {
			text: qsTr("No GSM modem connected")
			show: !simStatus.valid
			style: MbStyle {
				isCurrentItem: true
			}
		}
	}

	VisualItemModel {
		id: modemConnected

		MbItemOptions {
			id: status
			description: qsTr("Internet")
			readonly: true
			bind: Utils.path(bindPrefix, "/Connected")
			unknownOptionText: qsTr("Offline")
			possibleValues:[
				MbOption { description: qsTr("Offline"); value: 0 },
				MbOption { description: qsTr("Online"); value: 1 }
			]
		}

		MbItemValue {
			id: carrier
			description: qsTr("Carrier")
			item.bind: Utils.path(bindPrefix, "/NetworkName")
			item.text: item.valid ? item.value + " " + Utils.simplifiedNetworkType(networkType.value) : "--"
		}

		MbItemRow {
			description: qsTr("Signal strength")
			MbGreyRect {
				width: 32
				height: 28
				anchors.centerIn: undefined
				GsmStatusIcon {
					id: gsmStatusIcon
					height: 18
					color: "#000000"
					showNetworkType: false
					anchors.centerIn: parent
				}
			}
			show: gsmStatusIcon.valid
		}

		MbItemText {
			text: qsTr("It may be necessary to configure the APN settings below in this page, contact your operator for details.\n" +
					   "If that doesn't work, check sim-card in a phone to make sure that there is credit and/or it is registered to be used for data.")
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignHCenter
			show: status.value === 0 && carrier.item.valid && simStatus.value === 1000
		}

		MbSwitch {
			name: qsTr("Allow roaming")
			bind: Utils.path(settingsBindPrefix, "/RoamingPermitted")
			writeAccessLevel: User.AccessUser
		}

		MbItemValue {
			description: qsTr("Sim status")
			item.text: getSimStatusDescription(simStatus.value)
			show: simStatus.valid
		}

		MbEditBox {
			id: passwordInput
			description: qsTr("PIN")
			maximumLength: 35
			item.bind: Utils.path(settingsBindPrefix, "/PIN")
			writeAccessLevel: User.AccessUser
			// Show only when PIN required
			show: item.valid && [11, 16].indexOf(simStatus.value)  > -1
		}

		MbItemValue {
			description: qsTr("IP address")
			item.bind: Utils.path(bindPrefix, "/IP")
			show: status.value === 1
		}

		MbSubMenu {
			description: qsTr("APN")
			item.text: (!apnSetting.valid || apnSetting.value === "") ? qsTr("Default") : apnSetting.value
			subpage: Component {
				MbPage {
					title: qsTr("APN")
					model: VisualItemModel {
						MbSwitch {
							id: useDefaultApn
							name: qsTr("Use default APN")
							checked: apnSetting.value === ""
							valid: true
							onCheckedChanged: {
								if (apnSetting.valid && checked)
									apnSetting.setValue("")
							}
						}
						MbEditBox {
							description: qsTr("APN name")
							item.bind: Utils.path(root.settingsBindPrefix, "/APN")
							visible: !useDefaultApn.checked
							maximumLength: 50
						}
					}
				}
			}
		}

		MbItemValue {
			description: qsTr("IMEI")
			item.bind: Utils.path(bindPrefix, "/IMEI")
			show: item.valid
		}
	}

	function getSimStatusDescription(s)
	{
		switch (s) {
		case 10:
			return qsTr("SIM not inserted")
		case 11:
			return qsTr("PIN required")
		case 12:
			return qsTr("PUK required")
		case 13:
			return qsTr("SIM failure")
		case 14:
			return qsTr("SIM busy")
		case 15:
			return qsTr("Wrong SIM")
		case 16:
			return qsTr("Wrong PIN")
		case 1000:
			return qsTr("Ready")
		case 1001:
			return qsTr("Unknown error")
		default:
			return qsTr("Unknown")
		}
		return "";
	}
}
