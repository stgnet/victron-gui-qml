import QtQuick 1.1
import net.connman 0.1
import "utils.js" as Utils

MbIcon {
	id: root

	property variant services: Connman.serviceList
	property variant service: getWifiConnectionService(services)
	property int signalStrength: service ? service.strength : 0
	property bool connecting: service ? service.state === "association" || service.state === "configuration" : false

	iconId: getIconForSignal(signalStrength)
	display: service !== undefined
	opacity: opacityFader.running ? opacityFader.value : 1

	Timer {
		id: opacityFader
		property double value: 0.2 + Math.abs(Math.sin(Math.PI / _loops * _counter))
		property int _counter
		property int _loops: 5

		interval: 200
		running: connecting
		repeat: true
		onTriggered: if (_counter >= (_loops - 1)) _counter = 0; else _counter++
	}

	function getWifiConnectionService(services)
	{
		for (var i in services) {
			var s = Connman.getService(services[i])
			if (s.type !== "wifi")
				continue
			switch (s.state) {
				case "association":
				case "configuration":
				case "online":
				case "ready":
					return s
			}
		}
		return undefined
	}

	function getIconForSignal(strength) {
		if (strength > 80)
			return 'icon-statusbar-wifi-excellent';
		else if (strength > 55)
			return 'icon-statusbar-wifi-good';
		else if (strength > 30)
			return 'icon-statusbar-wifi-ok';
		else if (strength > 5)
			return 'icon-statusbar-wifi-weak';
		else
			return 'icon-statusbar-wifi-none';
	}
}

