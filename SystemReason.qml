import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

Item {
	id: root

	property string text: getReasonText()
	property variant flags: getFlags()
	property string systemPrefix: "com.victronenergy.system"

	// Flags to monitor
	property list<VBusItem> flagItems: [
		VBusItem { bind: Utils.path(systemPrefix, "/SystemState/LowSoc") },
		VBusItem { bind: Utils.path(systemPrefix, "/SystemState/BatteryLife") },
		VBusItem { bind: Utils.path(systemPrefix, "/SystemState/ChargeDisabled") },
		VBusItem { bind: Utils.path(systemPrefix, "/SystemState/DischargeDisabled") },
		VBusItem { bind: Utils.path(systemPrefix, "/SystemState/SlowCharge") },
		VBusItem { bind: Utils.path(systemPrefix, "/SystemState/UserChargeLimited") },
		VBusItem { bind: Utils.path(systemPrefix, "/SystemState/UserDischargeLimited") }
	]

	VBusItem {
		id: multiStatusReason
	}

	function getFlags(){
		var r = [];
		for (var i=0; i<flagItems.length; i++) {
			if (flagItems[i].value) r.push('#' + (i+1).toString(16));
		}
		return r;
	}

	function getReasonText() {
		return flags.join(" ");
	}

}
