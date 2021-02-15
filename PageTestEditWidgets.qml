import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	id: pageWidgetTestBench

	model: VisualItemModel {
		MbEditBox {
			description: "Free text MbEditBox"
			maximumLength: 20
			item.bind: "com.victronenergy.settings/Settings/Gui/FreeTextTest"
			writeAccessLevel: User.AccessUser
		}

		MbEditBox {
			overwriteMode: true
			description: "Free text MbEditBox"
			maximumLength: 20
			item.bind: "com.victronenergy.settings/Settings/Gui/FreeTextTest"
			writeAccessLevel: User.AccessUser
		}

		MbEditBoxIp {
			description: "Numeric MbEditBoxIP"
			item.value: "192.168.003.012"
		}

		MbEditBoxDateTime {
			id: dateLocal
			description: "Date/Time MbEditBoxDateTime"
			writeAccessLevel: User.AccessUser
			onEditDone: vePlatform.setSystemTime(item.value)

			Timer {
				interval: 1000
				running: !dateLocal.editMode
				repeat: true
				triggeredOnStart: true
				onTriggered: dateLocal.item.value = new Date().getTime() / 1000
			}
		}

		MbEditBoxTime {
			description: "Timer MbEditBoxTime"
			item.bind: "com.victronenergy.settings/Settings/Gui/TimeTest"
			writeAccessLevel: User.AccessUser
		}

		MbItemOptions {
			description: "Options MbItemOptions"
			bind: "com.victronenergy.settings/Settings/Gui/OptionTest"
			possibleValues: [
				MbOption { description: "Option A"; value: 0; },
				MbOption { description: "Option B"; value: 1; },
				MbOption { description: "Option C"; value: 2; },
				MbOption { description: "Option D"; value: 3; }
			]
			writeAccessLevel: User.AccessUser
		}

		MbSpinBox {
			description: "Spin box MbSpinBox"
			bind: "com.victronenergy.settings/Settings/Gui/SpinBoxTest"
			writeAccessLevel: User.AccessUser

			subpage: Component {
				MbPage {
					model: VisualItemModel {
						MbItemText {
							text: "Test"
						}
					}
				}
			}
		}

		MbRangeSlider {
			description: "Range MbRangeSlider"
			lowBind: "com.victronenergy.settings/Settings/Gui/RangeTestLow"
			highBind: "com.victronenergy.settings/Settings/Gui/RangeTestHigh"
			numOfDecimals: 1
			stepSize: 0.1
			highColor: "green"
			lowColor: "lightgreen"
			writeAccessLevel: User.AccessUser
		}

		MbItemSlider {
			id: backlight
			icondId: "icon-items-brightness"
			enabled: true
			item {
				min: 0
				max: 100
				step: 5
				value: 50
			}
		}

		MbSwitch {
			name: "Switch"
			bind: "com.victronenergy.settings/Settings/Gui/TimeTest"
		}

		/*
		 * undocumented in qt4, but from qt5:
		 *
		 * enabled : bool
		 *
		 * This property holds whether the item receives mouse and keyboard events.
		 * By default this is true.
		 *
		 * Setting this property directly affects the enabled value of child items.
		 * When set to false, the enabled values of all child items also become false.
		 * when set to true, the enabled values of child items are returned to true,
		 * unless they have explicitly been set to false.
		 *
		 * Setting this property to false automatically causes activeFocus to be set
		 * to false, and this item will no longer receive keyboard events.
		 *
		 * See below, qt4 will produce a warning when enabed is set to false on a
		 * parent. It seems to be harmless, but is does indicate that a user can
		 * click on something which is disabled, which likely should be replaced,
		 * likely leftovers from the key only navigation.
		 */
		MbItemText {
			enabled: false
			text: "QGraphicsItem::ungrabMouse: not a mouse grabber"

			MouseArea {
				anchors.fill: parent
			}
		}
	}
}
