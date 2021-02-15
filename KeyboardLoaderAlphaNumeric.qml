import QtQuick 1.1

KeyboardLoader {
	rows: 4
	sourceComponent: keyboard.numericInput ? page2 : page1

	Component {
		id: page1

		KeyboardLayout {
			KeyboardRow {
				KeyboardButtonEmpty {
					width: 1.21 * keyboard.buttonWidth - keyboard.buttonSpacing
				}
				KeyboardButton {
					key: Qt.Key_Exclam
				}
				KeyboardButton {
					key: Qt.Key_Q
				}
				KeyboardButton {
					key: Qt.Key_W
				}
				KeyboardButton {
					key: Qt.Key_E
				}
				KeyboardButton {
					key: Qt.Key_R
				}
				KeyboardButton {
					key: Qt.Key_T
				}
				KeyboardButton {
					key: Qt.Key_Y
				}
				KeyboardButton {
					key: Qt.Key_U
				}
				KeyboardButton {
					key: Qt.Key_I
				}
				KeyboardButton {
					key: Qt.Key_O
				}
				KeyboardButton {
					key: Qt.Key_P
				}
				KeyboardButton {
					key: Qt.Key_Question
				}
			}

			KeyboardRow {
				KeyboardButtonEmpty {
					width: 1.21 * buttonWidth - buttonSpacing
				}
				KeyboardButton {
					key: Qt.Key_AsciiTilde
				}
				KeyboardButton {
					key: Qt.Key_A
				}
				KeyboardButton {
					key: Qt.Key_S
				}
				KeyboardButton {
					key: Qt.Key_D
				}
				KeyboardButton {
					key: Qt.Key_F
				}
				KeyboardButton {
					key: Qt.Key_G
				}
				KeyboardButton {
					key: Qt.Key_H
				}
				KeyboardButton {
					key: Qt.Key_J
				}
				KeyboardButton {
					key: Qt.Key_K
				}
				KeyboardButton {
					key: Qt.Key_L
				}
				KeyboardButton {
					key: Qt.Key_AsciiCircum
				}
				KeyboardButton {
					key: Qt.Key_Asterisk
				}
			}

			KeyboardRow {
				KeyboardButton {
					key: keyboard.lowerCaseToggleKey
					width: 1.21 * keyboard.buttonWidth
					iconSource: keyboard.lowerCase ? "icon-arrow-fill" : "icon-arrow"
				}
				KeyboardButtonEmpty {
					width: keyboard.buttonWidth * 0.45 - keyboard.buttonSpacing
				}
				KeyboardButton {
					key: Qt.Key_Less
				}
				KeyboardButton {
					key: Qt.Key_Greater
				}
				KeyboardButton {
					key: Qt.Key_Z
				}
				KeyboardButton {
					key: Qt.Key_X
				}
				KeyboardButton {
					key: Qt.Key_C
				}
				KeyboardButton {
					key: Qt.Key_V
				}
				KeyboardButton {
					key: Qt.Key_B
				}
				KeyboardButton {
					key: Qt.Key_N
				}
				KeyboardButton {
					key: Qt.Key_M
				}
				KeyboardButton {
					key: Qt.Key_Semicolon
				}
				KeyboardButton {
					key: Qt.Key_Colon
				}
				KeyboardButtonEmpty {
					width: keyboard.buttonWidth * 0.45 - keyboard.buttonSpacing
				}
				KeyboardButton {
					key: Qt.Key_Backspace
					width: 1.21 * keyboard.buttonWidth
					iconSource: "icon-backspace"
				}
			}

			KeyboardRow {
				KeyboardButton {
					key: numericInputToggleKey
					width: 2.21 * keyboard.buttonWidth
					text: "123"
				}
				KeyboardButton {
					key: Qt.Key_NumberSign
				}
				KeyboardButton {
					key: Qt.Key_At
				}
				KeyboardButton {
					key: Qt.Key_Space
					text: "space"
					width: 6 * (keyboard.buttonWidth + keyboard.buttonSpacing)
				}
				KeyboardButton {
					key: Qt.Key_Period
				}
				KeyboardButton {
					key: Qt.Key_Comma
				}
				KeyboardButton {
					key: Qt.Key_Minus
				}
				KeyboardButton {
					key: Qt.Key_Underscore
				}
			}
		}
	}

	Component {
		id: page2

		KeyboardLayout {
			KeyboardRow {
			}

			KeyboardRow {
				KeyboardButtonEmpty {
					width: 0.5 * keyboard.buttonWidth
				}
				KeyboardButton {
					key: Qt.Key_1
				}
				KeyboardButton {
					key: Qt.Key_2
				}
				KeyboardButton {
					key: Qt.Key_3
				}
				KeyboardButton {
					key: Qt.Key_4
				}
				KeyboardButton {
					key: Qt.Key_5
				}
				KeyboardButton {
					key: Qt.Key_6
				}
				KeyboardButton {
					key: Qt.Key_7
				}
				KeyboardButton {
					key: Qt.Key_8
				}
				KeyboardButton {
					key: Qt.Key_9
				}
				KeyboardButton {
					key: Qt.Key_0
				}
				KeyboardButton {
					key: Qt.Key_Equal
				}
				KeyboardButton {
					key: Qt.Key_Plus
				}
				KeyboardButton {
					key: Qt.Key_Percent
				}
			}

			KeyboardRow {
				KeyboardButton {
					key: keyboard.lowerCaseToggleKey
					width: 1.21 * keyboard.buttonWidth
					iconSource: keyboard.lowerCase ? "icon-arrow-fill" : "icon-arrow"
				}
				KeyboardButtonEmpty {
					width: keyboard.buttonWidth * 0.45 - keyboard.buttonSpacing
				}
				KeyboardButton {
					key: Qt.Key_ParenLeft
				}
				KeyboardButton {
					key: Qt.Key_ParenRight
				}
				KeyboardButton {
					key: Qt.Key_BracketLeft
				}
				KeyboardButton {
					key: Qt.Key_BracketRight
				}
				KeyboardButton {
					key: Qt.Key_BraceLeft
				}
				KeyboardButton {
					key: Qt.Key_BraceRight
				}
				KeyboardButton {
					key: Qt.Key_Backslash
				}
				KeyboardButton {
					key: Qt.Key_Slash
				}
				KeyboardButton {
					key: Qt.Key_Bar
				}
				KeyboardButton {
					key: Qt.Key_Dollar
				}
				KeyboardButton {
					key: Qt.Key_Ampersand
				}
				KeyboardButtonEmpty {
					width: keyboard.buttonWidth * 0.45 - keyboard.buttonSpacing
				}
				KeyboardButton {
					key: Qt.Key_Backspace
					width: 1.21 * keyboard.buttonWidth
					iconSource: "icon-backspace"
				}
			}

			KeyboardRow {
				KeyboardButton {
					key: numericInputToggleKey
					width: 2.21 * keyboard.buttonWidth
					text: "ABC"
				}
				KeyboardButton {
					key: Qt.Key_NumberSign
				}
				KeyboardButton {
					key: Qt.Key_At
				}
				KeyboardButton {
					key: Qt.Key_Space
					text: "space"
					width: 6 * (keyboard.buttonWidth + keyboard.buttonSpacing)
				}
				KeyboardButton {
					key: Qt.Key_Period
				}
				KeyboardButton {
					key: Qt.Key_Comma
				}
				KeyboardButton {
					key: Qt.Key_Minus
				}
				KeyboardButton {
					key: Qt.Key_Underscore
				}
			}
		}
	}
}
