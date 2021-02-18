import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

OverviewPage {
	id: root

        property string systemPrefix: "com.victronenergy.system"
        property string vebusPrefix: _vebusService.valid ? _vebusService.value : ""
	property string generatorPrefix: "com.victronenergy.settings/Settings/Generator0"
	property string startStopPrefix: "com.victronenergy.generator.startstop0/Generator0"

	property variant sys: theSystem
	property bool hasAcSolarOnAcIn1: sys.pvOnAcIn1.power.valid
	property bool hasAcSolarOnAcIn2: sys.pvOnAcIn2.power.valid
	property bool hasAcSolarOnIn: hasAcSolarOnAcIn1 || hasAcSolarOnAcIn2
	property bool hasAcSolarOnOut: sys.pvOnAcOut.power.valid
	property bool hasAcSolar: hasAcSolarOnIn || hasAcSolarOnOut
	property bool hasDcSolar: sys.pvCharger.power.valid
	property bool hasDcAndAcSolar: hasAcSolar && hasDcSolar

        property VBusItem inverterCurrent: VBusItem { bind: Utils.path(vebusPrefix, "/Dc/0/Current"); unit: "A"}
        property VBusItem inverterVoltage: VBusItem { bind: Utils.path(vebusPrefix, "/Dc/0/Voltage"); unit: "V"}

	VBusItem {
	        id: _vebusService
                bind: Utils.path(systemPrefix, "/VebusService")
        }

	// Keeps track of which button on the bottom row is active
	property int buttonIndex: 0

	title: qsTr("Overview")

	OverviewBox {
		id: acInBox

		width: 148
		height: showStatusBar ? 100 : 120
		title: getAcSourceName(sys.acSource) + " " + sys.acSource
		titleColor: sys.acInput.value > 0 ? "#E74c3c" : "#808080"
		color: sys.acInput.value > 0 ? "#C0392B" : "#606060"

		anchors {
			top: multi.top
			left: parent.left; leftMargin: 10
		}

		VBusItem { id: runningBy; bind: Utils.path(startStopPrefix, "/RunningByCondition") }
		VBusItem { id: autoStart; bind: Utils.path(generatorPrefix, "/AutoStartEnabled") }

		values:	OverviewAcValues {
			connection: sys.acInput
			width: parent.width
			TileText {
				anchors {
					horizontalCenter: parent.horizontalCenter
					top: parent.top; topMargin: 25
				}
				text: (runningBy.value =="" ? (autoStart.value ? "GEN:AUTO" : "GEN:OFF") : "GEN:"+runningBy.value)
			}
		}

		MbIcon {
			iconId: getAcSourceIcon(sys.acSource)
			anchors {
				bottom: parent.bottom
				left: parent.left; leftMargin: 2
			}
			opacity: 0.5
		}
	}

	Multi {
		id: multi
		anchors {
			horizontalCenter: parent.horizontalCenter
			top: parent.top; topMargin: 2
		}
		TileText {
			anchors {
				horizontalCenter: parent.horizontalCenter
				top: parent.top; topMargin: 100
			}
			text: inverterVoltage.format(1) + "  " + inverterCurrent.format(1)
		}
	}

	OverviewBox {
		id: acLoadBox
		title: qsTr("AC Loads")
		color: "#27AE60"
		titleColor: "#2ECC71"
		width: 148
		height: showStatusBar ? 100 : 120

		anchors {
			right: parent.right; rightMargin: 10
			top: multi.top
		}

		values: OverviewAcValues {
			width: parent.width
			connection: sys.acLoad
			TileText {
				anchors {
					horizontalCenter: parent.horizontalCenter
					top: parent.top; topMargin: 25
				}
				text: (sys.acLoad.power.value/115).toFixed(1)  + "A"
			}
		}
	}

	Battery {
		id: battery

		soc: sys.battery.soc.valid ? sys.battery.soc.value : 0
		charge: sys.battery.power.value > 0

		anchors {
			bottom: tanks.top; bottomMargin: 2;
			left: parent.left; leftMargin: 10
		}
		values: Column {
			width: parent.width

			TileText {
				// Use value here instead of format() because format adds the unit to the number and we
				// show the percentage symbol in a separated smaller text.
				text: sys.battery.soc.value === undefined ? "--" : sys.battery.soc.value.toFixed(0)
				font.pixelSize: 40

				Text {
					anchors {
						bottom: parent.bottom; bottomMargin: 9
						horizontalCenter: parent.horizontalCenter; horizontalCenterOffset: parent.paintedWidth / 2 + 5
					}
					visible: sys.battery.soc.valid
					text: "%"
					color: "white"
					font.bold: true
					font.pixelSize: 12
				}
			}
			TileText {
				text: sys.battery.power.format(0) + "  " + hoursDecimal(sys.battery.timeToGo)+"Hr"
			}
			TileText {
				text: sys.battery.voltage.format(1) + "   " + sys.battery.current.format(1)
			}
		}
	}

	VBusItem {
		id: hasDcSys
		bind: "com.victronenergy.settings/Settings/SystemSetup/HasDcSystem"
	}

	OverviewBox {
		id: dcSystemBox
		width: 105
		height: 45
		visible: hasDcSys.value > 0
		titleColor: sys.dcSystem.power.value >= 0 ? "#16a185" : "#E74c3c"
		title: sys.dcSystem.power.value >= 0 ? qsTr("DC Power") : qsTr("DC Charge")
		color: sys.dcSystem.power.value >= 0 ? "#1a9c8c" : "#C0392B" 

		anchors {
			horizontalCenter: multi.horizontalCenter
			bottom: tanks.top; bottomMargin: 2
		}

		values: Column {
			y: 5
			width: parent.width
			TileText {
				text: Math.Abs(sys.dcSystem.power.value).toFixed(0) + "W " + Math.Abs(sys.dcSystem.power.value / sys.battery.voltage.value).toFixed(0)+"A"
			}
		}
	}

	OverviewSolarCharger {
		id: blueSolarCharger

		height: hasDcAndAcSolar ? 65 : 114
		width: 148
		title: qsTr("PV Charger")
		showChargerIcon: !hasDcAndAcSolar
		visible: hasDcSolar || hasDcAndAcSolar

		anchors {
			right: root.right; rightMargin: 10
			bottom: tanks.top; bottomMargin: 2;
		}

		values: Column {
			y: 5
			width: parent.width
			TileText {
				text: sys.pvCharger.power.format(0)
				font.pixelSize: 20
			}
			TileText {
				text: sys.pvCharger.voltage.format(1) + "  " + sys.pvCharger.current.format(1)
			}
			TileText {
				text: sys.pvCharger.yield.format(1)
			}
		}
	}

	OverviewSolarInverter {
		id: pvInverter
		height: hasDcAndAcSolar ? 65 : 115
		width: 148
		title: qsTr("PV Inverter")
		showInverterIcon: !hasDcAndAcSolar
		visible: hasAcSolar

		anchors {
			right: root.right; rightMargin: 10;
			bottom: tanks.top; bottomMargin: hasDcAndAcSolar ? 75 : 2
		}

		OverviewAcValues {
			connection: hasAcSolarOnOut ? sys.pvOnAcOut : hasAcSolarOnAcIn1 ? sys.pvOnAcIn1 : sys.pvOnAcIn2
			visible: !coupledPvAc.visible
		}

		TileText {
			id: coupledPvAc

			property double pvInverterOnAcOut: sys.pvOnAcOut.power.valid ? sys.pvOnAcOut.power.value : 0
			property double pvInverterOnAcIn1: sys.pvOnAcIn1.power.valid ? sys.pvOnAcIn1.power.value : 0
			property double pvInverterOnAcIn2: sys.pvOnAcIn2.power.valid ? sys.pvOnAcIn2.power.value : 0

			y: 5
			text: (pvInverterOnAcOut + pvInverterOnAcIn1 + pvInverterOnAcIn2).toFixed(0) + "W"
			font.pixelSize: hasDcAndAcSolar ? 20 : 25
			visible: hasDcAndAcSolar || (hasAcSolarOnIn && hasAcSolarOnOut) || (hasAcSolarOnAcIn1 && hasAcSolarOnAcIn2)
		}
	}

	OverviewEssReason {
		anchors {
			bottom: tanks.top; bottomMargin: dcSystemBox.visible ? battery.height + 15 : 2
			horizontalCenter: parent.horizontalCenter; horizontalCenterOffset: dcSystemBox.visible ? -(root.width / 2 - battery.width / 2 - 10)  : 0
		}
	}

	OverviewConnection {
		id: acInToMulti
		ballCount: 2
		path: straight
		active: root.active
		value: flow(sys.acInput ? sys.acInput.power : 0)

		anchors {
			left: acInBox.right; leftMargin: -10; top: multi.verticalCenter;
			right: multi.left; rightMargin: -10; bottom: multi.verticalCenter
		}
	}

	OverviewConnection {
		id: multiToAcLoads
		ballCount: 2
		path: straight
		active: root.active
		value: flow(sys.acLoad.power)

		anchors {
			left: multi.right; leftMargin: -10;
			top: multi.verticalCenter
			right: acLoadBox.left; rightMargin: -10
			bottom: multi.verticalCenter
		}
	}

	OverviewConnection {
		id: pvInverterToMulti

		property int hasDcAndAcFlow: Utils.sign(noNoise(sys.pvOnAcOut.power) + noNoise(sys.pvOnAcIn1.power) + noNoise(sys.pvOnAcIn2.power))

		ballCount: 4
		path: corner
		active: root.active && hasAcSolar
		value: hasDcAndAcSolar ? hasDcAndAcFlow : flow(sys.pvOnAcOut.power)

		anchors {
			left: pvInverter.left; leftMargin: 8
			top: pvInverter.verticalCenter; topMargin: hasDcAndAcSolar ? 1 : 0
			right: multi.horizontalCenter; rightMargin: -20
			bottom: multi.bottom; bottomMargin: 10
		}
	}

	// invisible anchor point to connect the chargers to the battery
	Item {
		id: dcConnect
		anchors {
			left: multi.horizontalCenter; leftMargin: hasAcSolar ? -20  : 0
			bottom: dcSystemBox.top; bottomMargin: 10
		}
	}

	OverviewConnection {
		id: multiToDcConnect
		ballCount: 3
		path: straight
		active: root.active
		value: -flow(sys.vebusDc.power);
		startPointVisible: false

		anchors {
			left: dcConnect.left
			top: dcConnect.top

			right: dcConnect.left
			bottom: multi.bottom; bottomMargin: 10
		}
	}

	OverviewConnection {
		id: blueSolarChargerDcConnect
		ballCount: 3
		path: straight
		active: root.active && hasDcSolar
		value: -flow(sys.pvCharger.power)
		startPointVisible: false

		anchors {
			left: dcConnect.left
			top: dcConnect.top

			right: blueSolarCharger.left; rightMargin: -8
			bottom: dcConnect.top;
		}
	}

	OverviewConnection {
		id: chargersToBattery
		ballCount: 3
		path: straight
		active: root.active
		value: Utils.sign(noNoise(sys.pvCharger.power) + noNoise(sys.vebusDc.power))
		startPointVisible: false

		anchors {
			left: dcConnect.left
			top: dcConnect.top

			right: battery.right; rightMargin: 10
			bottom: dcConnect.top
		}
	}

	OverviewConnection {
		id: batteryToDcSystem
		ballCount: 2
		path: straight
		active: root.active && hasDcSys.value > 0
		value: flow(sys.dcSystem.power)

		anchors {
			left: battery.right; leftMargin: -10
			top: dcSystemBox.verticalCenter;
			right: dcSystemBox.left; rightMargin: -10
			bottom: dcSystemBox.verticalCenter
		}
	}

	// Inverter controls borrowed from OverviewMobile

	Keys.forwardTo: [keyHandler]

	Item {
		id: keyHandler
		Keys.onLeftPressed: {
			if (buttonIndex > 0)
				buttonIndex--

			event.accepted = true
		}

		Keys.onRightPressed: {
			if (buttonIndex < 1)
				buttonIndex++

			event.accepted = true
		}
	}

	MouseArea {
		anchors.fill: parent
		enabled: parent.active
		onPressed: mouse.accepted = acCurrentButton.expanded
		onClicked: acCurrentButton.cancel()
	}

        TileSpinBox {
                id: acCurrentButton

		anchors {
			bottom: acInBox.bottom; bottomMargin: 3
			right: acInBox.right; rightMargin: 3
		}
                isCurrentItem: (buttonIndex == 0)
                focus: root.active && isCurrentItem

                bind: Utils.path(vebusPrefix, "/Ac/ActiveIn/CurrentLimit")
                title: qsTr("AC LIMIT")
		// titleColor: "#E74c3c"
		color: sys.acInput.value > 0 ? "#C0392B" : "#606060"
		border.color: sys.acInput.value > 0 ? "#B0281A" : "#505050"
		width: editMode ? 150 : 90
                fontPixelSize: 12
                unit: "A"
		readOnly: false
	}

	Tile {
		id: acModeButton
		// place ON/OFF/CHG button over the switch in the image
		anchors {
			top: multi.top; topMargin: 62
			left: multi.left; leftMargin: 36
		}
		width: 56
		height: 32

		property variant texts: { 4: qsTr("OFF"), 3: qsTr("ON"), 1: qsTr("CHG") }
		property int value: mode.valid ? mode.value : 3
		property int shownValue: applyAnimation2.running ? applyAnimation2.pendingValue : value

		isCurrentItem: (buttonIndex == 1)
		focus: root.active && isCurrentItem

		color: "#4789d0"
		border.color: "#3678c0"

		editable: true
		readOnly: false
		// color: acModeButtonMouseArea.containsPressed ? "#d3d3d3" : "#A8A8A8"

		values: [
			TileText {
				text: qsTr("%1").arg(acModeButton.texts[acModeButton.shownValue])
			}
		]

		VBusItem { id: mode; bind: Utils.path(vebusPrefix, "/Mode") }

		Keys.onSpacePressed: edit()

		function edit() {
			if (!mode.valid)
				return

			switch (shownValue) {
			case 4:
				applyAnimation2.pendingValue = 3
				break;
			case 3:
				applyAnimation2.pendingValue = 1
				break;
			case 1:
				applyAnimation2.pendingValue = 4
				break;
			}

			applyAnimation2.restart()
		}

		MouseArea {
			id: acModeButtonMouseArea
			anchors.fill: parent
			property bool containsPressed: containsMouse && pressed
			onClicked:  {
				buttonIndex = 1
				parent.edit()
			}
		}

		Rectangle {
			id: timerRect2
			height: 2
			width: acModeButton.width * 0.8
			visible: applyAnimation2.running
			anchors {
				bottom: parent.bottom; bottomMargin: 5
				horizontalCenter: parent.horizontalCenter
			}
		}

		SequentialAnimation {
			id: applyAnimation2

			property int pendingValue

			NumberAnimation {
				target: timerRect2
				property: "width"
				from: 0
				to: acModeButton.width * 0.8
				duration: 3000
			}

			ColorAnimation {
				target: acModeButton
				property: "color"
				to: "#A8A8A8"
				from: "#4789d0"
				duration: 200
			}

			ColorAnimation {
				target: acModeButton
				property: "color"
				to: "#4789d0"
				from: "#A8A8A8"
				duration: 200
			}
			PropertyAction {
				target: timerRect2
				property: "width"
				value: 0
			}

			ScriptAction { script: mode.setValue(applyAnimation2.pendingValue) }

			PauseAnimation { duration: 1000 }
		}
	}

	ListView {
		id: tanks

		property int tileHeight: Math.ceil(height / Math.max(count, 2))
		interactive: false // static tiles

		/*
		model: tanksModel
		delegate: TileTank {
			width: tanksColum.width
			height: tanksColum.tileHeight
			pumpBindPrefix: root.pumpBindPreffix
		}
		*/

		height: 28
		width: root.width
		anchors {
			bottom: root.bottom
			left: root.left
		}

		Tile {
			// title: qsTr("TANKS")
			anchors.fill: parent
			values: TileText {
				text: qsTr("No tanks found")
				// width: parent.width
				// wrapMode: Text.WordWrap
			}
			// z: -1
		}
	}

}
