import QtQuick 1.1
import "utils.js" as Utils

MbPage {
	id: root
	property string bindPrefix

	// property VBusItem count: VBusItem { bind: bindPrefix + "/Count"}
	// count.valid ? count.value : 0

	model: 4

	delegate: MbSubMenu {
		id: sensorMenu

		property int index: model.index
		description: "AC Sensor " + index

		subpage: Component {
			PageAcSensor {
				title: "AC Sensor " + sensorMenu.index
				bindPrefix: Utils.path(root.bindPrefix, "/", sensorMenu.index)
			}
		}
	}
}
