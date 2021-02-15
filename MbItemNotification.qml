import QtQuick 1.1
import Qt.labs.components.native 1.0

MbItem {
	id: root
	height: 70
	width: pageStack ? pageStack.currentPage.width : 0
	editable: false

	property bool active
	property string type
	property string devicename
	property string date
	property string description
	property string value

	Item {
		id: iconRect
		width: 70
		height: parent.height

		MbIcon {
			id: alertIcon
			iconId: "icon-items-alert-big" + (root.ListView.isCurrentItem ? "-inverted": "")
			anchors.centerIn: iconRect
			opacity: opacityFader.value

			Timer {
				id: opacityFader
				property double value: 0.2 + Math.abs(Math.sin(Math.PI / _loops * _counter))
				property int _counter
				property int _loops: 5

				interval: 200
				running: active
				repeat: true
				onTriggered: if (_counter >= (_loops - 1)) _counter = 0; else _counter++
			}
		}
	}

	Rectangle {
		id: iconSeparator
		height: parent.height - 10
		width: 1
		anchors {
			verticalCenter: iconRect.verticalCenter
			left: iconRect.right

		}
		color: root.ListView.isCurrentItem ? "white" : "black"
	}

	MbTextDescription {
		id: device
		anchors {
			left: iconRect.right; leftMargin: 5
			top: root.top; topMargin: 5
		}
		font.pixelSize: 18
		text: root.devicename
	}

	MbTextDescription {
		id: type
		anchors {
			left: device.left;
			top: device.bottom
		}
		font.pixelSize: 18
		text: root.type
	}

	MbTextDescription {
		id: name
		anchors {
			left: type.left
			top: type.bottom
		}
		font.pixelSize: 18
		text: root.description
	}

	MbTextDescription {
		id: date
		anchors {
			right: value.right;
			verticalCenter: type.verticalCenter
		}
		text: root.date
	}

	MbTextDescription {
		id: value
		anchors {
			right: root.right; rightMargin: style.marginDefault
			verticalCenter: name.verticalCenter
		}
		font.pixelSize: 18
		text: root.value
	}
}
