import QtQuick 1.1
import "utils.js" as Utils

MbPage {
	id: root
	property string bindPrefix
	property int index: bindPrefix.split("/").splice(-1)[0]

	model: VisualItemModel {
		MbItemValue {
			description: "AC sensor " + index + " energy"
			item.bind: Utils.path(bindPrefix, "/Energy")
		}

		MbItemValue {
			description: "AC sensor " + index + " power"
			item.bind: Utils.path(bindPrefix, "/Power")
		}

		MbItemValue {
			description: "AC sensor " + index + " voltage"
			item.bind: Utils.path(bindPrefix, "/Voltage")
		}

		MbItemValue {
			description:  "AC sensor " + index + " current"
			item.bind: Utils.path(bindPrefix, "/Current")
		}

		MbItemValue {
			description:  "AC sensor " + index + " location"
			item.bind: Utils.path(bindPrefix, "/Location")
		}

		MbItemValue {
			description: "AC sensor " + index + " phase"
			item.bind: Utils.path(bindPrefix, "/Phase")
		}
	}
}
