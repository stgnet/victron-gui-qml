import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	property string meteoSettingsPrefix

	model: VisualItemModel {
		MbItemOptions {
			description: qsTr("Wind speed sensor")
			bind: Utils.path(meteoSettingsPrefix, "/WindSpeedSensor")
			possibleValues: [
				MbOption { description: qsTr("Enabled"); value: "enabled" },
				MbOption { description: qsTr("Disabled"); value: "disabled" },
				MbOption { description: qsTr("Auto-detect"); value: "auto-detect" }
			]
		}

		MbItemOptions {
			description: qsTr("External temperature sensor")
			bind: Utils.path(meteoSettingsPrefix, "/ExternalTemperatureSensor")
			possibleValues: [
				MbOption { description: qsTr("Enabled"); value: "enabled" },
				MbOption { description: qsTr("Disabled"); value: "disabled" },
				MbOption { description: qsTr("Auto-detect"); value: "auto-detect" }
			]
		}
	}
}
