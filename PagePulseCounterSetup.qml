import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	title: qsTr("Setup")

	property string bindPrefix

	model: VisualItemModel {
		MbItemOptions {
			id: volumeUnit
			description: qsTr("Volume unit")
			bind: "com.victronenergy.settings/Settings/System/VolumeUnit"
			possibleValues: [
				MbOption { description: qsTr("Cubic metre"); value: 0 },
				MbOption { description: qsTr("Litre"); value: 1 },
				MbOption { description: qsTr("Imperial gallon"); value: 2 },
				MbOption { description: qsTr("U.S. gallon"); value: 3 }
			]
		}

		MbSwitch {
			name: qsTr("Inverted")
			bind: Utils.path(settingsBindPreffix, "/InvertTranslation")
		}

		MbEditBox {
			id: multiplierEditor
			item: VBusItem {
				id: multiplier
				isSetting: true
				bind: Utils.path(settingsBindPreffix, "/Multiplier")
				text:  "" + value.toFixed(6)
			}
			description: qsTr("Multiplier")
			matchString: "0123456789"
			ignoreChars: "."
			maximumLength: 8
			overwriteMode: true
			numericOnlyLayout: true

			function validate(newText, pos) {
				var v = parseFloat(newText)
				if (isNaN(v))
					return null

				if (v < item.min || v > item.max) {
					toast.createToast(qsTr("Value must be between %1 and %2").arg(item.min.toFixed(6)).arg(item.max.toFixed(6)))
					return null
				}

				return newText
			}

			function editTextToValue() {
				return parseFloat(_editText)
			}
		}

		MbOK {
			description: qsTr("Reset counter")
			value: itemCount.value
			editable: true
			onClicked: {
				itemCount.setValue(0)
			}
			VBusItem {
				id: itemCount
				bind: Utils.path(bindPrefix, "/Count")
			}
		}
	}
}
