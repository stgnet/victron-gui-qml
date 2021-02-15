import QtQuick 1.1
import "utils.js" as Utils

MbPage {
	id: root

	property string bindPrefix

	property VBusItem code: VBusItem {
		bind: Utils.path(bindPrefix, "/ExtendStatus/GridRelayReport/Code")
		text: valid ? "0x" + value.toString(16) : invalidText
	}

	model: VisualItemModel {

		MbItem {
			id: codeItem
			height: background.y + background.height + 1

			Item {
				height: codeItem.defaultHeight
				width: parent.width

				MbTextDescription {
					property VBusItem counter: VBusItem { bind: Utils.path(bindPrefix, "/ExtendStatus/GridRelayReport/Count") }

					anchors.left: parent.left; anchors.leftMargin: style.marginDefault
					anchors.verticalCenter: parent.verticalCenter
					text: "Last VE.Bus Error 11 report #" + counter.text
					isCurrentItem: codeItem.ListView.isCurrentItem
				}

				MbTextBlock {
					id: _value
					item.text: code.text
					anchors.verticalCenter: parent.verticalCenter
					anchors.right: parent.right; anchors.rightMargin: 2 * style.marginTextHorizontal
				}
			}

			Rectangle {
				id: background
				property int flowHeight: flow.height + 2 * flow.anchors.topMargin
				anchors.top: parent.top
				anchors.topMargin: 35
				height: Math.ceil(flowHeight / codeItem.defaultHeight) * codeItem.defaultHeight - 1
				width: codeItem.width

				Flow {
					id: flow
					width: parent.width
					anchors {
						top: parent.top
						left: parent.left
						right: parent.right
						margins: 2
					}
					spacing: 2

					MbTextBlock {
						visible: code.valid && (code.value & 0x01) != 0
						item.text: "Relay test in progress"
					}

					MbTextBlock {
						item.text: "Relay test OK"
						visible: code.valid && (code.value & 0x02) != 0
					}

					MbTextBlock {
						item.text: "Error occurred"
						visible: code.valid && (code.value & 0x04) != 0
					}

					MbTextBlock {
						item.text: "AC0 /AC1 mismatch"
						visible: code.valid && (code.value & 0x08) != 0
					}

					MbTextBlock {
						item.text: "Communication error"
						visible: code.valid && (code.value & 0x10) != 0
					}

					MbTextBlock {
						item.text: "GND Relay Error"
						visible: code.valid && (code.value & 0x20) != 0
					}

					MbTextBlock {
						item.text: "UMains mismatch"
						visible: code.valid && (code.value & 0x1000) != 0
					}

					MbTextBlock {
						item.text: "Period Time mismatch"
						visible: code.valid && (code.value & 0x2000) != 0
					}

					MbTextBlock {
						item.text: "Drive of BF relay mismatch"
						visible: code.valid && (code.value & 0x4000) != 0
					}

					MbTextBlock {
						item.text: "PE2 open error"
						visible: code.valid && (code.value & 0x10000) != 0
					}

					MbTextBlock {
						item.text: "PE2 closed error"
						visible: code.valid && (code.value & 0x20000) != 0
					}

					MbTextBlock {
						item.value: code.valid ? (code.value & 0xF00) >> 8 : undefined
						item.text: item.valid ? "Failing step: " + item.value : item.invalidText
						visible: item.valid && item.value > 0
					}
				}
			}
		}
	}
}
