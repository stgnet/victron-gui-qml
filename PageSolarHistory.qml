import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root

	property string bindPrefix
	property VBusItem count: VBusItem { bind: Utils.path(bindPrefix, "/History/Overall/DaysAvailable") }

	model: count.valid ? count.value : 2
	delegate: Component {
		MbDispSolarHistory {
			bindPrefix: Utils.path(root.bindPrefix, "/History/Daily")
			day: index
			fullHistory: count.valid
		}
	}

	//onCurrentIndexChanged: listview.positionViewAtIndex(currentIndex, ListView.Beginning)
}
