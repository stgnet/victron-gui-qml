import QtQuick 1.1

/*
 * Single name / value pair, now equivalent to the more generic:
 *
 * MbItemRow {
 *	description: "test"
 *	values: MbTextValue { bind: "some path" }
 * }
 *
 * But kept around for the time being since it is used a lot.
 */
MbItemRow {
	id: root

	property VBusItem item: VBusItem {}

	// note: the background width resizes with the text
	MbBackgroundRect {
		color: style.backgroundColorComponent
		width: _value.width + 2 * style.marginTextHorizontal
		height: root.height - 2 * style.marginItemVertical

		MbTextValue {
			id: _value
			item: root.item
			anchors.centerIn: parent
		}
	}
}
