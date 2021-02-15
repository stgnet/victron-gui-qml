import QtQuick 1.1

// Display the mentioned text and size the item accordingly in height.
MbItem {
	id: root

	property alias text: textField.text
	property alias wrapMode: textField.wrapMode
	property alias horizontalAlignment: textField.horizontalAlignment
	property int heightInItems: Math.ceil(textField.paintedHeight / style.itemHeight)

	height: heightInItems * style.itemHeight
	editable: false

	MbTextValue {
		id: textField
		anchors {
			left: parent.left; leftMargin: style.marginDefault
			right: parent.right; rightMargin: style.marginDefault
			verticalCenter: parent.verticalCenter
		}
		horizontalAlignment: Text.AlignHCenter
		style: root.style
	}
}
