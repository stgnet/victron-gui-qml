import QtQuick 1.1

/*
 * This object will places its children vertically centered on a line
 * between two _arbitrary_ points. Hence the children must have a height
 * set. If the width of the children is set to parent.width, they will
 * span the space between the two points.
 *
 * The points can be set with either (x1, y1) / (x2, y2) or by setting
 * the from and to objects. With a bit of fantasy it is like this:
 *
 *
 *                         /
 *              (x1,y1) -*   \      width: parent.width
 *                     /       \
 *                       \       \
 *                         \       \
 *                           \       /
 *                             \   *- (x2,y2)
 *                               /    (height is set by children)
 *
 * Or to make it a bit easier to understand, if the child is set to a
 * rectangle with height one, this is called a line.
 */

Item {
	id: root

	width: Math.abs(dx) + 1
	height: Math.abs(dy) + 1
	x: x2 < x1 ? x2 : x1
	y: y2 < y1 ? y2 : y1

	property alias diagonal: content.width

	default property alias children: content.children
	property real x1: from.x
	property real y1: from.y
	property real x2: to.x
	property real y2: to.y

	// optional, drawing something between any object having an x and y
	property variant from: Qt.point(0, 0)
	property variant to: Qt.point(0, 0)

	property real dy: y2 - y1
	property real dx: x2 - x1

	Item {
		id: content
		rotation: Math.atan2(dy, dx) * (180 / Math.PI)
		width: Math.sqrt(root.width * root.width + root.height * root.height)
		height: childrenRect.height
		anchors.centerIn: root
	}
}
