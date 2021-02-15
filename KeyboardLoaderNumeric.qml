import QtQuick 1.1

KeyboardLoader {
	rows: 4
	sourceComponent: page1

	Component {
		id: page1

		KeyboardLayout {
			KeyboardRow {
				KeyboardButtonNumeric {
					key: Qt.Key_1
				}
				KeyboardButtonNumeric {
					key: Qt.Key_2
				}
				KeyboardButtonNumeric {
					key: Qt.Key_3
				}
			}

			KeyboardRow {
				KeyboardButtonNumeric {
					key: Qt.Key_4
				}
				KeyboardButtonNumeric {
					key: Qt.Key_5
				}
				KeyboardButtonNumeric {
					key: Qt.Key_6
				}
			}

			KeyboardRow {
				KeyboardButtonNumeric {
					key: Qt.Key_7
				}
				KeyboardButtonNumeric {
					key: Qt.Key_8
				}
				KeyboardButtonNumeric {
					key: Qt.Key_9
				}
			}

			KeyboardRow {
				KeyboardButtonEmpty {
					width: keyboard.buttonWidth * 2
				}
				KeyboardButtonNumeric {
					key: Qt.Key_0
				}
				KeyboardButton {
					visible: !keyboard.overwriteMode
					key: Qt.Key_Backspace
					width: keyboard.buttonWidth * 2
					iconSource: "icon-backspace"
				}
			}
		}
	}
}
