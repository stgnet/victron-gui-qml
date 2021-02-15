import QtQuick 1.1

ToolbarHandler {
	id: mainToolbarHandler

	leftIcon: "icon-toolbar-pages"
	leftText: qsTr("Pages")
	rightIcon: "icon-toolbar-menu"
	rightText: qsTr("Menu")

	// note: these functions live in main.qml and hence are available everywhere..
	function leftAction()
	{
		showOverview()
	}

	function rightAction()
	{
		backToMainMenu()
	}
}
