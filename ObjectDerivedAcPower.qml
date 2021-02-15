import QtQuick 1.1
import com.victron.velib 1.0

QtObject {
	property list<QtObject> connections

	property VBusItem powerL1: VBusItem {unit: "W"}
	property VBusItem powerL2: VBusItem {unit: "W"}
	property VBusItem powerL3: VBusItem {unit: "W"}
	property VBusItem power: VBusItem {unit: "W"}
	property VBusItem phaseCount: VBusItem {}

	// FIXME: how about arrays?
	function updatePower()
	{
		var total = 0;
		var valid = false;

		for (var i = 0; i < connections.length; i++) {
			if (connections[i].power.valid) {
				valid = true;
				total += connections[i].power.value;
			}
		}

		power.value = (valid ? total : undefined)
	}

	function updatePowerL1()
	{
		var total = 0;
		var valid = false;

		for (var i = 0; i < connections.length; i++) {
			if (connections[i].powerL1.valid) {
				valid = true;
				total += connections[i].powerL1.value;
			}
		}

		powerL1.value = (valid ? total : undefined)
	}

	function updatePowerL2()
	{
		var total = 0;
		var valid = false;

		for (var i = 0; i < connections.length; i++) {
			if (connections[i].powerL2.valid) {
				valid = true;
				total += connections[i].powerL2.value;
			}
		}

		powerL2.value = (valid ? total : undefined)
	}

	function updatePowerL3()
	{
		var total = 0;
		var valid = false;

		for (var i = 0; i < connections.length; i++) {
			if (connections[i].powerL3.valid) {
				valid = true;
				total += connections[i].powerL3.value;
			}
		}

		powerL3.value = (valid ? total : undefined)
	}

	function phaseCountChanged()
	{
		phaseCount.value = connections[0].phaseCount.value
	}

	Component.onCompleted: {

		if (connections.length)
			connections[0].phaseCount.valueChanged.connect(phaseCountChanged)

		for (var i = 0; i < connections.length; i++)
		{
			var conn = connections[i]
			conn.power.valueChanged.connect(updatePower)
			conn.powerL1.valueChanged.connect(updatePowerL1)
			conn.powerL2.valueChanged.connect(updatePowerL2)
			conn.powerL3.valueChanged.connect(updatePowerL3)
		}
	}
}
