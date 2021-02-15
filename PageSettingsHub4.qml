import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	property string cgwacsPath: "com.victronenergy.settings/Settings/CGwacs"
	property string settingsPrefix: "com.victronenergy.settings"
	property string batteryLifePath: cgwacsPath + "/BatteryLife"
	// Hub4Mode
	property int hub4PhaseCompensation: 1
	property int hub4PhaseSplit: 2
	property int hub4Disabled: 3
	// BatteryLifeState
	property int batteryLifeStateDisabled: 0
	property int batteryLifeStateRestart: 1
	property int batteryLifeStateDefault: 2
	property int batteryLifeStateAbsorption: 3
	property int batteryLifeStateFloat: 4
	property int batteryLifeStateDischarged: 5
	property int batteryLifeStateForceCharge: 6
	property int batteryLifeStateSustain: 7
	property int batteryLifeStateLowSocCharge: 8
	property int batteryKeepCharged: 9
	property int batterySocGuardDefault: 10
	property int batterySocGuardDischarged: 11
	property int batterySocGuardLowSocCharge: 12

	property VBusItem systemType: VBusItem { bind: "com.victronenergy.system/SystemType" }
	property VBusItem gridSetpoint: VBusItem { bind: "com.victronenergy.settings/Settings/CGwacs/AcPowerSetPoint" }
	property VBusItem maxChargePowerItem: VBusItem { bind: Utils.path(cgwacsPath, "/MaxChargePower") }
	property VBusItem maxDischargePowerItem: VBusItem { bind: Utils.path(cgwacsPath, "/MaxDischargePower") }
	property VBusItem socLimitItem: VBusItem { bind: Utils.path(batteryLifePath, "/SocLimit") }
	property VBusItem minSocLimitItem: VBusItem { bind: Utils.path(batteryLifePath, "/MinimumSocLimit") }
	property VBusItem stateItem: VBusItem { bind: Utils.path(batteryLifePath, "/State") }
	property VBusItem hub4Mode: VBusItem { bind: Utils.path(cgwacsPath, "/Hub4Mode") }
	property VBusItem maxChargeCurrentControl: VBusItem { bind: "com.victronenergy.system/Control/MaxChargeCurrent" }

	title: systemType.value === "Hub-4" ? systemType.value : qsTr("ESS")
	model: systemType.value === "ESS" || systemType.value === "Hub-4" ? hub4Settings : noHub4

	VisualItemModel {
		id: noHub4

		MbItemText {
			text: qsTr("No ESS Assistant found")
		}
	}

	function isBatteryLifeActive(state) {
		switch (state) {
		case batteryLifeStateRestart:
		case batteryLifeStateDefault:
		case batteryLifeStateAbsorption:
		case batteryLifeStateFloat:
		case batteryLifeStateDischarged:
		case batteryLifeStateForceCharge:
		case batteryLifeStateSustain:
		case batteryLifeStateLowSocCharge:
			return true
		default:
			return false
		}
	}

	function isBatterySocGuardActive(state) {
		switch (state) {
		case batterySocGuardDefault:
		case batterySocGuardDischarged:
		case batterySocGuardLowSocCharge:
			return true
		default:
			return false
		}
	}

	VisualItemModel {
		id: hub4Settings

		MbItemOptions {
			function getLocalValue(hub4Mode, state) {
				if (hub4Mode === undefined || state === undefined)
					return undefined
				if (hub4Mode === hub4Disabled)
					return 3
				if (isBatteryLifeActive(state))
					return 0
				if (isBatterySocGuardActive(state))
					return 1
				if (state === batteryKeepCharged)
					return 2
				return 0
			}

			description: qsTr("Mode")
			localValue: getLocalValue(hub4Mode.value, stateItem.value)
			possibleValues:[
				MbOption { description: qsTr("Optimized (with BatteryLife)"); value: 0 },
				MbOption { description: qsTr("Optimized (without BatteryLife)"); value: 1 },
				MbOption { description: qsTr("Keep batteries charged"); value: 2 },
				MbOption { description: qsTr("External control"); value: 3 }
			]
			onLocalValueChanged: {
				if (localValue === undefined)
					return
				// Hub 4 mode
				if (localValue === 3 && hub4Mode.value !== hub4Disabled) {
					hub4Mode.setValue(hub4Disabled)
				} else if (localValue !== 3 && hub4Mode.value === hub4Disabled) {
					hub4Mode.setValue(hub4PhaseCompensation)
				}
				// BatteryLife state
				switch (localValue) {
				case 0:
					if (!isBatteryLifeActive(stateItem.value))
						stateItem.setValue(batteryLifeStateRestart)
					break
				case 1:
					if (!isBatterySocGuardActive(stateItem.value))
						stateItem.setValue(batterySocGuardDefault)
					break
				case 2:
					stateItem.setValue(batteryKeepCharged)
					break
				case 3:
					stateItem.setValue(batteryLifeStateDisabled)
					break
				}
			}
		}

		MbItemOptions {
			id: withoutGridMeter
			description: qsTr("Grid metering")
			bind: Utils.path(cgwacsPath, '/RunWithoutGridMeter')
			show: hub4Mode.value !== hub4Disabled
			enabled: userHasWriteAccess
			possibleValues:[
				MbOption { description: qsTr("External meter"); value: 0 },
				MbOption { description: qsTr("Inverter/Charger"); value: 1 }
			]
		}

		MbSwitch {
			bind: Utils.path(settingsPrefix, "/Settings/SystemSetup/HasAcOutSystem")
			name: qsTr("Inverter AC output in use")
			show: withoutGridMeter.value == 0
		}


		MbItemOptions {
			description: qsTr("Multiphase regulation")
			bind: hub4Mode.bind
			show: hub4Mode.value !== hub4Disabled && stateItem.value !== batteryKeepCharged
			enabled: userHasWriteAccess
			possibleValues:[
				MbOption { description: qsTr("Total of all phases"); value: hub4PhaseCompensation },
				MbOption { description: qsTr("Individual phase"); value: hub4PhaseSplit }
			]
			onOptionSelected: {
				if (newValue === hub4PhaseSplit) {
					toast.createToast(qsTr("Each phase is regulated to individually achieve the grid setpoint (system efficiency is decreased).\n\n" +
					"CAUTION: Use only if required by the utility provider"), 15000);
				} else if (newValue === hub4PhaseCompensation) {
					toast.createToast(qsTr("The total of all phases is intelligently regulated to achieve the grid setpoint (system efficiency is optimised).\n\n" +
					"Use unless prohibited by the utility provider"), 15000);
				}
			}
		}

		MbSpinBox {
			id: minSocLimit
			description: qsTr("Minimum SOC (unless grid fails)")
			enabled: userHasWriteAccess
			show: hub4Mode.value !== hub4Disabled && stateItem.value !== batteryKeepCharged
			bind: Utils.path(batteryLifePath, "/MinimumSocLimit")
			numOfDecimals: 0
			unit: "%"
			min: 0
			max: 100
			stepSize: 5
		}

		MbItemValue {
			id: socLimit
			description: qsTr("Active SOC limit")
			show: hub4Mode.value !== hub4Disabled && isBatteryLifeActive(stateItem.value)
			item.value: Math.max(minSocLimitItem.value, socLimitItem.value)
			item.unit: '%'
		}

		MbItemOptions {
			description: qsTr("BatteryLife state")
			value: stateItem.value
			readonly: true
			show: hub4Mode.value !== hub4Disabled && isBatteryLifeActive(stateItem.value)
			possibleValues:[
				// Values below taken from MaintenanceState enum in dbus-cgwacs
				MbOption { description: qsTr("Self-consumption"); value: 2 },
				MbOption { description: qsTr("Self-consumption"); value: 3 },
				MbOption { description: qsTr("Self-consumption"); value: 4 },
				MbOption { description: qsTr("Discharge disabled"); value: 5 },
				MbOption { description: qsTr("Slow charge"); value: 6 },
				MbOption { description: qsTr("Sustain"); value: 7 }
			]
		}

		MbSwitch {
			id: maxChargePowerSwitch
			name: qsTr("Limit charge power")
			checked: maxChargePowerItem.value >= 0
			enabled: userHasWriteAccess
			show: hub4Mode.value !== hub4Disabled && !(maxChargeCurrentControl.valid && maxChargeCurrentControl.value)
			onCheckedChanged: {
				if (checked && maxChargePowerItem.value < 0)
					maxChargePowerItem.setValue(1000)
				else if (!checked && maxChargePowerItem.value >= 0)
					maxChargePowerItem.setValue(-1)
			}
		}

		MbSpinBox {
			id: maxChargePower
			description: qsTr("Maximum charge power")
			enabled: userHasWriteAccess
			show: maxChargePowerSwitch.show && maxChargePowerSwitch.checked
			bind: Utils.path(cgwacsPath, "/MaxChargePower")
			numOfDecimals: 0
			unit: "W"
			min: 0
			max: 200000
			stepSize: 50
		}

		MbSwitch {
			id: maxInverterPowerSwitch
			name: qsTr("Limit inverter power")
			checked: maxDischargePowerItem.value >= 0
			enabled: userHasWriteAccess
			show: hub4Mode.value !== hub4Disabled && stateItem.value !== batteryKeepCharged
			onCheckedChanged: {
				if (checked && maxDischargePowerItem.value < 0)
					maxDischargePowerItem.setValue(1000)
				else if (!checked && maxDischargePowerItem.value >= 0)
					maxDischargePowerItem.setValue(-1)
			}
		}

		MbSpinBox {
			id: maxDischargePower
			description: qsTr("Maximum inverter power")
			enabled: userHasWriteAccess
			show: maxInverterPowerSwitch.show && maxInverterPowerSwitch.checked
			bind: Utils.path(cgwacsPath, "/MaxDischargePower")
			numOfDecimals: 0
			unit: "W"
			min: 0
			max: 300000
			stepSize: 50
		}

		MbSpinBox {
			description: qsTr("Grid setpoint")
			show: hub4Mode.value !== hub4Disabled && stateItem.value !== batteryKeepCharged
			enabled: userHasWriteAccess
			bind: "com.victronenergy.settings/Settings/CGwacs/AcPowerSetPoint"
			numOfDecimals: 0
			unit: "W"
			stepSize: 10
		}

		MbSubMenu {
			id: feedinSetupItem
			description: qsTr("Grid feed-in")
			subpage: Component {
				PageSettingsHub4Feedin {
					title: feedinSetupItem.description
				}
			}
		}

		MbSubMenu {
			id: scheduleSettings
			property string bindPrefix: "com.victronenergy.settings/Settings/CGwacs/BatteryLife/Schedule/Charge/"
			description: qsTr("Scheduled charging")
			show: hub4Mode.value !== hub4Disabled && stateItem.value !== batteryKeepCharged
			subpage: Component {
				MbPage {
					title: scheduleSettings.description
					model: VisualItemModel {
						ChargeScheduleItem { bindPrefix: scheduleSettings.bindPrefix; scheduleNumber: 0 }
						ChargeScheduleItem { bindPrefix: scheduleSettings.bindPrefix; scheduleNumber: 1 }
						ChargeScheduleItem { bindPrefix: scheduleSettings.bindPrefix; scheduleNumber: 2 }
						ChargeScheduleItem { bindPrefix: scheduleSettings.bindPrefix; scheduleNumber: 3 }
						ChargeScheduleItem { bindPrefix: scheduleSettings.bindPrefix; scheduleNumber: 4 }
					}
				}
			}
		}

		MbSubMenu {
			id: deviceItem
			description: qsTr("Debug")
			show: hub4Mode.value !== hub4Disabled && user.accessLevel >= User.AccessService
			subpage: Component {
				PageHub4Debug { }
			}
		}
	}
}
