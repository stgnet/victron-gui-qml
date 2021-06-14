import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	property string bindPrefix

	model: VisualItemModel {
		MbSwitch {
			id: alarmSwitch
			name: qsTr("Enable alarm")
			bind: Utils.path(bindPrefix, "/Enable")
		}

		MbSpinBox {
			description: qsTr("Active level")
			bind: Utils.path(bindPrefix, "/Active")
			min: 0
			max: 100
			unit: "%"
			stepSize: 1
			numOfDecimals: 0
		}

		MbSpinBox {
			description: qsTr("Restore level")
			bind: Utils.path(bindPrefix, "/Restore")
			min: 0
			max: 100
			unit: "%"
			stepSize: 1
			numOfDecimals: 0
		}

		MbSpinBox {
			description: qsTr("Delay")
			bind: Utils.path(bindPrefix, "/Delay")
			min: 0
			max: 60
			unit: "s"
			stepSize: 1
			numOfDecimals: 0
		}
	}
}
