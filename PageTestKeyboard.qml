import QtQuick 1.1

MbPage {
	model: VisualItemModel {
		TextInput {
			width: parent.width
		}

		Keyboard {
			numericOnlyLayout: numericOnly.checked
			active: active.checked
		}

		MbCheckBox {
			id: numericOnly
			description: "Numeric only"
		}

		MbCheckBox {
			id: active
			description: "Active"
		}
	}
}
