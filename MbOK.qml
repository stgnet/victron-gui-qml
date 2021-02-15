import QtQuick 1.1

MbItemRow {
	property string value

	cornerMark: userHasWriteAccess && editable

	MbTextBlock {
		visible: value != ""
		item.text: value
	}
}
