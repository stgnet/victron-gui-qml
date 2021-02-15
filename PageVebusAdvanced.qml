import QtQuick 1.1
import com.victron.velib 1.0

MbPage {

	property bool isEssOrHub4: theSystem.systemType.value === "ESS" || theSystem.systemType.value === 'Hub-4'
	property bool isMulti
	property bool startManualEq: false

	property int initializingChargerState: 1
	property int bulkState: 1
	property int absorptionState: 2
	property int floatState: 3
	property int equalizeState: 7
	property int forceEqCmd: 1

	VBusItem {
		id: setChargerState
		bind: service.path("/VebusSetChargeState")
	}

	VBusItem {
		id: vebusSubState
		bind: service.path("/VebusChargeState")
		onValueChanged: if (value === equalizeState) startManualEq = false
	}

	VBusItem {
		id: redetectSystem
		bind: service.path("/RedetectSystem")
	}

	VBusItem {
		id: systemReset
		bind: service.path("/SystemReset")
	}

	VBusItem {
		id: firmwareVersion
		bind: service.path("/FirmwareVersion")
	}

	Timer {
		id: startTimer
		interval: 250
		repeat: true
		running: vebusSubState !== equalizeState && startManualEq
	}

	Timer {
		id: interruptTimer
		interval: 250
		onRunningChanged: repeat = true
		onTriggered: repeat = vebusSubState.value === equalizeState
	}

	model: VisualItemModel {

		MbOK {
			id: startEq

			property bool interrupt: vebusSubState.value === equalizeState

			description: interrupt ? qsTr("Interrupt equalization") : qsTr("Equalization")
			value: getButtonValueText()
			cornerMark: enabled
			editable: setChargerState.valid && vebusSubState.valid && !startTimer.running && !interruptTimer.running && show
			onClicked: {
				if (firmwareVersion.value < 0x400)
					toast.createToast(qsTr("This feature requires firmware version 400 or higher, contact your installer to update your Multi/Quattro."), 5000)

				if (!editable)
					return

				switch (vebusSubState.value) {
				case initializingChargerState:
					toast.createToast(qsTr("Charger not ready, equalization cannot be started."), 5000)
					break;
				case bulkState:
					toast.createToast(qsTr("Equalization cannot be triggered during bulk charge state."), 5000)
					break;
				case equalizeState:
					stopEq.edit()
					break;
				default:
					setChargerState.setValue(forceEqCmd)
					startManualEq = true
					showEqStartToast()
				}
				return
			}

			function showEqStartToast()
			{
				var text = ""
				if (isEssOrHub4)
					text = "Warning: Activating equalization in an ESS system with solar chargers " +
															   "can cause charging the battery at high voltage with a too high current.\n"

					text += qsTr("The system will automatically switch over to float once the Equalization " +
							 "charge has been completed.")

				toast.createToast(text, 15000)
			}

			function getButtonValueText()
			{
				if (interruptTimer.running)
					return qsTr("Interrupting...")
				if (startTimer.running)
					return qsTr("Starting...")
				if (interrupt)
					return qsTr("Press to interrupt")
				return qsTr("Press to start")
			}

			Keys.onRightPressed: {}
		}

		MbItemOptions {
			id: stopEq
			description: qsTr("Interrupt equalization")
			show: false
			localValue: 3
			possibleValues: [
				MbOption{ description: qsTr("Interrupt and restart absorption"); value: absorptionState; readonly: vebusSubState.value !== equalizeState },
				MbOption{ description: qsTr("Interrupt and go to float"); value: floatState; readonly: vebusSubState.value !== equalizeState },
				MbOption{ description: qsTr("Interrupt"); value: 1; readonly: vebusSubState.value === equalizeState },
				MbOption{ description: qsTr("Do not interrupt"); value: 0 }
			]
			onOptionSelected: {
				if (localValue !== 0) {
					interruptTimer.start()
					if (localValue !== 1) {
						setChargerState.setValue(localValue)
					}
				}
				// Return back to float as default option
				localValue = 3
			}
		}

		MbOK {
			description: qsTr("Redetect System")
			value: redetectSystem.value === 1 ? qsTr("Redetecting...") : qsTr("Press to redetect")
			editable: redetectSystem.valid
			cornerMark: redetectSystem.value === 0
			writeAccessLevel: User.AccessUser
			onClicked: redetectSystem.setValue(1)
		}

		MbOK {
			description: qsTr("System reset")
			value: systemReset.value === 1 ? qsTr("Resetting...") : qsTr("Press to reset")
			editable: systemReset.valid
			cornerMark: systemReset.value === 0
			writeAccessLevel: User.AccessUser
			onClicked: systemReset.setValue(1)
		}

		MbItemOptions {
			description: qsTr("ESS Relay test")
			bind: service.path("/Devices/0/ExtendStatus/WaitingForRelayTest")
			readonly: true
			show: valid && isEssOrHub4 && isMulti
			possibleValues: [
				MbOption { description: qsTr("Completed"); value: 0 },
				MbOption { description: qsTr("Pending"); value: 1 }
			]
		}

		MbSubMenu {
			id: vebusQualityMenu
			description: qsTr("VE.Bus diagnostics")
			show: user.accessLevel >= User.AccessService && masterHasNetworkQuality.valid

			VBusItem {
				id: masterHasNetworkQuality
				bind: service.path("/Devices/0/ExtendStatus/VeBusNetworkQualityCounter")
			}

			subpage: Component {
				MbPage {
					title: vebusQualityMenu.description
					model: VisualItemModel {
						MbItemVebusQuality { index: 0; bindPrefix: service.path("") }
						MbItemVebusQuality { index: 1; bindPrefix: service.path("") }
						MbItemVebusQuality { index: 2; bindPrefix: service.path("") }
						MbItemVebusQuality { index: 3; bindPrefix: service.path("") }
						MbItemVebusQuality { index: 4; bindPrefix: service.path("") }
						MbItemVebusQuality { index: 5; bindPrefix: service.path("") }
						MbItemVebusQuality { index: 6; bindPrefix: service.path("") }
						MbItemVebusQuality { index: 7; bindPrefix: service.path("") }
						MbItemVebusQuality { index: 8; bindPrefix: service.path("") }
						MbItemVebusQuality { index: 9; bindPrefix: service.path("") }
						MbItemVebusQuality { index: 10; bindPrefix: service.path("") }
						MbItemVebusQuality { index: 11; bindPrefix: service.path("") }
						MbItemVebusQuality { index: 12; bindPrefix: service.path("") }
						MbItemVebusQuality { index: 13; bindPrefix: service.path("") }
						MbItemVebusQuality { index: 14; bindPrefix: service.path("") }
						MbItemVebusQuality { index: 15; bindPrefix: service.path("") }
						MbItemVebusQuality { index: 16; bindPrefix: service.path("") }
						MbItemVebusQuality { index: 17; bindPrefix: service.path("") }
					}
				}
			}
		}
	}
}
