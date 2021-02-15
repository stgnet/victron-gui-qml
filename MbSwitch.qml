import QtQuick 1.1
import Qt.labs.components.native 1.0
import com.victron.velib 1.0

MbItem {
	id: root

	property alias name: name.text
	property alias bind: vItem.bind
	property alias valid: vItem.valid
	property alias item: vItem
	property alias checked: theSwitch.checked
	property alias onText: theSwitch.onText
	property alias offText: theSwitch.offText
	property alias enabled: theSwitch.enabled
	property variant valueTrue: 1
	property variant valueFalse: 0
	property bool invertSense: false

	signal editDone(string newValue)

	VBusItem {
		id: vItem
	}

	MbTextDescription {
		id: name
		anchors {
			left: parent.left; leftMargin: style.marginDefault
			verticalCenter: parent.verticalCenter
		}
	}

	Switch {
		id: theSwitch
		anchors {
			verticalCenter: parent.verticalCenter
			right: parent.right; rightMargin: root.style.marginDefault
		}
		checked: (vItem.valid && vItem.value !== valueFalse) ^ invertSense;
		enabled: vItem.valid && root.userHasWriteAccess
	}

	function edit() {
		/*
		 * When binding to the dbus change the value there and update after the
		 * change. Also support local changes so the component can be reused.
		 */
		if (enabled) {
			if (bind) {
				var newValue = theSwitch.checked ^ invertSense ? valueFalse : valueTrue
				vItem.setValue(newValue)
				editDone(newValue)
			} else {
				checked = !checked
				editDone(checked)
			}
		}
	}
}
