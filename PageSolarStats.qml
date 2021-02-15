import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root

	property string bindPrefix

	model: statsModel.hasStats() ? statsModel : noStatsModel

	VisualItemModel {
		id: noStatsModel

		MbItemText {
			text: qsTr("No statistics available")
		}
	}

	VisualItemModel {
		id: statsModel

		function hasStats() {
			for (var i = 0; i < statsModel.children.length; i++) {
				if (statsModel.children[i].show)
					return true
			}
			return false
		}

		MbItemValue {
			id: maxPvVoltage
			description: qsTr("Maximum PV voltage")
			item.bind: Utils.path(bindPrefix, "/History/Overall/MaxPvVoltage")
			show: item.valid
		}

		MbItemValue {
			id: maxBatteryVoltage
			description: qsTr("Maximum battery voltage")
			item.bind: Utils.path(bindPrefix, "/History/Overall/MaxBatteryVoltage")
			show: item.valid
		}

		MbItemValue {
			id: minBatteryVoltage
			description: qsTr("Minimum battery voltage")
			item.bind: Utils.path(bindPrefix, "/History/Overall/MinBatteryVoltage")
			show: item.valid
		}

		MbItemChargerError {
			id: lastError1
			description: qsTr("Last error")
			item.bind: Utils.path(bindPrefix, "/History/Overall/LastError1")
			show: item.valid || lastError2.show || lastError3.show || lastError4.show
		}

		MbItemChargerError {
			id: lastError2
			description: qsTr("2nd Last Error")
			item.bind: Utils.path(bindPrefix, "/History/Overall/LastError2")
			show: item.valid || lastError3.show || lastError4.show
		}

		MbItemChargerError {
			id: lastError3
			description: qsTr("3rd Last Error")
			item.bind: Utils.path(bindPrefix, "/History/Overall/LastError3")
			show: item.valid || lastError4.show
		}

		MbItemChargerError {
			id: lastError4
			description: qsTr("4th Last Error")
			item.bind: Utils.path(bindPrefix, "/History/Overall/LastError4")
			show: item.valid
		}
	}
}
