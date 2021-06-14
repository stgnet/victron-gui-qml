import QtQuick 1.1
import Qt.labs.components.native 1.0

SvgRectangle {
	id: root

	property alias separatorLine: _separator
	property bool selected: currentIndex !== undefined && currentIndex === index
	property string selectedBgColor: "#D3D3D3"
	property string bgColor: "#FFFFFF"
	property string iconId: ""

	signal clicked

	width: 41
	height: 41
	radius: 5
	color: selected ? selectedBgColor : bgColor
	border { width: 1; color: "black" }

	MbIcon {
		iconId: root.iconId
		anchors.centerIn: parent
	 }

	Rectangle {
		id: _separator
		height: parent.height * 0.7
		width: 1
		color: "black"
		anchors {
			left: parent.right; leftMargin: navigation.spacing / 2
			verticalCenter: parent.verticalCenter
		}
	}

	MouseArea {
		anchors { fill: parent; margins: -5 }
		onClicked: {
			root.clicked()
		}
	}
}
