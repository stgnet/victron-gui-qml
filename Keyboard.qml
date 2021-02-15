import QtQuick 1.1

Rectangle {
	id: keyboard

	width: (parent ? parent.width : 0)
	height: active ? loader.height + 10 : 0
	color: "#293b4d"

	property int buttonWidth: 28
	property int buttonHeight: 28
	property int buttonSpacing: 2
	property bool lowerCase: false
	property bool numericInput: false
	property bool numericOnlyLayout: false
	// in overwriteMode backspace and other modifiers are disabled.
	// Note: only the numeric layout support this at the moment!
	property bool overwriteMode: false
	property string layout: numericOnlyLayout ? "KeyboardLoaderNumeric.qml" : "KeyboardLoaderAlphaNumeric.qml"
	property bool active
	property bool animating
	onActiveChanged: animating = true

	/*readonly*/ property color buttonBaseColor: "#4b5f73"
	/*readonly*/ property color pressedButtonColor: "#637e99"
	/*readonly*/ property color buttonTextColor: "white"

	// These are just integers that are used as identifiers for the custom buttons
	// They don't map to any Qt.Keys
	/*readonly*/ property int lowerCaseToggleKey: -1
	/*readonly*/ property int numericInputToggleKey: -2

	// This is to capture and ignore clicks/touches outside of the actual buttons
	MouseArea {
		anchors.fill: keyboard
	}

	Behavior on height {
		SequentialAnimation {
			PropertyAnimation {
				duration: 300
			}
			PropertyAnimation { target: keyboard; property: "animating"; to: false }
		}
	}

	Loader {
		id: loader
		source: active ? layout : ""
		anchors.centerIn: keyboard
		visible: !animating
	}

	function onButtonPressed(key, isAutoRepeat) {
		switch (key)
		{
		case lowerCaseToggleKey:
			lowerCase = !keyboard.lowerCase
			return
		case numericInputToggleKey:
			numericInput = !keyboard.numericInput
			return
		default:
			keyEmitter.emitKey(key, keyboard.lowerCase, isAutoRepeat)
		}
	}
}
