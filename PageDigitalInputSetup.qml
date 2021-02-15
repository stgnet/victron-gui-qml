import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	title: qsTr("Setup")

	property string bindPrefix

	model: VisualItemModel {
		MbSwitch {
			id: alarmSwitch
			name: qsTr("Enable alarm")
			bind: Utils.path(bindPrefix, "/AlarmSetting")
		}

		MbSwitch {
			name: qsTr("Inverted")
			bind: Utils.path(bindPrefix, "/InvertTranslation")
		}

		MbSwitch {
			name: qsTr("Invert alarm logic")
			bind: Utils.path(bindPrefix, "/InvertAlarm")
			show: alarmSwitch.checked
		}
	}
}
