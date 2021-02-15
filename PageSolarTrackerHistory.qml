import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root

	property string bindPrefix
	property VBusItem count: VBusItem { bind: Utils.path(bindPrefix, "/History/Overall/DaysAvailable") }
	property VBusItem nrOfTrackers: VBusItem { bind: Utils.path(bindPrefix, "/NrOfTrackers") }

	model: count.valid ? count.value : 1
	delegate: Component {
		MbDispTrackerHistory {
			bindPrefix: Utils.path(root.bindPrefix, "/History/Daily")
			day: index
			trackers: nrOfTrackers.valid ? nrOfTrackers.value : 1
		}
	}
}
