import QtQuick 1.1
import "utils.js" as Utils

MbItemRow {
	property int nr;
	property string bindPrefix
	property VBusItem voltage: VBusItem {bind: Utils.path(bindPrefix, "/Pv/" + nr + "/V")}
	property VBusItem power: VBusItem {bind: Utils.path(bindPrefix, "/Pv/" + nr + "/P")}

	function current()
	{
		if (!voltage.value || !power.valid)
			return undefined

		return power.value / voltage.value
	}

	description: qsTr("Tracker") + " " + (nr + 1)
	values: [
		MbTextBlock { item: voltage ; width: 90; height: 25 },
		MbTextBlock { item.value: current(); item.decimals: 1; item.unit: "A"; width: 90; height: 25 },
		MbTextBlock { item: power; width: 90; height: 25 }
	]
}
