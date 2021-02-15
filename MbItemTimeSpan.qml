import QtQuick 1.1

// TODO: move this function to utils and delete this
MbItemValue {
	item.text: {
		if (!item.valid)
			return "--"

		var secs = Math.round(item.value)
		var days = Math.floor(secs / 86400);
		var hours = Math.floor((secs - (days * 86400)) / 3600);
		var minutes = Math.floor((secs - (hours * 3600)) / 60);
		var seconds = Math.floor(secs - (minutes * 60));

		if (days > 0)
			return qsTr("%1d %2h").arg(days).arg(hours);
		if (hours)
			return qsTr("%1h %2m").arg(hours).arg(minutes);
		if (minutes)
			return qsTr("%1m %2s").arg(minutes).arg(seconds);

		return qsTr("%1s").arg(seconds);
	}
}
