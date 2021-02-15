import QtQuick 1.1

QtObject {
	property string leftIcon: ""
	property string leftText: ""
	property string rightIcon: ""
	property string rightText: ""
	// see MbPage, used to determine if this is a default toolbar for a page
	property bool isDefault

	function leftAction(isMouse) {
	}

	function rightAction(isMouse) {
	}

	function centerAction() {
	}
}
