import QtQuick 1.1

Item {
	property string baseColor: keyboard.buttonBaseColor
	property alias text: buttonLabel.text
	property alias iconSource: icon.iconId
	property int key: Qt.Key_unknown

	signal clicked(bool isAutoRepeat)

	width: keyboard.buttonWidth
	height: parent.height

	MouseArea {
		id: mouseArea

		property bool containsPress: mouseArea.containsMouse && mouseArea.pressed

		anchors.fill: parent
		onPressed: keyboard.onButtonPressed(key, false)
		onPressAndHold: timer.start()
		onContainsPressChanged: if (!containsPress) timer.stop() // end repeated click
	}

	// Repeated click on longpress
	Timer {
		id: timer
		interval: 80
		running: false
		repeat: true
		onTriggered: keyboard.onButtonPressed(key, true)
	}

	// The purpose of this inner rectangle is to draw the rounded corners, but we want the mouse area to
	// be the whole (rectangular) button to catch the touches.
	SvgRectangle {
		height: parent.height
		width: parent.width
		color: mouseArea.containsPress ? keyboard.pressedButtonColor : baseColor
		radius: 2

		Text {
			id: buttonLabel
			text: keyboard.lowerCase ? String.fromCharCode(key).toLowerCase() : String.fromCharCode(key).toUpperCase()
			anchors.centerIn: parent
			color: keyboard.buttonTextColor
			font.pixelSize: 16
			visible: !icon.iconId
		}

		MbIcon {
			id: icon
			height: parent.height * 0.6
			width: parent.width * 0.6
			anchors.centerIn: parent
		}
	}
}
