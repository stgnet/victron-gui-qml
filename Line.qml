import QtQuick 1.1

PlacementLine {
	// XXX: rotate the placement by 90 degrees, so width = lineWidth?
	property alias lineWidth: rectangle.height
	property alias color: rectangle.color

	Rectangle {
		id: rectangle
		height: 1
		width: parent.width
	}
}
