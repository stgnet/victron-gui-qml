import QtQuick 1.1

Loader {
	property int rows
	property int initialHeight: rows * (keyboard.buttonHeight + keyboard.buttonSpacing) - keyboard.buttonSpacing

	height: status === Loader.Ready ? item.height : initialHeight
}
