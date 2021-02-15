import QtQuick 1.1

ListModel {
	id: tzCity
	ListElement {name: QT_TR_NOOP("Morocco Standard Time"); city: "Casablanca"; group: "(GMT) Casablanca"}
	ListElement {name: QT_TR_NOOP("W. Central Africa Standard Time"); city: "Lagos"; group: "(GMT +01:00) West Central Africa"}
	ListElement {name: QT_TR_NOOP("South Africa Standard Time"); city: "Johannesburg"; group: "(GMT +02:00) Harare, Pretoria"}
	ListElement {name: QT_TR_NOOP("Namibia Standard Time"); city: "Windhoek"; group: "(GMT +02:00) Windhoek"}
	ListElement {name: QT_TR_NOOP("Egypt Standard Time"); city: "Cairo"; group: "(GMT +02:00) Cairo"}
	ListElement {name: QT_TR_NOOP("E. Africa Standard Time"); city: "Nairobi"; group: "(GMT +03:00) Nairobi"}
}
