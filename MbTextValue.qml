import QtQuick 1.1
import com.victron.velib 1.0

/* Standard layout typically used for text values inside the menus */
Text {
	property MbStyle style: MbStyle {}
	property VBusItem item: VBusItem {}

	text: item.text
	font.family: style.fontFamily
	font.pixelSize: style.fontPixelSize
	horizontalAlignment: style.valueHorizontalAlignment
	color: style.isCurrentItem ? style.textColorSelected : style.textColor
}
