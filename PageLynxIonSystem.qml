import QtQuick 1.1
import "utils.js" as Utils

MbPage {
	id: root
	property string bindPrefix

	model: VisualItemModel {
		MbItemValue {
			description: qsTr("Capacity")
			item.bind: Utils.path(bindPrefix, "/Capacity")
			show: item.valid
		}

		MbItemValue {
			description: qsTr("Batteries")
			item.bind: Utils.path(bindPrefix, "/System/NrOfBatteries")
		}

		MbItemValue {
			description: qsTr("Parallel")
			item.bind: Utils.path(bindPrefix, "/System/BatteriesParallel")
		}

		MbItemValue {
			description: qsTr("Series")
			item.bind: Utils.path(bindPrefix, "/System/BatteriesSeries")
		}

		MbItemRow {
			description: qsTr("Min/max cell voltage")
			values: [
				MbTextBlock {
					id: minCellVoltage
					item.bind: service.path("/System/MinCellVoltage")
					width: 60
					height: 25
				},
				MbTextBlock {
					id: maxCellVoltage
					item.bind: service.path("/System/MaxCellVoltage")
					width: 60
					height: 25
				}
			]
			show: minCellVoltage.item.valid && maxCellVoltage.item.valid
		}

		MbItemRow {
			description: qsTr("Min/max cell temperature")
			values: [
				MbTextBlock {
					id: minCellTemperature
					item.bind: service.path("/System/MinCellTemperature")
					item.unit: "°C"
					width: 60
					height: 25
				},
				MbTextBlock {
					id: maxCellTemperature
					item.bind: service.path("/System/MaxCellTemperature")
					item.unit: "°C"
					width: 60
					height: 25
				}
			]
			show: minCellTemperature.item.valid && maxCellTemperature.item.valid
		}

		MbItemOptions {
			description: qsTr("Balancing")
			bind: Utils.path(bindPrefix, "/Balancing")
			readonly: true
			possibleValues:[
				MbOption{description: qsTr("Inactive"); value: 0},
				MbOption{description: qsTr("Active"); value: 1}
			]
		}
	}
}
