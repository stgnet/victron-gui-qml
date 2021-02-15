import QtQuick 1.1
import com.victron.velib 1.0

// Profiles for canbus
MbItemOptions {
	property string gateway
	property int canConfig: vePlatform.getCanBusConfig(gateway)

	function isReadonly(profile)
	{
		switch (canConfig)
		{
		case VePlatform.CanForcedVeCan:
			return (profile === CanBusProfile.CanProfileVecan ? false : true)
		case VePlatform.CanForcedCanBusBms:
			return (profile === CanBusProfile.CanProfileCanBms500 ? false : true)
		default:
			return false
		}
	}

	possibleValues: [
		MbOption { description: qsTr("Disabled"); value: CanBusProfile.CanProfileDisabled },
		MbOption { description: qsTr("VE.Can & Lynx Ion BMS (250 kbit/s)"); value: CanBusProfile.CanProfileVecan; readonly: isReadonly(value) },
		MbOption { description: qsTr("VE.Can & CAN-bus BMS (250 kbit/s)"); value: CanBusProfile.CanProfileVecanAndCanBms; readonly: isReadonly(value) },
		MbOption { description: qsTr("CAN-bus BMS (500 kbit/s)"); value: CanBusProfile.CanProfileCanBms500; readonly: isReadonly(value) },
		MbOption { description: qsTr("Oceanvolt (250 kbit/s)"); value: CanBusProfile.CanProfileOceanvolt; readonly: isReadonly(value) },
		MbOption { description: "Up, but no services (250 kbit/s)"; value: CanBusProfile.CanProfileNone250; readonly: true }
	]
}
