import QtQuick 1.1

MbSubMenu {
	id: root
	property variant service
	item: VBusItem { value: service && !service.connected ? qsTr("Not Connected") : subpage ? subpage.summary : "" }
	description: subpage ? subpage.title : ""
}
