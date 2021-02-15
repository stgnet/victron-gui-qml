import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	title: "Memory allocations"

	property variant info: vePlatform.getMemInfo()

	Timer {
		interval: 1000
		running: true
		repeat: true
		onTriggered: parent.info = vePlatform.getMemInfo()
	}

	model: VisualItemModel {
		MbItemValue {
			description: "Total (incl mmapped)"
			item.value: info.arena + info.hblkhd + info.fsmblks
		}

		MbItemValue {
			description: " |- Non-mmapped space allocated"
			item.value: info.arena
		}

		MbItemValue {
			description: "  |- Total allocated space"
			item.value: info.uordblks
		}

		MbItemRow {
			description: "  |- Total free space"
			MbTextBlock { item.value: info.fordblks / info.arena * 100; item.unit: "%" }
			MbTextBlock { item.value: info.fordblks }
		}

		MbItemValue {
			description: "    |- Top-most, releasable space"
			item.value: info.keepcost
		}

		MbItemValue {
			description: " |-  Space allocated in mmapped regions"
			item.value: info.hblkhd
		}

		MbItemValue {
			description: " |- Space in freed fastbin blocks"
			item.value: info.fsmblks
		}

		MbOK {
			description: "Fragmentate mem"
			onClicked: vePlatform.fragmentateMem()
		}

		MbOK {
			description: "Run an executable"
			onClicked: vePlatform.testExec()
		}

		MbOK {
			description: "Unfragmentate mem"
			onClicked: vePlatform.unfragmentateMem()
		}

		MbOK {
			description: "Dump all mem info?"
			onClicked: vePlatform.dumpAllMemInfo()
		}

		MbOK {
			description: "KILL THE GUI BY -ENOMEM!"
			onClicked: vePlatform.allocAllMem()
		}
	}
}
