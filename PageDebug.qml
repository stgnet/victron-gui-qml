import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	id: root
	title: "Debug"

	model: VisualItemModel {
		MbSubMenu {
			description: qsTr("Power")
			subpage: Component { PagePowerDebug {} }
		}

		MbSubMenu {
			description: qsTr("System data")
			subpage: Component { PageSystemData {} }
		}

		MbSubMenu {
			description: qsTr("Test")
			subpage: Component { PageTest {} }
		}

		MbSubMenu {
			description: qsTr("Values")
			subpage: Component { PageDebugVeQItems {} }
		}

		MbSubMenu {
			description: qsTr("glibc memory")
			subpage: Component { PageDebugMemoryLibc {} }
		}

		MbSubMenu {
			description: qsTr("Qt memory")
			subpage: Component { PageDebugMemoryQt {} }
		}
	}
}
