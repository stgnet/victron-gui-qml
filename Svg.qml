import QtQuick 1.1
import Qt.labs.components.native 1.0

// Qt Quick 1 has no svg it seems. So work around it till there is qtquick 2 support.
// Note: source and width must be set to ccgx coordinates. The svg is rendered in
// screen coordinates. The result is cached.
//
// NOTE: This works the other way around then the MbIcon! Here the qml determines the
// size of the svg. For the MbIcon the svg determines the size of the Image!
Image {
	// if only the height is given, keep the aspect ratio of the screen, e.g. a
	// circle is still round. The source image might actually be an elipse!
	height: -1
	width: height ? height / screen.scaleX * screen.scaleY : -1
	sourceSize.width: width ? width * screen.scaleX : -1
	sourceSize.height: height ? height * screen.scaleY : -1
	source: svg ? "image://theme/svg?svg=" + encodeURIComponent(svg) + (cache ? "&cache=true" : "") : ""

	// Mind it, only assign it when the svg definition is complete!
	property variant svg
	property bool cache: false
}
