import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	property string bindPrefix
	property string bindPage: "/Settings/Battery/"
	property bool locked: lock.valid && lock.value

	VBusItem {
		id: lock
		bind: Utils.path(bindPrefix, bindPage, "Locked")
	}

	model: VisualItemModel {
		MbItemOptions {
			description: qsTr("Nominal Voltage")
			bind: Utils.path(bindPrefix, bindPage, "NominalVoltage")
			possibleValues: [
				MbOption { description: qsTr("12 Volt"); value: 12 },
				MbOption { description: qsTr("24 Volt"); value: 24 },
				MbOption { description: qsTr("48 Volt"); value: 48 }
			]
			show: valid
		}

		MbSpinBox {
			description: qsTr("Capacity")
			bind: Utils.path(bindPrefix, bindPage, "Capacity")
			unit: "Ah"
			readOnly: locked
			numOfDecimals: 0
			stepSize: 1
			show: valid
		}

		MbSpinBox {
			description: qsTr("Charged voltage")
			bind: Utils.path(bindPrefix, bindPage, "ChargedVoltage")
			unit: "V"
			readOnly: locked
			numOfDecimals: 1
			stepSize: 0.1
			show: valid
		}

		MbSpinBox {
			description: qsTr("Tail current")
			bind: Utils.path(bindPrefix, bindPage, "TailCurrent")
			unit: "%"
			readOnly: locked
			numOfDecimals: 1
			stepSize: 0.1
			show: valid
		}

		MbSpinBox {
			description: qsTr("Charged detection time")
			bind: Utils.path(bindPrefix, bindPage, "ChargedDetectionTime")
			unit: "min"
			readOnly: locked
			numOfDecimals: 0
			stepSize: 1
			show: valid
		}

		MbSpinBox {
			description: qsTr("Peukert exponent")
			bind: Utils.path(bindPrefix, bindPage, "PeukertExponent")
			readOnly: locked
			numOfDecimals: 2
			stepSize: 0.01
			show: valid
		}

		MbSpinBox {
			description: qsTr("Charge efficiency factor")
			bind: Utils.path(bindPrefix, bindPage, "ChargeEfficiency")
			unit: "%"
			readOnly: locked
			numOfDecimals: 0
			stepSize: 1
			show: valid
		}

		MbSpinBox {
			description: qsTr("Current threshold")
			bind: Utils.path(bindPrefix, bindPage, "CurrentThreshold")
			unit: "A"
			readOnly: locked
			numOfDecimals: 2
			stepSize: 0.01
			show: valid
		}

		MbSpinBox {
			description: qsTr("Time-to-go averaging period")
			bind: Utils.path(bindPrefix, bindPage, "TTGAveragingPeriod")
			unit: "min"
			readOnly: locked
			numOfDecimals: 0
			stepSize: 1
			show: valid
		}

		MbItemText {
			text: qsTr("Note that changing the Time-to-go discharge floor setting " +
				"also changes the Low state-of-charge setting in the relay menu")
			wrapMode: Text.WordWrap
			show: dischargeFloorLinkedToRelay.valid && dischargeFloorLinkedToRelay.value !== 0

			VBusItem {
				id: dischargeFloorLinkedToRelay
				bind: Utils.path(bindPrefix, "/Settings/", "DischargeFloorLinkedToRelay")
			}
		}

		MbSpinBox {
			description: qsTr("Time-to-go discharge floor")
			bind: Utils.path(bindPrefix, bindPage, "DischargeFloor")
			unit: "%"
			readOnly: locked
			numOfDecimals: 0
			stepSize: 1
			show: valid
		}

		MbItemValue {
			description: qsTr("Current offset")
			item.bind: Utils.path(bindPrefix, bindPage, "CurrentOffset")
			show: user.accessLevel >= User.AccessService && item.valid
		}

		MbOK {
			description: qsTr("Synchronise state-of-charge to 100%")
			value: qsTr("Press to sync")
			editable: !locked
			cornerMark: false
			onClicked: sync.setValue(1)
			show: sync.valid

			VBusItem {
				id: sync
				bind: Utils.path(bindPrefix, bindPage, "Synchronize")
			}
		}

		MbOK {
			description: qsTr("Calibrate zero current")
			value: qsTr("Press to set to 0")
			editable: true
			cornerMark: false
			onClicked: zero.setValue(1)
			show: zero.valid

			VBusItem {
				id: zero
				bind: Utils.path(bindPrefix, bindPage, "ZeroCurrent")
			}
		}
	}
}
