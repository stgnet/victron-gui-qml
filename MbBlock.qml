import QtQuick 1.1

/*
 * Creates a gray background for values, with the child items vertically center in it.
 * The height defaults to an item height (minus margins) but can be set. The default
 * width adjust to the width of the children. The width can be set as well, but make sure
 * the contents fits..
 */
SvgRectangle {
	id: root

	property MbStyle style: MbStyle {}
	default property alias childs: content.data

	height: style.itemHeight - 2 * style.marginItemVertical
	width: content.childrenRect.width + 2 * style.marginItemHorizontal
	color: style.backgroundColorComponent
	radius: 3

	Row {
		id: content
		anchors {
			horizontalCenter: root.horizontalCenter
			verticalCenter: root.verticalCenter
		}
	}
}
