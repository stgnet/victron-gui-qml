import QtQuick 1.1

Tile {
	id: root

	property bool valid: vItem.value !== undefined
	property alias bind: vItem.bind
	property alias description: _description.text
	property alias extraDescription: _extraDescription.text
	property double stepSize: 0.5
	property int numOfDecimals: 1
	//property bool readOnly
	property string unit: ""
	property real localValue: valid ? value : 0
	property alias value: vItem.value
	property alias item: vItem
	property real min: vItem.min !== undefined ? vItem.min : 0
	property real max: vItem.max !== undefined ? vItem.max : 100
	property int fontPixelSize: 18
	property bool expanded: false // If the tile is 'expanded', additional touch buttons are shown
	property color buttonColor
	property alias containsMouse: mouseArea.containsMouse

	height: contentHeight + 2
	editable: true

	Behavior on height {
		PropertyAnimation {
			duration: 150
		}
	}

	signal accepted()

	function editIsAllowed() {
		return true;
	}

	VBusItem {
		id: vItem
	}

	values: [
		Button {
			height: 30
			x: 3
			width: root.width - 6
			baseColor: enabled ? root.buttonColor : pressedColor
			pressedColor: root.color
			onClicked: tickUp()
			visible: expanded
			enabled: localValue < max
			enablePressAndHold: true
			content: MbIcon {
				iconId: "icon-toolbar-arrow-up"
				visible: parent.enabled
			}
		},
		TileTextMultiLine {
			id: _description
			width: root.width - 6
			height: visible ? paintedHeight : 0
			visible: text !== ""
		},

		TileText {
			id: _value
			text: format(root.localValue.toFixed(numOfDecimals)) + root.unit
			font.pixelSize: root.fontPixelSize
			font.bold: editMode
			width: root.width

			Item {
				visible: root.editMode
				height: 18
				anchors {
					verticalCenter: _value.verticalCenter
					right: parent.right; rightMargin: 3
				}

				MbIcon {
					iconId: "icon-toolbar-arrow-up"
					visible: localValue < max && !expanded
					anchors.top: parent.top
					anchors.right: parent.right
				}

				MbIcon {
					iconId: "icon-toolbar-arrow-down"
					visible: localValue > min && !expanded
					anchors.bottom: parent.bottom
					anchors.right: parent.right
				}
			}
		},
		Button {
			height: 30
			width: root.width - 6
			x: 3
			baseColor: enabled ? root.buttonColor : pressedColor
			pressedColor: root.color
			onClicked: tickDown()
			enabled: localValue > min
			enablePressAndHold: true
			visible: expanded
			content: MbIcon {
				iconId: "icon-toolbar-arrow-down"
				visible: parent.enabled
			}
		},
		Item { width: 1; height: expanded ?  4 : 0; visible: expanded},
		Row {
			width: root.width - 6
			x: 3
			spacing: 4
			visible: expanded

			Button {
				id: acceptButton
				baseColor: root.buttonColor
				pressedColor: root.color
				height: 40
				width: parent.width * 0.5 - 2
				onClicked: edit()
				content: TileText {
					text: qsTr("Accept")
				}
			}

			Button {
				id: cancelButton
				baseColor: root.buttonColor
				pressedColor: root.color
				height: 40
				width: parent.width * 0.5 - 2
				onClicked: cancel()
				content: TileText {
					text: qsTr("Cancel")
				}
			}
		},

		TileTextMultiLine {
			id: _extraDescription
			width: root.width - 6
		}
	]

	Keys.onSpacePressed: { event.accepted = editMode; edit(false) }
	Keys.onLeftPressed: { if (editMode) cancel(); event.accepted = false }
	Keys.onRightPressed: { if (editMode) cancel(); event.accepted = false }
	Keys.onDownPressed: {
		tickDown()
		event.accepted = editMode
	}
	Keys.onUpPressed: {
		tickUp()
		event.accepted = editMode
	}

	function tickDown() {
		if (editMode) {
			var newValue = root.localValue - root.stepSize
			newValue = Math.floor((newValue + stepSize / 2) / stepSize) * stepSize
			if (newValue < root.min)
				newValue = root.min
			root.localValue = newValue
		}
	}

	function tickUp() {
		if (editMode) {
			var newValue = root.localValue + root.stepSize
			newValue = Math.floor((newValue + stepSize / 2) / stepSize) * stepSize
			if (newValue > root.max)
				newValue = root.max
			root.localValue = newValue
		}
	}

	function edit(isMouse)
	{
		if (!root.valid || root.readOnly)
			return

		if (!editIsAllowed())
			return

		if (root.editMode) {
			vItem.setValue(parseFloat(localValue))
			root.editMode = false
			expanded = false
			accepted()
		} else {
			root.localValue = Math.floor((root.localValue + stepSize / 2) / stepSize) * stepSize
			root.editMode = true
			if (isMouse)
				expanded = true
		}
	}

	function cancel()
	{
		root.localValue = vItem.value
		root.editMode = false
		root.expanded = false
	}

	function format(val)
	{
		return val
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		enabled: !expanded
		onClicked: edit(true)
	}

	/* binding is done explicitly to reenable binding after edit */
	Binding {
		target: root
		property: "localValue"
		value: root.value
		when: valid && !editMode
	}
}
