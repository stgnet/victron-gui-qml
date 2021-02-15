import QtQuick 1.1

Text {
	font.pixelSize: 14
	color: "white"
	width: parent.width
	height: visible ? paintedHeight : 0
	visible: text !== ""
	horizontalAlignment: Text.AlignHCenter
	verticalAlignment: Text.AlignVCenter
	wrapMode: Text.WordWrap
}
