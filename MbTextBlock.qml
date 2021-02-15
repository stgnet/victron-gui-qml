import QtQuick 1.1

/*
 * A MbTextValue on top of a MbBlock. The width will expand by default, but can
 * be given. Text overflow will be hidden. The default height is based on a single
 * MbItem height, but can be set.
 */
MbBlock {
	id: root

	property VBusItem item: VBusItem {}

	clip: true // don't draw text outside the block

	MbTextValue {
		id: _textItem
		item: root.item
	}
}
