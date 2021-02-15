import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	property string bindPrefix
	property string bindPage: "/Settings/Alarm/"

	model: VisualItemModel {

		MbRangeSlider {
			description: qsTr("Low state-of-charge")
			unit: "%"
			lowColor: "indianred"
			highColor: "lightgreen"
			lowBind: Utils.path(bindPrefix, bindPage, "LowSoc")
			highBind: Utils.path(bindPrefix, bindPage, "LowSocClear")
			show: valid
		}

		MbRangeSlider {
			description: qsTr("Low battery voltage")
			unit: "V"
			numOfDecimals: 1
			stepSize: 0.1
			lowColor: "indianred"
			highColor: "lightgreen"
			lowBind: Utils.path(bindPrefix, bindPage, "LowVoltage")
			highBind: Utils.path(bindPrefix, bindPage, "LowVoltageClear")
			show: valid
		}

		MbRangeSlider {
			description: qsTr("High battery voltage")
			unit: "V"
			numOfDecimals: 1
			stepSize: 0.1
			lowColor: "lightgreen"
			highColor: "indianred"
			lowBind: Utils.path(bindPrefix, bindPage, "HighVoltageClear")
			highBind: Utils.path(bindPrefix, bindPage, "HighVoltage")
			show: valid
		}

		MbRangeSlider {
			description: qsTr("Low starter battery voltage")
			unit: "V"
			numOfDecimals: 1
			stepSize: 0.1
			lowColor: "indianred"
			highColor: "lightgreen"
			lowBind: Utils.path(bindPrefix, bindPage, "LowStarterVoltage")
			highBind: Utils.path(bindPrefix, bindPage, "LowStarterVoltageClear")
			show: valid
		}

		MbRangeSlider {
			description: qsTr("High starter battery voltage")
			unit: "V"
			numOfDecimals: 1
			stepSize: 0.1
			lowColor: "lightgreen"
			highColor: "indianred"
			lowBind: Utils.path(bindPrefix, bindPage, "HighStarterVoltageClear")
			highBind: Utils.path(bindPrefix, bindPage, "HighStarterVoltage")
			show: valid
		}

		MbRangeSlider {
			description: qsTr("Low battery temperature")
			unit: "K"
			lowColor: "indianred"
			highColor: "lightgreen"
			lowBind: Utils.path(bindPrefix, bindPage, "LowBatteryTemperature")
			highBind: Utils.path(bindPrefix, bindPage, "LowBatteryTemperatureClear")
			show: valid
		}

		MbRangeSlider {
			description: qsTr("High battery temperature")
			unit: "K"
			lowColor: "lightgreen"
			highColor: "indianred"
			lowBind: Utils.path(bindPrefix, bindPage, "HighBatteryTemperatureClear")
			highBind: Utils.path(bindPrefix, bindPage, "HighBatteryTemperature")
			show: valid
		}
	}
}
