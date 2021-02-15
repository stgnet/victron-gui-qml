import QtQuick 1.1
import "utils.js" as Utils

ListView {
	id: root

	property int count: countownTime
	property int countownTime: 5
	property string bindPrefix
	property alias startCountdown: countdownTimer.running
	property bool connected: true
	property VBusItem state: VBusItem { bind: Utils.path(bindPrefix, "/State") }
	property VBusItem manualStart: VBusItem { bind: Utils.path(bindPrefix, "/ManualStart") }
	property VBusItem manualTimer: VBusItem { bind: Utils.path(bindPrefix, "/ManualStartTimer") }
	property alias expanded: timerTile.expanded
	property alias tileHeight: startTile.height

	model: tileModel
	currentIndex: timerTile.show
	height: timerTile.editMode ? timerTile.height : startTile.height

	VisualItemModel {
		id: tileModel
		Tile {
			id: startTile
			title: qsTr("MANUAL START")
			width: root.width
			height: 40
			readOnly: !manualStart.valid
			color: mouseArea.containsMouse ? "#f08b80" : "#e74c3c"
			show: !timerTile.editMode
			Keys.onSpacePressed: edit(false)

			function edit(isMouse)
			{
				if (!connected) {
					toast.createToast(qsTr("Generator not connected."))
					return
				}
				if (manualStart.value || startCountdown)
					startCountdown = !startCountdown
				else
					timerTile.edit(isMouse)
			}

			MouseArea {
				id: mouseArea
				anchors.fill: parent
				onClicked: {
					parent.edit(true)
				}
			}

			values: [
				TileTextMultiLine {
					text: qsTr("Press center button to:")
					width: root.width - 6
					visible: !root.startCountdown
				},
				TileTextMultiLine {
					text: qsTr("Press center button to:")
					width: root.width - 6
					visible: root.startCountdown && !manualStart.value || startingCountdownText.visible
							 || stoppingCountdownText.visible
				},
				TileTextMultiLine {
					text: !root.startCountdown ? manualStart.valid && manualStart.value ? qsTr("STOP") :
																	 qsTr("START") : qsTr("CANCEL")
					font.pixelSize: 25;
					verticalAlignment: Text.AlignTop
					width: root.width - 6
				},
				TileTextMultiLine {
					id: startingCountdownText
					text: qsTr("Starting in %1 seconds").arg(root.count)
					width: root.width - 6
					visible: root.startCountdown && !manualStart.value
				},
				TileTextMultiLine {
					id: stoppingCountdownText
					text: qsTr("Stopping in %1 seconds").arg(root.count)
					width: root.width - 6
					visible: root.startCountdown && manualStart.valid && manualStart.value
				},
				TileTextMultiLine {
					text: qsTr("Already running, use to make sure generator will run for a fixed time")
					visible: state.value > 0 && !manualStart.value
					width: root.width - 6
				},
				TileTextMultiLine {
					text: qsTr("Generator won't stop if other conditions are reached")
					visible: root.startCountdown && manualStart.valid && manualStart.value
					width: root.width - 6
				},
				TileTextMultiLine {
					text: qsTr("Manual run will end in: ")
					visible: manualStart.valid && manualStart.value &&
							 manualTimer.valid && manualTimer.value && !root.startCountdown
					width: root.width - 6
				},
				TileTextMultiLine {
					text: Utils.secondsToString(manualTimer.value)
					visible: manualStart.valid && manualStart.value &&
							 manualTimer.valid && manualTimer.value && !root.startCountdown
					width: root.width - 6
				}
			]
		}

		TileSpinBox {
			id: timerTile
			title: qsTr("STOP TIMER")
			width: root.width
			height: expanded ? contentHeight + 2 : tileHeight
			readOnly: manualStart.valid && manualStart.value
			enabled: !readOnly
			unit: ""
			stepSize: 60
			max: 86340
			min: 0
			show: editMode
			color: startTile.color
			description: qsTr("Run for:")
			extraDescription: qsTr("Generator will continue running if other conditions are reached")
			bind: Utils.path(root.bindPrefix, "/ManualStartTimer")
			buttonColor: "#e02e1c"

			onAccepted: root.startCountdown = true

			function format(val)
			{
				if (!isNaN(val)) {
					if (val > 0)
						return Utils.secondsToNoSecsString(val);
					else
						return qsTr("Stop manually")
				}
				return val
			}
		}
	}

	function cancel() {
		if (timerTile.editMode) {
			timerTile.cancel()
		}
	}

	Timer {
		id: countdownTimer
		interval: 1000
		running: root.startCountdown
		repeat: root.count >= 0
		onRunningChanged: root.count = root.countownTime
		onTriggered: {
			if (root.count == 0) {
				manualStart.setValue((manualStart.value ? 0 : 1))
				root.startCountdown = false
			}
			root.count--
		}
	}
}
