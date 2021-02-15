import QtQuick 1.1
import "utils.js" as Utils

MbPage {
	id: root
	property string bindPrefix

	model: VisualItemModel {
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
