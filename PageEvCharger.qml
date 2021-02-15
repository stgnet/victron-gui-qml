import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root

	property variant service
	property string bindPrefix

	title: service.description
	summary: getSummary()

	function getSummary()
	{
		if (!status.item.valid)
			return;

		var sv = status.item.value;
		var st;

		if (sv === 2)
			st = totalPower.item.text;
		else
			st = getStatus(sv);

		return [mode.text, st];
	}

	function getStatus(s)
	{
		switch(s) {
		case 0:	 return qsTr("EV disconnected");
		case 1:	 return qsTr("Connected");
		case 2:	 return qsTr("Charging");
		case 3:	 return qsTr("Charged");
		case 4:	 return qsTr("Waiting for sun");
		case 5:	 return qsTr("Waiting for RFID");
		case 6:	 return qsTr("Waiting for enable");
		case 7:	 return qsTr("Low SOC");
		case 8:	 return qsTr("Ground error");
		case 9:	 return qsTr("Welded contacts error");
		default: return qsTr("Unknown");
		}
	}

	model: VisualItemModel {
		MbSwitch {
			name: qsTr("Enable charging")
			bind: service.path("/StartStop")
		}

		MbItemOptions {
			id: mode
			description: qsTr("Mode")
			bind: service.path("/Mode")
			readonly: false
			possibleValues: [
				MbOption { description: qsTr("Manual");	   value: 0 },
				MbOption { description: qsTr("Automatic"); value: 1 }
			]
		}

		MbSpinBox {
			description: qsTr("Charging current")
			bind: service.path("/SetCurrent")
			show: mode.value === 0
			unit: "A"
			stepSize: 1
			numOfDecimals: 0
		}

		MbSpinBox {
			id: maxCurrent
			description: qsTr("Max charging current")
			bind: service.path("/MaxCurrent")
			unit: "A"
			stepSize: 1
			numOfDecimals: 0
		}

		MbItemValue {
			id: status
			description: qsTr("Status")
			item.bind: service.path("/Status")
			item.text: item.valid ? getStatus(item.value) : "--"
		}

		MbItemValue {
			description: qsTr("Actual charging current")
			item.bind: service.path("/Current")
		}

		MbItemValue {
			id: totalPower
			description: qsTr("Total Power")
			item.bind: service.path("/Ac/Power")
		}

		MbItemValue {
			description: qsTr("L1 Power")
			item.bind: service.path("/Ac/L1/Power")
		}

		MbItemValue {
			description: qsTr("L2 Power")
			item.bind: service.path("/Ac/L2/Power")
		}

		MbItemValue {
			description: qsTr("L3 Power")
			item.bind: service.path("/Ac/L3/Power")
		}

		MbItemTimeSpan {
			description: qsTr("Charging time")
			item.bind: service.path("/ChargingTime")
		}

		MbItemValue {
			description: qsTr("Total energy")
			item.bind: service.path("/Ac/Energy/Forward")
		}

		MbSubMenu {
			id: deviceMenu
			description: qsTr("Device")
			subpage: Component {
				PageDeviceInfo {
					title: deviceMenu.description
					bindPrefix: root.bindPrefix
				}
			}
		}
	}
}
