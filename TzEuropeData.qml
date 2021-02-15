import QtQuick 1.1

ListModel {
	id: tzCity
	ListElement {name: QT_TR_NOOP("GMT Standard Time"); city: "London"; group: "(GMT) Dublin, Edinburgh, Lisbon, London"}
	ListElement {name: QT_TR_NOOP("Central Europe Standard Time"); city: "Budapest"; group: "(GMT +01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague"}
	ListElement {name: QT_TR_NOOP("Central European Standard Time"); city: "Warsaw"; group: "(GMT +01:00) Sarajevo, Skopje, Warsaw, Zagreb"}
	ListElement {name: QT_TR_NOOP("Romance Standard Time"); city: "Paris"; group: "(GMT +01:00) Brussels, Copenhagen, Madrid, Paris"}
	ListElement {name: QT_TR_NOOP("W. Europe Standard Time"); city: "Berlin"; group: "(GMT +01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"}
	ListElement {name: QT_TR_NOOP("E. Europe Standard Time"); city: "Chisinau"; group: "(GMT +02:00) Chisinau"}
	ListElement {name: QT_TR_NOOP("FLE Standard Time"); city: "Kiev"; group: "(GMT +02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius"}
	ListElement {name: QT_TR_NOOP("GTB Standard Time"); city: "Bucharest"; group: "(GMT +02:00) Athens, Bucharest"}
	ListElement {name: QT_TR_NOOP("Belarus Standard Time"); city: "Minsk"; group: "(GMT +03:00) Minsk"}
	ListElement {name: QT_TR_NOOP("Russian Standard Time"); city: "Moscow"; group: "(GMT +03:00) Moscow, St. Petersburg, Volgograd"}
	ListElement {name: QT_TR_NOOP("Turkey Standard Time"); city: "Istanbul"; group: "(GMT +03:00) Istanbul"}
}
