import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

QtObject {
	id: inverterData

	property string bindPrefix
	property AcData acOut: AcData {
		bindPrefix: Utils.path(inverterData.bindPrefix, "/Ac/Out/L1")
	}

	property VBusItem _isInverterCharger: VBusItem { bind: Utils.path(bindPrefix, "/IsInverterCharger") }
	property bool isInverterCharger: _isInverterCharger.value === 1
}
