import QtQuick 1.1
import Qt.labs.components.native 1.0

Page {
	property bool active: status === PageStatus.Active

	// properties of the default toolbar, iow with tools: mbTools
	// A page can have its own toolbar if needed.
	property string leftIcon: toolbarHandler.leftIcon
	property string leftText: toolbarHandler.leftText
	property string rightIcon: toolbarHandler.rightIcon
	property string rightText: toolbarHandler.rightText

	property variant toolbarHandler: mainToolbarHandler
	property string scrollIndicator

	tools: mbTools
}
