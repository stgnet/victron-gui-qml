import QtQuick 1.1

ListModel {
	id: tzCity
	ListElement {name: QT_TR_NOOP("GMT +12"); city: "GMT-12"; group: "(GMT +12:00) Coordinated Universal Time+12"}
	ListElement {name: QT_TR_NOOP("GMT "); city: "GMT"; group: "(GMT) Coordinated Universal Time"}
	ListElement {name: QT_TR_NOOP("Mid-Atlantic Standard Time"); city: "GMT+2"; group: "(GMT -02:00) Mid-Atlantic"}
	ListElement {name: QT_TR_NOOP("GMT -02"); city: "GMT+2"; group: "(GMT -02:00) Coordinated Universal Time-02"}
	ListElement {name: QT_TR_NOOP("GMT -11"); city: "GMT+11"; group: "(GMT -11:00) Coordinated Universal Time-11"}
	ListElement {name: QT_TR_NOOP("Dateline Standard Time"); city: "GMT+12"; group: "(GMT -12:00) International Date Line West"}
}
