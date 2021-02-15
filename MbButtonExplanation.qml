import QtQuick 1.1

Rectangle {
	id: root

	property alias leftRightText: leftRightDescription.text
	property alias upDownText: upDownDescription.text
	property alias centerText: centerDescription.text
	property MbStyle style: MbStyle {}
	property bool shown
	property bool animating
	onShownChanged: animating = true
	height: shown ? 80 : 0

	color: "#fff"

	Behavior on height {
		SequentialAnimation {
			PropertyAnimation {
				duration: 300
			}
			PropertyAnimation { target: root; property: "animating"; to: false }
		}
	}

	Item {
		visible: shown && !animating
		anchors.fill: parent

		Text {
				id: leftRightDescription
				font.family: root.style.fontFamily
				font.pixelSize: 14
				text: qsTr("Select position")

				anchors {
					left: parent.left; leftMargin: 10;
					bottom: parent.bottom; bottomMargin: 1
				}

				MbIcon {
					iconId: "crossleftright"
					anchors{
						horizontalCenter: parent.horizontalCenter
						bottom: parent.top
					}
				}
			}

		Text {
			id: upDownDescription
			font.family: root.style.fontFamily
			font.pixelSize: 14
			text: qsTr("Select character")
			anchors {
				horizontalCenter: parent.horizontalCenter;
				bottom: parent.bottom; bottomMargin: 1
			}

			MbIcon {
				iconId: "crossupdown"
				anchors {
					horizontalCenter: parent.horizontalCenter
					bottom: parent.top
				}
			}
		}

		Text {
			id: centerDescription
			font.family: root.style.fontFamily
			font.pixelSize: 14
			text: qsTr("Apply changes")
			anchors {
				right: parent.right; rightMargin: 10;
				bottom: parent.bottom; bottomMargin: 1
			}

			MbIcon {
				iconId: "crosscenter"
				anchors {
					horizontalCenter: parent.horizontalCenter
					bottom: parent.top
				}
			}
		}
	}
}
