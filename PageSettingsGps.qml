import QtQuick 1.1

MbPage {
	model: VisualItemModel {
		MbItemOptions {
			id: format
			description: qsTr("Format")
			bind: "com.victronenergy.settings/Settings/Gps/Format"
			possibleValues: [
				MbOption {description: qsTr("52° 20' 41.6\" N, 5° 13' 12.3\" E"); value: 0},
				MbOption {description: qsTr("52.34489, 5.22008"); value: 1},
				MbOption {description: qsTr("52° 20.693 N, 5° 13.205 E"); value: 2}
			]
		}

		MbItemOptions {
			id: speedUnit
			description: qsTr("Speed Unit")
			bind: "com.victronenergy.settings/Settings/Gps/SpeedUnit"
			possibleValues: [
				MbOption {description: qsTr("Kilometres per hour"); value: "km/h"},
				MbOption {description: qsTr("Metres per second"); value: "m/s"},
				MbOption {description: qsTr("Miles per hour"); value: "mph"},
				MbOption {description: qsTr("Knots"); value: "kt"}
			]
		}
	}
}
