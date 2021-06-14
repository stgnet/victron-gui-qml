import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	title: "Tank Model"

	model: TankModel {}

	delegate: MbItemValue {
		width: 480
		height: 2 * defaultHeight
		description: model.item.value + " " + model.item.itemParent().id + "/" + model.item.id + "\n" +
					 buddy.id

		MouseArea {
			width: 480
			height: parent.height
		}
	}
}
