import QtQuick 1.1

ListModel {
	id: tzCity
	ListElement {name: QT_TR_NOOP("Tasmania Standard Time"); city: "Hobart"; group: "(GMT +10:00) Hobart"}
	ListElement {name: QT_TR_NOOP("E. Australia Standard Time"); city: "Brisbane"; group: "(GMT +10:00) Brisbane"}
	ListElement {name: QT_TR_NOOP("AUS Eastern Standard Time"); city: "Sydney"; group: "(GMT +10:00) Canberra, Melbourne, Sydney"}
	ListElement {name: QT_TR_NOOP("Cen. Australia Standard Time"); city: "Adelaide"; group: "(GMT +09:30) Adelaide"}
	ListElement {name: QT_TR_NOOP("AUS Central Standard Time"); city: "Darwin"; group: "(GMT +09:30) Darwin"}
	ListElement {name: QT_TR_NOOP("W. Australia Standard Time"); city: "Perth"; group: "(GMT +08:00) Perth"}
}
