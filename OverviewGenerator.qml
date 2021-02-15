import QtQuick 1.1
import "utils.js" as Utils

OverviewPage {
	id: root

	property int runningtimeOnManual
	property string settingsBindPrefix
	property string bindPrefix
	property variant sys: theSystem
	property string icon: "image://theme/overview-generator"
	property VBusItem state: VBusItem { bind: Utils.path(bindPrefix, "/State") }
	property VBusItem error: VBusItem { bind: Utils.path(bindPrefix, "/Error") }
	property VBusItem runningTime: VBusItem { bind: Utils.path(bindPrefix, "/Runtime") }
	property VBusItem runningBy: VBusItem { bind: Utils.path(bindPrefix, "/RunningByCondition") }
	property VBusItem totalAcummulatedTime: VBusItem { bind: Utils.path(settingsBindPrefix, "/AccumulatedTotal") }
	property VBusItem quietHours: VBusItem { bind: Utils.path(bindPrefix, "/QuietHours") }
	property VBusItem testRunDuration: VBusItem { bind: Utils.path(settingsBindPrefix, "/TestRun/Duration") }
	property VBusItem nextTestRun: VBusItem { bind: Utils.path(bindPrefix, "/NextTestRun") }
	property VBusItem skipTestRun: VBusItem { bind: Utils.path(bindPrefix, "/SkipTestRun") }
	property VBusItem todayRuntime: VBusItem { bind: Utils.path(bindPrefix, "/TodayRuntime") }

	title: qsTr("Generator")

	Keys.onReturnPressed: event.accepted = manualTile.startCountdown
	Keys.onEscapePressed: event.accepted = manualTile.startCountdown

	function stateDescription()
	{
		if (!state.valid)
			return qsTr("Generator not connected")
		if (state.value === 10)
			switch(error.value) {
			case 1:
				return qsTr("Error\nRemote switch control disabled")
			case 2:
				return qsTr("Error\nGenerator in fault condition")
			case 3:
				return qsTr("Error\nGenerator not detected at AC input")
			default:
				return qsTr("Error")
			}

		switch(runningBy.value) {
		case 'soc':
			return qsTr("Running by SOC condition")
		case 'acload':
			return qsTr("Running by AC load condition")
		case 'batterycurrent':
			return qsTr("Running by battery current condition")
		case 'batteryvoltage':
			return qsTr("Running by battery voltage condition")
		case 'inverterhightemp':
			return qsTr("Running by inverter high temperature")
		case 'inverteroverload':
			return qsTr("Running by inverter overload")
		case 'testrun':
			return qsTr("Periodic test run")
		case 'manual':
			return qsTr("Running by manual start")
		case 'lossofcommunication':
			return qsTr("Running by loss of communication")
		default:
			return qsTr("Generator not running")
		}
	}

	function getNextTestRun()
	{
		if (!nextTestRun.value)
			return qsTr("No test run programmed")

		var todayDate = new Date()
		var nextDate = new Date(nextTestRun.value * 1000)
		var nextDateEnd = new Date(nextDate.getTime())
		var message = qsTr("Next test run on \n %1").arg(
					Qt.formatDateTime(nextDate, "dd/MM/yyyy").toString())
		nextDateEnd.setSeconds(testRunDuration.value)
		if (todayDate.getDate() == nextDate.getDate() &&
				todayDate.getMonth() == nextDate.getMonth()) {
				message = qsTr("Test run today\n %1 - ").arg(
							Qt.formatDateTime(nextDate, "hh:mm").toString())
				message += 	Qt.formatDateTime(nextDateEnd, "hh:mm").toString()
		}

		if (skipTestRun.value === 1)
			message += qsTr(" \n Not necessary, will be skipped")

		return message
	}

	Tile {
		id: imageTile
		width: 180
		height: 136
		MbIcon {
			id: generator
			source: icon
			anchors.centerIn: parent
		}
		anchors { top: parent.top; left: parent.left }
	}

	Tile {
		id: statusTile
		width: 136
		height: 136
		color: "#4789d0"
		anchors { top: parent.top; left: imageTile.right }
		title: qsTr("STATUS")
		values: [
			TileTextMultiLine {
				text: stateDescription()
				width: statusTile.width - 5
			},
			TileTextMultiLine {
				text: runningTime.valid ? Utils.secondsToNoSecsString(runningTime.value) : "--"
				width: statusTile.width - 5
				visible: runningTime.value > 0
			},
			TileTextMultiLine {
				text: qsTr("Quiet hours");
				width: statusTile.width - 5
				visible: quietHours.value === 1
			}
		]
	}

	Tile {
		id: testRunTile
		title: qsTr("TEST RUN")
		height: 136
		anchors { top: parent.top; left: statusTile.right; right: parent.right }
		values: [
			TileTextMultiLine {
				width: testRunTile.width - 5
				text: getNextTestRun()
			}
		]
	}

	TileAcPower {
		id: acInTile
		title: qsTr("AC INPUT")
		width: 170
		height: 136
		color: "#82acde"
		connection: sys.genset
		anchors { top: imageTile.bottom; left: parent.left }
	}

	Tile {
		id: runTimeTile
		title: qsTr("ACCUM. RUNTIME")
		height: 68
		width: 125
		anchors {top: imageTile.bottom; left: acInTile.right}
		values: [
			TileTextMultiLine {
				width: runTimeTile.width - 5
				text: Utils.secondsToNoSecsString(totalAcummulatedTime.value)
			}
		]
	}

	Tile {
		id: todayRuntimeTile
		title: qsTr("TODAY RUNTIME")
		height: 68
		width: 125
		anchors { top: runTimeTile.bottom; left: acInTile.right }
		values: [
			TileTextMultiLine {
				width: todayRuntimeTile.width - 5
				text: Utils.secondsToNoSecsString(todayRuntime.value)
			}
		]
	}

	MouseArea {
		anchors.fill: parent
		enabled: parent.active
		onPressed: mouse.accepted = manualTile.expanded
		onClicked: manualTile.cancel()
	}

	TileManualStart {
		id: manualTile
		bindPrefix: root.bindPrefix
		focus: root.active
		connected: state.valid
		tileHeight: runTimeTile.height + todayRuntimeTile.height
		anchors {
			bottom: parent.bottom
			left: runTimeTile.right
			right: parent.right
		}
	}
}
