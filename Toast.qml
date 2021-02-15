import QtQuick 1.1

/* This element creates a toast message like in android devices */

Rectangle {
	id: root
	width: _message.width + _icon.width + 20
	height: Math.max(_icon.height, _message.height) + 15
	color: "#4f4f4f"
	opacity: hideTimer.running
	visible: message != ""
	radius: 8
	smooth: true

	property alias icon: _icon.iconId
	property string message
	property int duration: 2000
	property bool _hideOnKeyPress: true
	property MbStyle style: MbStyle {}

	anchors {
		horizontalCenter: parent.horizontalCenter;
		bottom: parent.bottom; bottomMargin: parent.height / 4
	}

	MouseArea {
		x: -parent.x
		y: -parent.y
		width: screen.width
		height: screen.height
		onClicked: message = ""
	}

	Behavior on opacity {
		NumberAnimation { id: opacityAnimation; duration: 500 }
	}

	Connections {
		target: QuickView
		onKeyPressed: {
			if (hideTimer.running) {
				if (_hideOnKeyPress) {
					hideTimer.stop()
					QuickView.keyAccepted()
				}
				_hideOnKeyPress = true
			}
		}
	}

	Timer {
		id: hideTimer
		interval: duration
	}

	MbIcon {
		id: _icon
		anchors {
			left: parent.left; leftMargin: 8
			verticalCenter: parent.verticalCenter
		}
	}

	Text {
		id: _message
		text: message
		font.pixelSize: root.style.fontPixelSize
		horizontalAlignment: Text.AlignHCenter
		color: "#fff"
		anchors {
			verticalCenter: parent.verticalCenter
			left: _icon.right; leftMargin: _icon.width > 1 ? 10 : 0
		}
	}

	function createToast(message, duration, icon, hideOnKeyPress) {
		adjustTextWidth(message)
		root.duration = duration === undefined ? 2000 : duration
		root.icon = icon === undefined ? "" : icon
		if (hideOnKeyPress !== undefined)
			root._hideOnKeyPress = hideOnKeyPress

		hideTimer.running = true
		hideTimer.restart()
	}


	function adjustTextWidth(message)
	{
		var maxWidht = 380
		// Reset text width and wrap mode
		_message.width = undefined
		_message.wrapMode = Text.NoWrap
		root.message = message
		var w = Math.min(maxWidht, _message.paintedWidth)
		_message.width = w
		_message.wrapMode = _message.width === maxWidht ? Text.WordWrap : Text.NoWrap
	}
}
