import QtQuick 1.1
import Qt.labs.components.native 1.0
import net.connman 0.1

MbPage {
	id: root
	title: qsTr("Wi-Fi")
	property bool serviceListUpdate: false
	property CmTechnology tech: Connman.getTechnology("wifi")
	model: Connman.getServiceList("wifi")

	Connections {
		target: Connman
		onServiceListChanged: {
			if (root.status == PageStatus.Active)
				model = Connman.getServiceList("wifi")
			else
				serviceListUpdate = true
		}
	}

	Timer {
		id: scanTimer
		interval: 10000
		running: root.status == PageStatus.Active
		repeat: true
		triggeredOnStart: true
		onTriggered: {
			if (tech)
				tech.scan()
		}
	}


	// This timer is added because when a wifi service is in failure, it will only leave this
	// state when a user presses connect or when the service is removed because wpa_supplicant
	// did not see the service for 3 minutes. This will not happen while we continue to scan
	// every 10 seconds, but the scanning does make sense while we are in this menu. So it
	// was decided to exit this menu when a user did nothing for 5 mminutes. In the end,
	// this will result in a removal of a service in failure with a possible automatic
	// reconnect when the service is seen again because of the automatic scan by connman.
	Timer {
		id: exitMenuTimer
		interval: 5 * 60 * 1000
		running: scanTimer.running
		repeat: false
		triggeredOnStart: false
		onTriggered: {
			pageStack.pop()
		}
	}

	Connections {
		target: QuickView
		onKeyPressed: {
			if (exitMenuTimer.running)
				exitMenuTimer.restart()
		}
	}

	FnCmStates {
		id: cmState
	}

	onStatusChanged: {
		if (root.status == PageStatus.Active && serviceListUpdate) {
			model = Connman.getServiceList("wifi")
			serviceListUpdate = false
		}
	}

	delegate: MbSubMenu {
		id: wifiPoint
		property CmService service: Connman.getService(modelData)

		description: service.name
		check: service.favorite
		indent: true
		item.text: cmState.getState(service.state, true)
		subpage: Component {
			PageSettingsTcpIp {
				title: wifiPoint.service.name
				path: modelData
				service: wifiPoint.service
				technologyType: "wifi"
			}
		}
	}

	MbItemText {
		visible: model.length === 0
		text: noModelDescription()
		style: MbStyle {
			isCurrentItem: true
		}
	}

	function noModelDescription() {
		if (tech) {
			if (tech.powered)
				return qsTr("No access points")
			else {
				return qsTr("No Wi-Fi adapter connected")
			}
		} else {
			return qsTr("No Wi-Fi adapter connected")
		}
	}
}
