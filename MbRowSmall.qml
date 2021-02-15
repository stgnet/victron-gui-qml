import QtQuick 1.1

/**
 * Perhaps not the most brilliant name, but a MbRowSmall refers to a Row
 * with a short description at the left side and the values(s) at  the right
 * side. NOTE: it is not a MbItem itself, you need MbItemRow.
 */

Item {
	id: root

	property alias description: _description.text
	default property alias values: _values.children
	property alias isCurrentItem: _description.isCurrentItem

	// Hardcoding the width of the ccgx screen for now, so it is possible to
	// resize the image to the actual screen size.
	width: 480
	//width: screen.width

	height: 20

	// The description of the values shown
	MbTextDescription {
		id: _description
		anchors {
			left: root.left; leftMargin: style.marginDefault
			verticalCenter: parent.verticalCenter
		}
	}

	// The actual values
	MbRow {
		id: _values

		anchors {
			right: parent.right; rightMargin: style.marginDefault
			verticalCenter: parent.verticalCenter
		}
	}
}
