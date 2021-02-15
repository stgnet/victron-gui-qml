import QtQuick 1.1

import QtQuick 1.1
import "utils.js" as Utils

Item {
	property color color: "white"
	property real radius: 0
	property Border border: Border {}
	property alias cache: svg.cache

	// if only the height is given, keep the aspect ratio of the screen, e.g. a
	// circle is still round. The source image might actually be an elipse!
	height: radius * 2
	width: height ? height / screen.scaleX * screen.scaleY : -1

	Svg {
		id: svg

		// SVG draws the border inside the rectangle, while Qt draws it on the edges.
		property double hborder: border.width / 2

		x: -hborder
		y: -hborder
		width: parent.width + border.width
		height: parent.height + border.width

		svg: Utils.path(
				 '<svg width="', parent.width, '" height="', parent.height, '"> \
					<ellipse cx="' + (parent.width / 2) + '" cy="' + (parent.height / 2) +
					'" rx="', (parent.width / 2 - hborder), '" ry="', (parent.height / 2 - hborder), '"' +
					' style="fill:', color,
					';stroke:', border.color,';stroke-width:' + border.width + '" /> \
				</svg>')
	}
}
