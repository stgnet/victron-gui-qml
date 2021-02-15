import QtQuick 1.1
import Qt.labs.components.native 1.0
import net.connman 0.1

MbPage {
	id: root
	title: qsTr("Wi-Fi")
	property CmTechnology tech: Connman.getTechnology("wifi")
	model: visualItemModel

	VisualItemModel {
		id: visualItemModel

		MbSwitch {
			name: qsTr("Create access point")
			bind: "com.victronenergy.settings/Settings/Services/AccessPoint"
		}

		MbSubMenu {
			description: qsTr("Wi-Fi networks")
			subpage: Component { PageSettingsWifi {} }
		}
	}
}
