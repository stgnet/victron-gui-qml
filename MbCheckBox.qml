import QtQuick 1.1

MbItemRow {
	id: root

	property bool checked
	default property alias values: root.data

	data: [
		MouseArea {
			id: mouseArea
			anchors.fill: parent
			onClicked: { select(); toggle() }
		}
	]

	Circle {
		radius: 10
		border.width: 2
		color: "#fff"
		border.color: "#777"

		Circle {
			radius: parent.radius / 2
			color: parent.border.color
			anchors.centerIn: parent
			visible: checked
		}
	}

	function toggle() { checked = !checked }
	Keys.onSpacePressed: { toggle() }
}
