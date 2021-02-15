import QtQuick 1.1
import com.victron.velib 1.0

/* Test page (and introduction how things are supposed to work as well) */

MbPage {
	title: "Test"

	VBusItem {
		id: exampleItem
		bind: ["com.victronenergy.test/Test/String"]
	}

	/*
	 * Most pages are constructed using a VisualItemModel. A VisualItemModel is typically
	 * populated with MbItems, bound to some local or remote variable or setting. MbItems
	 * themselves can reuse Mb* components to make menus look a bit consistant. MbStyle
	 * provides predefined colors and margins so they are not scattered around.
	 */
	model: VisualItemModel {

		/*
		 * Items can be open code like below and refer to an existing item, bind to a
		 * remote one or a local version can be created.
		 */
		MbItemRow {
			description: "test"

			MbTextValue {
				item: exampleItem
			}

			MbTextValueSmall {
				item.bind: ["com.victronenergy.test/Test/String"]
			}

			MbTextValue {
				item {
					value: "some hardcoded"
					text: item.value + " text"
				}
			}

			/*
			 * A new object can be assigned inline as well, note that it uses value. Even within
			 * the grouped property item {}, item.value must be used (see above)
			 */
			MbTextValueSmall {
				item: VBusItem {
					value: "new"
					text: value + " item"
				}
			}

		}

		// Commonly used construct often have an abbreviated version, like displaying a single value
		MbItemValue {
			description: "Hello"
			item.bind: ["com.victronenergy.test/Test/String"]
		}

		MbItemValue {
			id: customTextItem

			description: "Custom Text"
			item {
				value: 0
				/*
				 * The text representation can be changed to some other then the default.
				 * Note: this needs a workaround in item itself to work properly with Qt Quick 1.1
				 */
				text: "custom " +  item.value
			}

			// A javascript function can be used as well.
			MbTextBlock {
				function quadratic(value) {
					return (value * value).toFixed(0)
				}

				item {
					value: customTextItem.item.value
					text: quadratic(item.value)
				}
			}

			Timer {
				interval: 1000
				running: true; repeat: true; triggeredOnStart: true
				onTriggered: customTextItem.item.value++
			}
		}

		MbItemText {
			text: "I am a long text and hence this will overflow. " +
					"So the height can be adjusted for example by setting wrap mode"
			wrapMode: Text.Wrap
		}

		MbItemRow {
			MbTextBlock {
				width: 100
				item.text: "I overflow as well, but get truncated"
			}

			MbTextBlock {
				item.text: "I expand the block"
			}

			MbTextBlock {
				width: 100
				item.text: "I fit"
			}
		}

		MbSubMenu {
			description: "UI Widget Test Bench"
			subpage: Component {
				PageTestEditWidgets {
					title: "UI Widget Test Bench"
				}
			}
		}

		MbSubMenu {
			description: "Keyboard"
			subpage: Component {
				PageTestKeyboard {
					title: "Keyboard"
				}
			}
		}

		MbSubMenu {
			description: "Tiles Test"
			subpage: Component {
				PageTestTiles {
					title: "UI Widget Test Bench"
				}
			}
		}

		MbSubMenu {
			description: "Overview connection"
			subpage: Component {
				PageTestOverviewConnection {
					title: "Overview connection"
				}
			}
		}
	}
}
