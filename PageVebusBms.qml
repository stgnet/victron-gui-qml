import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	model: VisualItemModel {
		property VBusItem bmsType: VBusItem { bind: service.path("/Bms/BmsType") }
		property int bmsTypeVebus: 2

		MbItemNoYes {
			description: qsTr("Allow to charge")
			bind: service.path("/Bms/AllowToCharge")
			readonly: true
		}

		MbItemNoYes {
			description: qsTr("Allow to discharge")
			bind: service.path("/Bms/AllowToDischarge")
			readonly: true
		}

		MbItemNoYes {
			description: qsTr("BMS Error")
			bind: service.path("/Bms/Error")
			readonly: true
			show: bmsType.value === bmsTypeVebus
		}
	}
}
