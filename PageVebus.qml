import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	id: root

	property variant service
	property string bindPrefix
	property string noAdjustableByDmc: qsTr("This setting is disabled when a Digital Multi Control " +
											"is connected. If it was recently disconnected execute " +
											"\"Redetect system\" that is avalible below on this menu.")
	property string noAdjustableByBms: qsTr("This setting is disabled when a VE.Bus BMS " +
											"is connected. If it was recently disconnected execute " +
											"\"Redetect system\" that is avalible below on this menu.")
	property string noAdjustableTextByConfig: qsTr("This setting is disabled. " +
										   "Possible reasons are \"Overruled by remote\" is not enabled or " +
										   "an assistant is preventing the adjustment. Please, check " +
										   "the inverter configuration with VEConfigure.")

	property VBusItem numberOfPhases: VBusItem { bind: service.path("/Ac/NumberOfPhases") }
	property VBusItem numberOfAcInputs: VBusItem { bind: service.path("/Ac/NumberOfAcInputs") }
	property bool isMulti: numberOfAcInputs.value !== 0
	property VBusItem dmc: VBusItem { bind: service.path("/Devices/Dmc/Version") }
	property VBusItem bmsMode: VBusItem { bind: service.path("/Devices/Bms/Version") }
	property VBusItem bmsExpected: VBusItem { bind: service.path("/Bms/BmsExpected") }
	property VBusItem bmsInfo: VBusItem { bind: service.path("/Bms/AllowToCharge") }
	property VBusItem bmsType: VBusItem { bind: service.path("/Bms/BmsType") }

	property int bmsTypeTwoSignal: 1
	property int bmsTypeVebus: 2

	title: service.description
	summary: state.value !== undefined ? state.text : "--"

	SystemState {
		id: state
		bind: service.path("/State")
	}

	model: VisualItemModel {
		MbItemOptions {
			description: qsTr("Switch")
			bind: service.path("/Mode")

			possibleValues: [
				MbOption { description: qsTr("Off"); value: 4 },
				MbOption { description: qsTr("Charger Only"); value: 1; readonly: !isMulti },
				MbOption { description: qsTr("Inverter Only"); value: 2; readonly: !isMulti },
				MbOption { description: qsTr("On"); value: 3 }
			]

			VBusItem {
				id: modeIsAdjustable
				bind: service.path("/ModeIsAdjustable")
			}
			readonly: !modeIsAdjustable.valid || !modeIsAdjustable.value
			writeAccessLevel: User.AccessUser
			onClicked: {
				if (readonly) {
					if (dmc.valid)
						toast.createToast(noAdjustableByDmc, 5000)
					if (bmsMode.valid)
						toast.createToast(noAdjustableByBms, 5000)
				}
			}
		}

		MbItemValue {
			description: qsTr("State")
			item.value: state.text
		}

		MbSpinBox {
			VBusItem {
				id: currentLimitIsAdjustable
				bind: service.path("/Ac/ActiveIn/CurrentLimitIsAdjustable")
			}

			show: isMulti
			description: qsTr("Input current limit")
			bind: service.path("/Ac/ActiveIn/CurrentLimit")
			readOnly: !currentLimitIsAdjustable.valid || !currentLimitIsAdjustable.value
			writeAccessLevel: User.AccessUser
			onClicked: {
				if (readOnly) {
					if (dmc.valid)
						toast.createToast(noAdjustableByDmc, 5000)
					if (bmsMode.valid)
						toast.createToast(noAdjustableByBms, 5000)
					if (!dmc.valid && !bmsMode.valid)
						toast.createToast(noAdjustableTextByConfig, 5000)
				}
			}
		}

		MbItemValue {
			description: qsTr("DC Voltage")
			item.bind: service.path("/Dc/0/Voltage")
		}

		MbItemValue {
			description: qsTr("DC Current")
			item.bind: service.path("/Dc/0/Current")
		}

		MbItemValue {
			show: isMulti
			description: qsTr("State of charge")
			item.bind: service.path("/Soc")
		}

		MbItemValue {
			description: qsTr("Battery temperature")
			item {
				bind: service.path("/Dc/0/Temperature")
				unit: "°C"
			}
			show: item.valid && isMulti
		}

		MbItemOptions {
			description: qsTr("Active AC Input")
			bind: service.path("/Ac/ActiveIn/ActiveInput")

			possibleValues: [
				MbOption { description: qsTr("AC IN1"); value: 0 },
				MbOption { description: qsTr("AC IN2"); value: 1 },
				MbOption { description: qsTr("Disconnected"); value: 0xf0}
			]
			readonly: true
			show: isMulti
		}

		MbItemRow {
			height: 70
			description: qsTr("AC-In") + " L1"
			show: isMulti
			values: MbColumn {
				spacing: 2
				MbRow {
					MbTextBlock { item.bind: service.path("/Ac/ActiveIn/L1/V"); width: 100; height: 30 }
					MbTextBlock { item.bind: service.path("/Ac/ActiveIn/L1/I"); width: 100; height: 30 }
				}
				MbRow {
					MbTextBlock { item.bind: service.path("/Ac/ActiveIn/L1/P"); width: 100; height: 30 }
					MbTextBlock { item.bind: service.path("/Ac/ActiveIn/L1/F"); width: 100; height: 30 }
				}
			}
		}

		MbItemRow {
			height: 70
			description: qsTr("AC-In") + " L2"
			show: numberOfPhases.valid && numberOfPhases.value >= 2 && isMulti
			values: MbColumn {
				spacing: 2
				MbRow {
					MbTextBlock { item.bind: service.path("/Ac/ActiveIn/L2/V"); width: 100; height: 30 }
					MbTextBlock { item.bind: service.path("/Ac/ActiveIn/L2/I"); width: 100; height: 30 }
				}

				MbRow {
					MbTextBlock { item.bind: service.path("/Ac/ActiveIn/L2/P"); width: 100; height: 30 }
					MbTextBlock { item.bind: service.path("/Ac/ActiveIn/L2/F"); width: 100; height: 30 }
				}
			}
		}

		MbItemRow {
			height: 70
			description: qsTr("AC-In") + " L3"
			show: numberOfPhases.valid && numberOfPhases.value >= 3 && isMulti
			values: MbColumn {
				spacing: 2
				MbRow {
					MbTextBlock { item.bind: service.path("/Ac/ActiveIn/L3/V"); width: 100; height: 30}
					MbTextBlock { item.bind: service.path("/Ac/ActiveIn/L3/I"); width: 100; height: 30}
				}

				MbRow {
					MbTextBlock { item.bind: service.path("/Ac/ActiveIn/L3/P"); width: 100; height: 30}
					MbTextBlock { item.bind: service.path("/Ac/ActiveIn/L3/F"); width: 100; height: 30}
				}
			}
		}

		MbItemValue {
			description: qsTr("AC-In Total power")
			show: numberOfPhases.valid && numberOfPhases.value >= 2 && isMulti
			item.bind: service.path("/Ac/ActiveIn/P")
		}

		MbItemRow {
			height: 70
			description: qsTr("AC-Out") + " L1"
			values: MbColumn {
				spacing: 2
				MbRow {
					MbTextBlock { item.bind: service.path("/Ac/Out/L1/V"); width: 100; height: 30 }
					MbTextBlock { item.bind: service.path("/Ac/Out/L1/I"); width: 100; height: 30 }
				}

				MbRow {
					MbTextBlock { item.bind: service.path("/Ac/Out/L1/P"); width: 100; height: 30 }
					MbTextBlock { item.bind: service.path("/Ac/Out/L1/F"); width: 100; height: 30 }
				}
			}
		}

		MbItemRow {
			height: 70
			description: qsTr("AC-Out") + " L2"
			show: numberOfPhases.valid && numberOfPhases.value >= 2
			values: MbColumn {
				spacing: 2
				MbRow {
					MbTextBlock { item.bind: service.path("/Ac/Out/L2/V"); width: 100; height: 30 }
					MbTextBlock { item.bind: service.path("/Ac/Out/L2/I"); width: 100; height: 30 }
				}

				MbRow {
					MbTextBlock { item.bind: service.path("/Ac/Out/L2/P"); width: 100; height: 30 }
					MbTextBlock { item.bind: service.path("/Ac/Out/L2/F"); width: 100; height: 30 }
				}
			}
		}

		MbItemRow {
			height: 70
			description: qsTr("AC-Out") + " L3"
			show: numberOfPhases.valid && numberOfPhases.value >= 3
			values: MbColumn {
				spacing: 2
				MbRow {
					MbTextBlock { item.bind: service.path("/Ac/Out/L3/V"); width: 100; height: 30 }
					MbTextBlock { item.bind: service.path("/Ac/Out/L3/I"); width: 100; height: 30 }
				}

				MbRow {
					MbTextBlock { item.bind: service.path("/Ac/Out/L3/P"); width: 100; height: 30 }
					MbTextBlock { item.bind: service.path("/Ac/Out/L3/F"); width: 100; height: 30 }
				}
			}
		}

		MbItemValue {
			description: qsTr("AC-Out Total power")
			show: numberOfPhases.valid && numberOfPhases.value >= 2
			item.bind: service.path("/Ac/Out/P")
		}

		MbSubMenu {
			id: setupMenu
			description: qsTr("Advanced")
			subpage: Component {
				PageVebusAdvanced {
					isMulti: root.isMulti
					title: setupMenu.description
				}
			}
		}

		MbSubMenu {
			id: alarmsSubmenu
			description: qsTr("Alarm status")
			subpage: Component {
				PageVebusAlarms {
					isMulti: root.isMulti
					title: alarmsSubmenu.description
					bindPrefix: root.bindPrefix
				}
			}
		}

		MbSubMenu {
			id: submenu
			description: qsTr("Alarm setup")
			subpage: Component {
				PageVebusAlarmSettings {
					isMulti: root.isMulti
					title: submenu.description
				}
			}
		}

		MbItemText {
			text: qsTr("A VE.Bus BMS automatically turns the system " +
						"off when needed to protect the battery. Controlling the system " +
						"from the Color Control is therefore not possible.")
			wrapMode: Text.WordWrap
			show: bmsMode.valid
		}

		MbItemText {
			text: qsTr("A BMS assistant is installed configured for a VE.Bus BMS, but the VE.Bus BMS is not found!")
			wrapMode: Text.WordWrap
			show: bmsType.value === bmsTypeVebus && !bmsMode.valid
		}

		MbSubMenu {
			description: qsTr("VE.Bus BMS")
			show: bmsExpected.value === 1
			subpage: Component {
				PageVebusBms {
					title: setupMenu.description
				}
			}
		}

		/*
		MbSubMenu {
			id: deviceSettings
			description: qsTr("Settings")
			subpage: Component {
				PageVebusSettings {
					title: deviceSettings.description
					bindPrefix: service.path("/Devices/0/Settings")
				}
			}
		}

		MbSubMenu {
			id: deviceFlags
			description: "Flags"
			subpage: Component {
				PageVebusSettingsFlags {
					title: deviceFlags.description
				}
			}
		}
		*/

		MbSubMenu {
			id: acSensorMenu
			description: "AC Sensors"
			show: user.accessLevel >= User.AccessService
			subpage: Component {
				PageAcSensors {
					title: acSensorMenu.description
					bindPrefix: service.path("/AcSensor")
				}
			}
		}

		MbSubMenu {
			id: debugMenu
			description: "Debug"
			show: user.accessLevel >= User.AccessService
			subpage: Component {
				PageVebusDebug {
					title: debugMenu.description
					bindPrefix: service.path("")
					service: root.service
				}
			}
		}

		MbSubMenu {
			id: deviceItem
			description: qsTr("Device")
			subpage: Component {
				PageDeviceInfo {
					title: deviceItem.description
					bindPrefix: root.bindPrefix

					MbItemValue {
						description: qsTr("VE.Bus version")
						item.bind: service.path("/Devices/0/Version")
						show: item.valid
					}

					MbItemValue {
						id: mk2Name
						description: qsTr("MK2 device")
						item.bind: service.path("/Interfaces/Mk2/ProductName")
						show: item.valid
					}

					MbItemValue {
						description: qsTr("MK2 version")
						item.bind: service.path("/Interfaces/Mk2/Version")
						show: item.valid
					}

					MbItemValue {
						id: dmc
						description: qsTr("Multi Control version")
						item.bind: service.path("/Devices/Dmc/Version")
						show: item.valid
					}

					MbItemValue {
						id: bmsMode
						description: qsTr("VE.Bus BMS version")
						item.bind: service.path("/Devices/Bms/Version")
						show: item.valid
					}
				}
			}
		}
	}
}
