import QtQuick 1.1
import com.victron.velib 1.0
import net.connman 0.1
import "utils.js" as Utils

MbPage {
	id: root
	title: qsTr("Bluetooth")

	model: VisualItemModel {
		MbSwitch {
			id: bluetoothEnabled
			name: qsTr("Enabled")
			bind: "com.victronenergy.settings/Settings/Services/Bluetooth"
		}

		MbEditBox {
			show: bluetoothEnabled.item.value
			description: qsTr("Pincode")
			maximumLength: 6
			item.bind: "com.victronenergy.settings/Settings/Ble/Service/Pincode"
			writeAccessLevel: User.AccessUser
			matchString: "0123456789"
			numericOnlyLayout: true
			overwriteMode: true
			readonly: !userHasWriteAccess || !item.valid

			onEditDone: {
				toast.createToast(qsTr("It might be necessary to remove existing pairing information before connecting."), 10000)
			}
		}
	}
}
