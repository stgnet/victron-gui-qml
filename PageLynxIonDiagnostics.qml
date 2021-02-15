import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	property string bindPrefix
	default property alias content: vModel.children

	model: VisualItemModel {
		id: vModel

		MbItemValue {
			description: qsTr("Shutdowns due error")
			item.bind: Utils.path(bindPrefix, "/Diagnostics/ShutDownsDueError")
			show: item.valid
		}
	}

	Component {
		id: lastError
		MbItemRow {
			property int index
			property string format: "yyyy-MM-dd hh:mm"

			height: defaultHeight * (dateTime.show ? 2 : 1)
			values: MbColumn {
				spacing: 2

				MbTextBlock {
					id: errorText
					item.text: item.valid ? errorValue.description(item.value) : item.invalidText
					item.bind: Utils.path(bindPrefix, "/Diagnostics/LastErrors/" + (index + 1) + "/Error")
					BmsError {
						id: errorValue
					}
				}

				MbTextBlock {
					id: dateTime
					item.bind: Utils.path(bindPrefix, "/Diagnostics/LastErrors/" + (index + 1) + "/Time")
					item.text: item.valid ? Qt.formatDateTime(new Date(item.value * 1000), format) : ""
					visible: item.valid && errorText.item.valid && errorText.item.value !== 0
					anchors.right: errorText.right
				}
			}
		}
	}

	function createItems() {
		var lastErrors = [
			qsTr("Last error"),
			qsTr("2nd last error"),
			qsTr("3rd last error"),
			qsTr("4th last error")
		]

		for (var i = 0; i < lastErrors.length; i++) {
			var o = lastError.createObject(root, {description: lastErrors[i], index: i})
			vModel.append(o)
		}
	}

	Component.onCompleted: createItems()
}
