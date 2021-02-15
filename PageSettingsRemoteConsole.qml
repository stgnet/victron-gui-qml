import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage
{
	id: root
	title: qsTr("Remote Console")
	property string bindPrefix: "com.victronenergy.settings"

	model: VisualItemModel {
		MbItemText {
			text: qsTr("Manually reboot the GX device after changing these settings. \n \n" +
					   "First time use? Make sure to either set or disable the password check.")
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignLeft
		}

		MbOK {
			id: erasePassword
			description: qsTr("Disable password check")
			onClicked: {
				vePlatform.setRemoteConsolePassword("")
				toast.createToast("Password check has been disabled")
			}
		}

		MbEditBox {
			description: qsTr("Enable password check") + (editMode ? ".    Set password: " : "")
			onEditDone: {
				vePlatform.setRemoteConsolePassword(newValue)
				toast.createToast(newValue === "" ?
							"Password check is disabled" :
							"Password check enabled and the password is set"
						)
				item.value = ""
			}
		}

		MbSwitch {
			id: vncInternet
			name: qsTr("Enable on VRM")
			bind: Utils.path(bindPrefix, "/Settings/System/VncInternet")
		}

		MbItemValue {
			property VBusItem remoteSupportIpAndPort: VBusItem { bind: "com.victronenergy.settings/Settings/System/RemoteSupportIpAndPort" }
			description: qsTr("Remote Console on VRM - status")
			item.value: vncInternet.valid && vncInternet.checked && remoteSupportIpAndPort.valid &&
						remoteSupportIpAndPort.value !== 0 ? qsTr("Online") : qsTr("Offline")
		}

		MbItemText {
			text: qsTr("Security warning: only enable the console on LAN when the GX device is connected to a trusted network.")
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignLeft
		}

		MbSwitch {
			id: vncOnLan
			name: qsTr("Enable on LAN")
			bind: Utils.path(bindPrefix, "/Settings/System/VncLocal")
		}
	}
}
