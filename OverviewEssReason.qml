import QtQuick 1.1
import com.victron.velib 1.0

Rectangle {
	id: reasonBox
	width: reasonText.width * 1.2 + label.width
	height: reasonText.height
	color: "#4b4b4b"
	radius: 3
	visible: systemReason.flags.length > 0

	Text {
		id: label
		text: "ESS"
		width: paintedWidth + 7
		height: parent.height
		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter
		color: "white"
	}

	Rectangle {
		width: reasonText.width * 1.2
		height: reasonText.height
		color: "#1289A7"
		radius: 3
		anchors {
			left: label.right
		}

		Text {
			id: reasonText
			anchors {
				horizontalCenter: parent.horizontalCenter
			}
			color: "white"
			font.pixelSize: 14
			text: systemReason.text

			SystemReason {
				id: systemReason
			}
		}
	}

	Rectangle {
		width: reasonBox.radius
		height: reasonBox.height
		color: "#1289A7"
		anchors {
			left: label.right; leftMargin: -width
		}
	}
}
