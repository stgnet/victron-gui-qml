import QtQuick 1.1

MbBackgroundRect {
	id: greyRect
	height: parent.height
	width: parent.width
	anchors.centerIn: parent
	visible: parent.text !== "" && parent.text !== " "
	z: -1
}
