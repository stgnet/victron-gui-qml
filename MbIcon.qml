import QtQuick 1.1
import Qt.labs.components.native 1.0

Image {
	id: root

	property string iconId: ""
	property bool downsize: true
	property bool display: true

	source: iconId == "" ? "" : "image://theme/" + iconId
	// Note: the theme manager will render the svg's for the actual screen resolution.
	// downsize restores the width and height to ccgx coordinates, so when the screen
	// is stretched to the actual resolution, the svg's and up in the native resolution.
	visible: display
	width: display ? (downsize ? sourceSize.width / screen.scaleX : sourceSize.width) : 0
	height: display ? (downsize ? sourceSize.height / screen.scaleY : sourceSize.height) : 0
}
