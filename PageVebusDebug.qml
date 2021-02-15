import QtQuick 1.1
import "utils.js" as Utils
import Qt.labs.components.native 1.0

MbPage {
	property string bindPrefix
	property variant service

	model: VisualItemModel {

		MbSubMenu {
			id: acSensorMenu
			description: "AC Sensors"
			subpage: Component {
				PageAcSensors {
					title: acSensorMenu.description
					bindPrefix: service.path("/AcSensor")
				}
			}
		}

		MbSubMenu {
			id: kwhSubmenu
			description: "kWh Counters"
			subpage: Component {
				PageVebusKwhCounters {
					title: kwhSubmenu.description
					bindPrefix: service.path("/Energy")
				}
			}
		}

		MbItemValue {
			description: "Multi SOC"
			item.bind: service.path("/Soc")
		}

		MbItemRow {
			description: "Flags"

			MbTextValue { item.value: "Sustain: "; width: 100; height: 30 }
			MbTextBlock { item.bind: service.path("/Hub4/Sustain"); width: 100; height: 30 }
			MbTextValue { item.value: "Low SOC: "; width: 100; height: 30 }
			MbTextBlock { item.bind: service.path("/Hub4/LowSoc"); width: 100; height: 30 }
		}

		MbItemRow {
			description: "AC power setpoint"

			MbTextBlock { item.bind: service.path("/Hub4/L1/AcPowerSetpoint"); width: 100; height: 30 }
			MbTextBlock { item.bind: service.path("/Hub4/L2/AcPowerSetpoint"); width: 100; height: 30 }
			MbTextBlock { item.bind: service.path("/Hub4/L3/AcPowerSetpoint"); width: 100; height: 30 }
		}

		MbItemRow {
			description: "Limits"

			MbTextValue { item.value: "Charge: "; width: 100; height: 30 }
			MbTextBlock { item.bind: "com.victronenergy.hub4/MaxChargePower"; width: 100; height: 30 }
			MbTextValue { item.value: "Discharge: "; width: 100; height: 30 }
			MbTextBlock { item.bind: "com.victronenergy.hub4/MaxDischargePower"; width: 100; height: 30 }
		}

		MbItemRow {
			description: "Send setpoints"

			Switch {
				id: doSend
				enabled: true

				Timer {
					id: hub4Control
					interval: 1000
					repeat: true
					running: doSend.checked

					property VBusItem remoteSetpointL1: VBusItem { bind: service.path("/Hub4/L1/AcPowerSetpoint") }
					property VBusItem remoteSetpointL2: VBusItem { bind: service.path("/Hub4/L2/AcPowerSetpoint") }
					property VBusItem remoteSetpointL3: VBusItem { bind: service.path("/Hub4/L3/AcPowerSetpoint") }
					property bool toggle

					onTriggered: {
						toggle = !toggle
						var noise = (toggle ? 0 : 1)

						// FIXME: only do this if the paths are valid (but that is unknown yet)
						remoteSetpointL1.setValue(sliderL1.item.value + noise)
						remoteSetpointL2.setValue(sliderL2.item.value + noise)
						remoteSetpointL3.setValue(sliderL3.item.value + noise)
					}
				}
			}

			function edit() {
				doSend.checked = !doSend.checked
			}
		}

		MbItemSlider {
			id: sliderL1
			item: VBusItem {
				min: -5000
				max: 5000
				step: 50
				decimals: 0
				value: 0
			}
		}

		MbItemSlider {
			id: sliderL2
			item: VBusItem {
				min: -5000
				max: 5000
				step: 50
				decimals: 0
				value: 0
			}
		}

		MbItemSlider {
			id: sliderL3
			item: VBusItem {
				min: -5000
				max: 5000
				step: 50
				decimals: 0
				value: 0
			}
		}

		MbSwitch {
			name: "Disable Charge"
			bind: service.path("/Hub4/DisableCharge")
		}

		MbSwitch {
			name: "Disable Feed In"
			bind: service.path("/Hub4/DisableFeedIn")
		}
	}
}
