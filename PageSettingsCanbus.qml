import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root

	property string gateway;

	property string canPrefix: Utils.path("com.victronenergy.settings/Settings/Canbus/", gateway)
	property string vecanSettingsPrefix: Utils.path("com.victronenergy.settings/Settings/Vecan/", gateway)
	property string vecanServicePrefix: Utils.path("com.victronenergy.vecan.", gateway)
	property VBusItem sameUniqueNameUsed: VBusItem {
		bind: Utils.path(vecanServicePrefix, "/Alarms/SameUniqueNameUsed")
		onValueChanged: if (value === 1) timer.running = false
	}
	property bool isVecan: sameUniqueNameUsed.valid

	model: VisualItemModel {
		MbItemCanProfile {
			description: qsTr("CAN-bus profile")
			bind: Utils.path(canPrefix, "/Profile")
			gateway: root.gateway
		}

		MbSubMenu {
			description: qsTr("Devices")
			show: isVecan
			subpage: Component {
				PageSettingsVecanDevices {
					gateway: root.gateway
				}
			}
		}

		MbSwitch {
			bind: Utils.path(vecanSettingsPrefix, "/N2kGatewayEnabled")
			name: qsTr("NMEA2000-out")
			show: isVecan
		}

		MbSpinBox {
			bind: Utils.path(vecanSettingsPrefix, "/VenusUniqueId")
			description: qsTr("Unique identity number selector")
			stepSize: 1
			numOfDecimals: 0
			onExitEditMode: {
				if (changed) {
					toast.createToast(qsTr("Please wait, changing and checking the unique number takes a while"), 5000)
					uniqueCheck.startCheck(30)
				}
			}
			show: isVecan
		}

		MbItemText {
			text: qsTr("Above selector sets which block of unique identity numbers to use " +
						"for the NAME Unique Identity Numbers in the PGN 60928 NAME field. " +
						"Change only when using multiple GX Devices in one VE.Can network")
			wrapMode: Text.Wrap
			show: isVecan
		}

		MbItemText {
			text: qsTr("There is another device connected with this unique number, please select another one.")
			show: sameUniqueNameUsed.value === 1
			wrapMode: Text.Wrap
		}

		MbItemText {
			text: qsTr("OK: No other device is connected with this unique number.")
			show: sameUniqueNameUsed.value === 0 && uniqueCheck.testDone
			wrapMode: Text.Wrap
		}

		MbOK {
			id: uniqueCheck

			property bool testDone

			show: isVecan
			description: qsTr("Check Unique id numbers")
			value: timer.running ? timer.remainingTime + "s" : qsTr("Press to check")
			cornerMark: false
			onClicked: {
				sameUniqueNameUsed.setValue(0)
				startCheck(3)
			}

			function startCheck(timeout)
			{
				timer.remainingTime = timeout
				timer.running = true
				testDone = false
			}

			Timer {
				id: timer

				property int remainingTime

				interval: 1000
				repeat: true
				onTriggered: {
					if (--remainingTime === 0) {
						running = false
						uniqueCheck.testDone = true
					}
				}
			}
		}

		MbSubMenu {
			description: "Network status"
			subpage: Component {
				PageCanbusStatus {
					gateway: root.gateway
					title: root.title
				}
			}
		}
	}
}
