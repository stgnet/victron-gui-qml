import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	property string cgwacsPath: "com.victronenergy.settings/Settings/CGwacs"
	property int hub4Disabled: 3

	VBusItem {
		id: hub4Mode
		bind: Utils.path(cgwacsPath, "/Hub4Mode")
	}

	model: VisualItemModel {
		MbSwitch {
			id: acFeedin
			name: qsTr("AC-coupled PV - feed in excess")
			bind: Utils.path(cgwacsPath, "/PreventFeedback")
			show: hub4Mode.value !== hub4Disabled
			enabled: userHasWriteAccess
			invertSense: true
		}

		MbSwitch {
			id: feedInDc
			VBusItem {
				id: vebusPath
				bind: "com.victronenergy.system/VebusService"
			}
			VBusItem {
				id: doNotFeedInvOvervoltage
				bind: Utils.path(vebusPath.value, "/Hub4/DoNotFeedInOvervoltage")
			}
			name: qsTr("DC-coupled PV - feed in excess")
			bind: "com.victronenergy.settings/Settings/CGwacs/OvervoltageFeedIn"
			show: hub4Mode.value !== hub4Disabled && doNotFeedInvOvervoltage.valid
			enabled: userHasWriteAccess
		}

		MbSwitch {
			id: restrictFeedIn
			name: qsTr("Limit system feed-in")
			show: acFeedin.checked || feedInDc.checked
			checked: maxFeedInPower.value >= 0
			enabled: userHasWriteAccess
			onCheckedChanged: {
				if (checked && maxFeedInPower.value < 0)
					maxFeedInPower.item.setValue(1000)
				else if (!checked && maxFeedInPower.value >= 0)
					maxFeedInPower.item.setValue(-1)
			}
		}

		MbSpinBox {
			id: maxFeedInPower
			description: qsTr("Maximum feed-in")
			enabled: userHasWriteAccess
			show: restrictFeedIn.show && restrictFeedIn.checked
			bind: Utils.path(cgwacsPath, "/MaxFeedInPower")
			numOfDecimals: 0
			unit: "W"
			min: 0
			max: 300000
			stepSize: 100
		}

		MbItemValue {
			VBusItem {
				id: pvPowerLimiterActive
				bind: "com.victronenergy.hub4/PvPowerLimiterActive"
			}
			description: qsTr("Feed-in limiting active")
			show: hub4Mode.value !== hub4Disabled && pvPowerLimiterActive.valid
			item.value: pvPowerLimiterActive.value === 0 ? qsTr("No") : qsTr("Yes")
		}
	}
}
