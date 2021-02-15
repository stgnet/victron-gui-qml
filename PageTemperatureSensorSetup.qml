import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	title: qsTr("Temperature sensor setup")

	property string bindPrefix

	model: VisualItemModel {
		MbItemOptions {
			id: tempType
			description: qsTr("Type")
			bind: service.path("/TemperatureType")
			readonly: false
			show: item.valid
			possibleValues: [
				MbOption { description: qsTr("Battery"); value: 0 },
				MbOption { description: qsTr("Fridge"); value: 1 },
				MbOption { description: qsTr("Generic"); value: 2 }
			]
		}

		MbSpinBox {
			description: qsTr("Offset")
			bind: Utils.path(bindPrefix, "/Offset")
			max: 100
			min: -100
			stepSize: 1
			numOfDecimals: 0
			writeAccessLevel: User.AccessSuperUser
			show: userHasWriteAccess
		}

		MbSpinBox {
			description: qsTr("Scale")
			bind: Utils.path(bindPrefix, "/Scale")
			max: 10
			min: 0.10
			stepSize: 0.1
			writeAccessLevel: User.AccessSuperUser
			show: userHasWriteAccess
		}

		MbItemValue {
			description: qsTr("Sensor voltage")
			item.bind: Utils.path(bindPrefix, "/Voltage")
			item.decimals: 2
			item.unit: "V"
		}
	}
}
