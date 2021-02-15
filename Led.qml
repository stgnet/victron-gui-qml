import QtQuick 1.1

Circle {
	id: root

	property alias item: vItem
	property alias bind: vItem.bind
	property int value: item.valid ? item.value : 0
	property string onColor: "#fff930"
	property bool pulse: false

	radius: 2.5
	color: "#5f5f5f"

	onValueChanged: {
		switch (value) {
		case 0 :
			state = "off"
			break;
		case 1:
			state = "on"
			break;
		case 2:
			state = "blink"
			break;
		case 3:
			state = "blinkInverted"
			break;
		}
	}

	VBusItem { id: vItem }

	SvgRectangle {
		id: lightedRect
		radius: parent.radius
		anchors.fill: parent
		color: onColor
		visible: false
	}

	Timer {
		id: _timer
		interval: 500
		running: item.value > 0
		repeat: true
		onTriggered: pulse = !pulse
	}

	states: [
			State {
				name: "off"
				PropertyChanges { target: lightedRect; visible : false }
			},
			State {
				name: "on"
				PropertyChanges { target: lightedRect; visible : true }
			},
			State {
				name: "blink"
				PropertyChanges { target: lightedRect; visible: pulse}
			},
			State {
				name: "blinkInverted"
				PropertyChanges { target: lightedRect; visible: !pulse }
			}
		]
}

