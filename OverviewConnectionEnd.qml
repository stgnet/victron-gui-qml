import QtQuick 1.1

// NOTE: centers around the circle it midpoint
// width and height are bogus!
Item {
	id: root

	property real radius: 5.5
	property alias color: ball.color
	property int connectionSize: 7
	property int connectionLength: 9
	property alias rotation: connection.rotation

	Rectangle {
		id: connection

		transformOrigin: Item.Left
		color: "white"
		width: root.radius + connectionLength
		height: connectionSize
		anchors {
			verticalCenter: ball.verticalCenter
			left: ball.horizontalCenter
		}
	}

	Circle {
		id: ball
		radius: root.radius
		color: "#4789d0"
		x: -radius
		y: -radius

		border {
			width: 2
			color: "white"
		}
	}
}
