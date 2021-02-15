import QtQuick 1.1

MbPage {
	title: "Test Tiles"

	model: VisualItemModel {
		TileSpinBox {
			title: qsTr("Brightness")
			width: 200
			readOnly: false
			bind: "com.victronenergy.settings/Settings/Gui/Brightness"
		}
	}
}
