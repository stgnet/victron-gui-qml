import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

QtObject {
	property string bindPrefix
	property bool onlyPositive

	property VBusItem voltage: VBusItem {
		bind: Utils.path(bindPrefix, "/V")
		decimals: 0
		unit: "V"
	}

	property VBusItem current: VBusItem {
		property VBusItem reportedCurrent: VBusItem { bind: Utils.path(bindPrefix, "/I") }
		value: onlyPositive && reportedCurrent.valid ? Math.max(0, reportedCurrent.value) : reportedCurrent.value
		decimals: 0
		unit: "A"
	}

	// If the power is not reported, calculate the apparent power
	property VBusItem power: VBusItem {
		property VBusItem reportedPower: VBusItem { bind: Utils.path(bindPrefix, "/P") }
		property VBusItem apparentPower: VBusItem { bind: Utils.path(bindPrefix, "/S") }
		property variant power: reportedPower.valid ? reportedPower.value :
								apparentPower.valid ? apparentPower.value :
								voltage.valid && current.valid ? voltage.value * current.value :
								undefined

		value: power && onlyPositive ? Math.max(0, power) : power
		decimals: 0
		unit: reportedPower.valid ? "W" : "VA"
	}

	property VBusItem frequency: VBusItem {
		bind: Utils.path(bindPrefix, "/F")
		decimals: 1
		unit: "Hz"
	}
}
