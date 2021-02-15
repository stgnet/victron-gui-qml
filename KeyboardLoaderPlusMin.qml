import QtQuick 1.1

KeyboardLoader {
	initialHeight: 42
	sourceComponent: page1

	Component {
		id: page1

		KeyboardLayout {
			KeyboardRow {
				height: 42

				KeyboardButton {
					key: Qt.Key_Down
					text: "-"
					width: height
				}
				KeyboardButtonEmpty {
					width: 2
				}
				KeyboardButton {
					key: Qt.Key_Up
					text: "+"
					width: height
				}
			}
		}
	}
}
