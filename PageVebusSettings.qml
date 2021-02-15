import QtQuick 1.1
import "utils.js" as Utils

MbPage {
	id: root
	property string bindPrefix

	model: VisualItemModel {
		MbSpinBox {
			description: "Absorption Voltage"
			bind: Utils.path(bindPrefix, "/AbsorptionVoltage")
		}

		MbSpinBox {
			description: "Float Voltage"
			bind: Utils.path(bindPrefix, "/FloatVoltage")
		}

		MbSpinBox {
			description: "Charge Current"
			bind: Utils.path(bindPrefix, "/ChargeCurrent")
		}

		MbSpinBox {
			description: "Inverter Output Voltage"
			bind: Utils.path(bindPrefix, "/InverterOutputVoltage")
		}

		MbSpinBox {
			description: "Ac Current Limit"
			bind: Utils.path(bindPrefix, "/AcCurrentLimit")
		}

		MbSpinBox {
			description: "Repeated Absorption Time"
			bind: Utils.path(bindPrefix, "/RepeatedAbsorptionTime")
		}

		MbSpinBox {
			description: "Repeated Absorption Interval"
			bind: Utils.path(bindPrefix, "/RepeatedAbsorptionInterval")
		}

		MbSpinBox {
			description: "Maximum Absorption Time"
			bind: Utils.path(bindPrefix, "/MaximumAbsorptionTime")
		}

		MbSpinBox {
			description: "Charge Characteristic"
			bind: Utils.path(bindPrefix, "/ChargeCharacteristic")
		}
		MbSpinBox {
			description: "Inverter Dc Shutdown Voltage"
			bind: Utils.path(bindPrefix, "/InverterDcShutdownVoltage")
		}

		MbSpinBox {
			description: "Inverter Dc Restart Voltage"
			bind: Utils.path(bindPrefix, "/InverterDcRestartVoltage")
		}

		MbSpinBox {
			description: "Ac Low Switch Input Off"
			bind: Utils.path(bindPrefix, "/AcLowSwitchInputOff")
		}

		MbSpinBox {
			description: "Ac Low Switch Input On"
			bind: Utils.path(bindPrefix, "/AcLowSwitchInputOn")
		}

		MbSpinBox {
			description: "Ac High Switch Input On"
			bind: Utils.path(bindPrefix, "/AcHighSwitchInputOn")
		}

		MbSpinBox {
			description: "Ac High Switch Input Off"
			bind: Utils.path(bindPrefix, "/AcHighSwitchInputOff")
		}

		MbSpinBox {
			description: "Assist Current BoostFactor"
			bind: Utils.path(bindPrefix, "/AssistCurrentBoostFactor")
		}

		MbSpinBox {
			description: "Second AC Input Current Limit"
			bind: Utils.path(bindPrefix, "/SecondInputCurrentLimit")
		}

		MbSpinBox {
			description: "Load For Starting Aes Mode"
			bind: Utils.path(bindPrefix, "/LoadForStartingAesMode")
		}

		MbSpinBox {
			description: "Offset For Ending Aes Mode"
			bind: Utils.path(bindPrefix, "/OffsetForEndingAesMode")
		}

		MbSpinBox {
			description: "Low Dc Alarm Level"
			bind: Utils.path(bindPrefix, "/LowDcAlarmLevel")
		}

		MbSpinBox {
			description: "Battery Capacity"
			bind: Utils.path(bindPrefix, "/BatteryCapacity")
		}

		MbSpinBox {
			description: "Soc When Bulk finished"
			bind: Utils.path(bindPrefix, "/SocWhenBulkfinished")
		}

		MbSpinBox {
			description: "Frequency Shift UBat Start"
			bind: Utils.path(bindPrefix, "/FrequencyShiftUBatStart")
		}

		MbSpinBox {
			description: "Frequency Shift Start Delay"
			bind: Utils.path(bindPrefix, "/FrequencyShiftStartDelay")
		}

		MbSpinBox {
			description: "Frequency Shift UBat Stop"
			bind: Utils.path(bindPrefix, "/FrequencyShiftUBatStop")
		}

		MbSpinBox {
			description: "Frequency Shift Stop Delay"
			bind: Utils.path(bindPrefix, "/FrequencyShiftStopDelay")
		}

		MbSwitch {
			bind: Utils.path(bindPrefix, "/RemoteOverrulesAc1")
			name: "RemoteOverrulesAc1"
		}

		MbSwitch {
			bind: Utils.path(bindPrefix, "/RemoteOverrulesAc2")
			name: "RemoteOverrulesAc2"
		}

		MbSwitch {
			bind: Utils.path(bindPrefix, "/Is60Hz")
			name: "Is60Hz"
		}

		MbSwitch {
			bind: Utils.path(bindPrefix, "/DisableWaveCheck")
			name: "DisableWaveCheck"
		}

		MbSwitch {
			bind: Utils.path(bindPrefix, "/DontStopAfter10hBulk")
			name: "DontStopAfter10hBulk"
		}

		MbSwitch {
			bind: Utils.path(bindPrefix, "/PowerAssistEnabled")
			name: "PowerAssistEnabled"
		}

		MbSwitch {
			bind: Utils.path(bindPrefix, "/DisableCharger")
			name: "DisableCharger"
		}

		MbSwitch {
			bind: Utils.path(bindPrefix, "/DisableAes")
			name: "DisableAes"
		}

		MbSwitch {
			bind: Utils.path(bindPrefix, "/EnableReducedFloat")
			name: "EnableReducedFloat"
		}

		MbSwitch {
			bind: Utils.path(bindPrefix, "/DisableGroundRelay")
			name: "DisableGroundRelay"
		}

		MbSwitch {
			bind: Utils.path(bindPrefix, "/WeakAcInput")
			name: "WeakAcInput"
		}

		MbSwitch {
			bind: Utils.path(bindPrefix, "/AcceptWideInputFrequency")
			name: "AcceptWideInputFrequency"
		}

		MbSwitch {
			bind: Utils.path(bindPrefix, "/DynamicCurrentLimit")
			name: "DynamicCurrentLimit"
		}

		MbSwitch {
			bind: Utils.path(bindPrefix, "/TabularPlateTractionCurve")
			name: "TabularPlateTractionCurve"
		}

		MbSwitch {
			bind: Utils.path(bindPrefix, "/LowPowerShutdownInAes")
			name: "LowPowerShutdownInAes"
		}
	}
}
