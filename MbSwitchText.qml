import QtQuick 1.1
import com.victron.velib 1.0

MbItem {
	id: root

	property VBusItem item: VBusItem {}
	property alias name: name.text

	property bool checked: (item.valid && item.value !== valueFalse) ^ invertSense
	property bool enabled: item.valid && root.userHasWriteAccess

	property variant valueTrue: 1
	property variant valueFalse: 0
	property bool invertSense: false

	property alias onText: onLabel.text
	property alias offText: offLabel.text

	signal editDone(string newValue)

	MbTextDescription {
		id: name
		anchors {
			left: parent.left; leftMargin: style.marginDefault
			verticalCenter: parent.verticalCenter
		}
	}

	SvgRectangle {
		height: 26
		border.color: "#fff"
		border.width: 2
		color: checked ? "#4790d0" : "#ddd"
		radius: 20
		width: spacer.width + 8

		anchors {
			right: parent.right; rightMargin: 10
			verticalCenter: parent.verticalCenter
		}

		Rectangle {
			id: spacer
			width: Math.max(onLabel.width, offLabel.width, 26) + knob.width + 6
			height: parent.height
			anchors.centerIn: parent
			color: "transparent"
			state: root.checked ? "checked" : "unchecked"

			Text {
				id: onLabel

				visible: checked
				anchors {
					verticalCenter: parent.verticalCenter
					horizontalCenter: parent.horizontalCenter; horizontalCenterOffset: -knob.width / 2
				}
				color: "#fff"
				font.family: root.style.fontFamily
				font.pixelSize: root.style.fontPixelSize
			}

			Text {
				id: offLabel

				visible: !checked
				anchors {
					verticalCenter: parent.verticalCenter
					horizontalCenter: parent.horizontalCenter; horizontalCenterOffset: knob.width / 2
				}
				color: "#000"
				font.family: root.style.fontFamily
				font.pixelSize: root.style.fontPixelSize
			}

			Circle {
				id: knob
				radius: 9
				color: root.enabled ? "#fff" : "#ccc"
				anchors.verticalCenter: parent.verticalCenter
			}

			states: [
				State {
					name: "unchecked"
					PropertyChanges { target: knob; x: 0 }
				},
				State {
					name: "checked"
					PropertyChanges { target: knob; x: spacer.width - knob.width}
				}
			]

			transitions: [
				Transition {
					SmoothedAnimation { properties: "x"; velocity: 500; maximumEasingTime: 0 }
				}
			]
		}
	}

	function onEditAttemptWhenDisabled()
	{
	}

	function edit(isMouse) {
		if (enabled) {
			var newValue = checked ^ invertSense ? valueFalse : valueTrue
			item.setValue(newValue)
			editDone(newValue)
		} else {
			onEditAttemptWhenDisabled()
		}
	}
}
