import QtQuick 1.1

Item {
	function getState(state, wifi)
	{
		switch(state) {
		case "idle":
			return qsTr("Disconnected");
		case "failure":
			return qsTr("Failure");
		case "association":
			return qsTr("Connecting");
		case "configuration":
			return qsTr("Retrieving IP address");
		case "ready":
			return qsTr("Connected");
		case "disconnect":
			return qsTr("Disconnect");
		case "online":
			return qsTr("Connected");
		default:
			return state;
		}
	}
}
