import QtQuick 1.1
import "utils.js" as Utils

MbPage {
	id: root
	property string bindPrefix

	model: VisualItemModel {
		MbItemValue {
			description: qsTr("Minimum cell voltage")
			item.bind: Utils.path(bindPrefix, "/History/MinimumCellVoltage")
		}

		MbItemValue {
			description: qsTr("Maximum cell voltage")
			item.bind: Utils.path(bindPrefix, "/History/MaximumCellVoltage")
		}
	}
}
