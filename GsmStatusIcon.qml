import QtQuick 1.1
import "utils.js" as Utils

Row {
	id: root
	property bool showNetworkType: activeNetworkConnection.value === Utils.NetworkConnection.GSM
	property bool showRoamingIcon: true
	property string color: "#FFFFFF"
	property bool valid: strength.valid

	height: 16
	visible: simStatus.valid

	Row {
		spacing: 4
		height: parent.height
		visible: showNetworkType || showRoamingIcon
		Text {
			id: netType
			height: 16
			text: Utils.simplifiedNetworkType(networkType.value)
			color: root.color
			verticalAlignment: Text.AlignVCenter
			visible: showNetworkType && (connected.valid && connected.value)
			font {
				bold: true
				pixelSize: 10
			}
		}

		Text {
			id: roamingIndicator
			height: 16
			text: "R"
			color: root.color
			verticalAlignment: Text.AlignVCenter
			visible: showRoamingIcon && roaming.valid ? roaming.value : false
			font {
				bold: true
				pixelSize: 10
			}
		}
	}

	Row {
		id: gsmRow
		spacing: 1
		visible: !simLockedIcon.visible

		anchors {
			top: parent.top; topMargin: 2
			bottom: parent.bottom; bottomMargin: 0
		}

		Repeater {
			id: signalRepeater
			model: 4
			Rectangle {
				y: parent.height - height
				height: (index + 1) * parent.height / signalRepeater.model
				width: 3
				color: root.color
				opacity: getScaledStrength(strength.value) >= (index + 1) ? 1 : 0.2
			}
		}
	}

	MbIcon {
		id: simLockedIcon
		iconId: "icon-statusbar-sim-locked"
		visible: [11, 16].indexOf(simStatus.value) > -1
	}

	VBusItem {
		id: strength
		bind: "com.victronenergy.modem/SignalStrength"
	}

	VBusItem {
		id: networkType
		bind: "com.victronenergy.modem/NetworkType"
	}

	VBusItem {
		id: simStatus
		bind: "com.victronenergy.modem/SimStatus"
	}

	VBusItem {
		id: roaming
		bind: "com.victronenergy.modem/Roaming"
	}

	VBusItem {
		id: connected
		bind: "com.victronenergy.modem/Connected"
	}

	VBusItem {
		id: activeNetworkConnection
		bind: "com.victronenergy.settings/Settings/System/ActiveNetworkConnection"
	}

	function getScaledStrength(strength) {

		if (Utils.between(strength, 0, 3 ))
			return 0
		if (Utils.between(strength, 4, 9))
			return 1
		if (Utils.between(strength, 10, 14))
			return 2
		if (Utils.between(strength, 15, 19) )
			return 3
		if (Utils.between(strength, 21, 31))
			return 4

		return 0
	}
}

