import QtQuick 1.1
import Qt.labs.components.native 1.0
import com.victron.velib 1.0

MbItem {
	id: root
	height: buttonExplanation.y + buttonExplanation.height + 1
	cornerMark: !editMode

	property real minValue: lowItem.min !== undefined ? lowItem.min : 0
	property real maxValue: highItem.max !== undefined ? highItem.max : 100

	property alias description: descriptionText.text
	property real stepSize: 1.0
	property int numOfDecimals: 0
	property string unit
	property bool valid: lowItem.valid && highItem.valid

	property color lowColor: "white"
	property color highColor: "white"

	property alias lowBind: lowItem.bind
	property alias highBind: highItem.bind

	property real lowDisabledValue: minValue
	property real highDisabledValue: minValue

	property real lowDefaultValue: lowItem.defaultValue !== undefined ? lowItem.defaultValue : 0
	property real highDefaultValue: highItem.defaultValue !== undefined ? highItem.defaultValue : 0

	/* Enabled is a reserved key word */
	property bool disabled: lowValue === lowDisabledValue && highValue === highDisabledValue
	property bool editMode: false

	property real lowValue: lowItem.valid ? lowItem.value : minValue
	property real highValue: highItem.valid ? highItem.value : maxValue

	property bool _hintVisible: editMode && useSevenButtonKeyboard
	property bool _disableButtonVisible: editMode && !useSevenButtonKeyboard

	property bool useSevenButtonKeyboard: false

	onHeightChanged: listview.positionViewAtIndex(currentIndex, ListView.Contain)

	function save() {
		if (editMode) {
			apply()
			editMode = false
		}
	}

	function cancel() {
		editMode = false
	}

	VBusItem {
		id: lowItem
		isSetting: true
	}

	VBusItem {
		id: highItem
		isSetting: true
	}

	Item {
		id: descriptionItem
		height: 35
		width: parent.width

		MbTextDescription {
			id: descriptionText
			color: root.ListView.isCurrentItem ? style.textColorSelected : style.textColor
			anchors {
				left: parent.left
				leftMargin: style.marginDefault
				verticalCenter: parent.verticalCenter
			}
		}
	}

	Item {
		id: sliderItem
		height: 75
		width: parent.width
		anchors {
			horizontalCenter: parent.horizontalCenter
			top: descriptionItem.bottom
			topMargin: -6
		}

		SvgRectangle {
			id: slider
			height: 5
			width: parent.width - 50
			color: "lightgrey"
			border.width: 1
			border.color: "#fff"
			anchors.centerIn: parent

			Circle {
				id: lowValueHandle
				x: slider.width / (maxValue - minValue) * (lowValue - minValue) - radius
				radius: 10
				border.color: handleMouseArea.draggingLow ? "#777" :"#ddd"
				border.width: 2
				color: disabled || !editMode ? "grey" : lowColor
				anchors.verticalCenter: parent.verticalCenter

				Behavior on x {
					NumberAnimation {
						duration: 100
					}
				}

				MbBackgroundRect {
					height: 18
					width: lowValueLabel.paintedWidth <= 45 ? lowValueLabel.paintedWidth + 5 : 45
					visible: !disabled
					anchors {
						horizontalCenter: parent.horizontalCenter
						top: parent.bottom
						topMargin: 3
					}

					MbTextValueSmall {
						id: lowValueLabel
						text: lowValue.toFixed(numOfDecimals) + root.unit
						scale: paintedWidth > parent.width ? (parent.width / paintedWidth) : 1
						anchors.centerIn: parent
						horizontalAlignment: Text.AlignHCenter
					}
				}
			}

			Circle {
				id: highValueHandle
				x: slider.width / (maxValue - minValue) * (highValue - minValue) - radius
				radius: 10
				border.color: handleMouseArea.draggingHigh ? "#777" :"#ddd"
				border.width: 2
				color: disabled || !editMode ? "grey" : highColor
				anchors.verticalCenter: parent.verticalCenter

				Behavior on x {
					NumberAnimation {
						duration: 100
					}
				}

				MbBackgroundRect {
					height: 18
					width: highValueLabel.paintedWidth + 5 <= 45 ? highValueLabel.paintedWidth + 5 :45
					visible: !disabled
					anchors {
						horizontalCenter: parent.horizontalCenter
						bottom: parent.top
						bottomMargin: 3
					}

					MbTextValueSmall {
						id: highValueLabel
						text: highValue.toFixed(numOfDecimals) + root.unit
						scale: paintedWidth > parent.width ? (parent.width / paintedWidth) : 1
						horizontalAlignment: Text.AlignHCenter
						anchors.centerIn: parent
					}
				}
			}

			SvgRectangle {
				id: rangeBar
				height: 6
				color: "lightblue"
				anchors {
					left: lowValueHandle.right
					right: highValueHandle.left
					verticalCenter: parent.verticalCenter
				}
			}

			// Converts from slider pixels to range [minValue, maxValue]
			function pixelToValue(pixel) {
				var t = pixel/slider.width
				return t * maxValue + (1 - t) * minValue
			}
		}

		MouseArea {
			id: handleMouseArea
			anchors.fill: sliderItem
			preventStealing: draggingHigh || draggingLow
			property bool draggingHigh: false
			property bool draggingLow: false
			property int handleRadius: lowValueHandle.radius // assume both handles have the same size
			enabled: editMode

			onPressed: {
				if (editMode) {
					var hitHigh = mouseCursorOnHandle(highValueHandle, mouse)
					var hitLow = mouseCursorOnHandle(lowValueHandle, mouse)

					if (hitHigh && hitLow) {
						var highDistance = mouseCursorDistanceSquared(highValueHandle, mouse)
						var lowDistance = mouseCursorDistanceSquared(lowValueHandle, mouse)

						draggingHigh = (highDistance <= lowDistance)
						draggingLow = !draggingHigh
					} else if (hitHigh) {
						draggingHigh = true
					} else if (hitLow) {
						draggingLow = true
					}
				}

				// let event propagate if we are not dragging
				mouse.accepted = draggingHigh || draggingLow
			}

			function mouseCursorOnHandle(handle, mouse) {
				// use larger radius for enhanced usability
				return (mouseCursorDistanceSquared(handle, mouse) <= handleRadius * handleRadius * 9)
			}

			function mouseCursorDistanceSquared(handle, mouse) {
				var handleCoordinates = mapToItem(handle, mouse.x, mouse.y)
				var x = handleCoordinates.x - handleRadius
				var y = handleCoordinates.y - handleRadius

				return (x * x) + (y * y)
			}

			onMousePositionChanged: setValue(mouse)

			onReleased: {
				setValue(mouse)
				draggingHigh = false
				draggingLow = false
			}

			function setValue(mouse) {
				if (draggingLow || draggingHigh) {
					var value = slider.pixelToValue(mouse.x - slider.x)

					var min = draggingLow ? minValue : lowValue
					var max = draggingLow ? highValue : maxValue
					value = Math.max(min, Math.min(max, value))

					value = valueToStepSize(value)
					if (draggingLow) {
						lowValue = value
					} else {
						highValue = value
					}
				}
			}
		}
	}

	Rectangle {
		id: touchScreenDisableButton
		width: parent.width
		anchors.top: sliderItem.bottom
		height: _disableButtonVisible ? 40 : 0
		visible: _disableButtonVisible

		Behavior on height {
			PropertyAnimation {
				id: disableButtonAnimation
				duration: 300;
			}
		}

		Rectangle {
			id: buttonRect
			width: 3 * 28
			height: 28
			anchors {
				bottom: parent.bottom
				topMargin: 2
				bottomMargin: 2
				verticalCenter: parent.verticalCenter
				horizontalCenter: parent.horizontalCenter
			}

			radius: 2
			color: (mouseArea.containsMouse && mouseArea.pressed) ? "#637e99" : "#4b5f73"
			visible: _disableButtonVisible && !disableButtonAnimation.running

			Text {
				text: disabled ?  qsTr("Enable") : qsTr("Disable")
				anchors.centerIn: buttonRect
				color: "white"
				font.pixelSize: 16
			}
		}

		MouseArea {
			id: mouseArea
			anchors.fill: buttonRect
			onClicked: disabled ? enable() : disable()
		}
	}

	MbButtonExplanation {
		id: buttonExplanation
		anchors.top: touchScreenDisableButton.bottom
		width: root.width
		shown: _hintVisible
		upDownText: qsTr("Change low value")
		leftRightText: qsTr("Change high value")
		centerText: disabled ? qsTr("Enable") : qsTr("Disable")
	}

	Binding {
		target: root
		property: "lowValue"
		value: lowItem.value
		when: lowItem.valid && !editMode
	}

	Binding {
		target: root
		property: "highValue"
		value: highItem.value
		when: highItem.valid && !editMode
	}

	function apply() {
		lowItem.setValue(lowValue)
		highItem.setValue(highValue)
	}

	function edit(isMouse) {
		useSevenButtonKeyboard = !(isMouse === true) // isMouse undefined or false

		if (editMode && useSevenButtonKeyboard) { // Not using mouse
			if (disabled)
				enable()
			else
				disable()
		}

		if (!editMode)
			editMode = true;
	}

	Keys.onUpPressed: {
		if (editMode && (lowValue + stepSize) <= (highValue + stepSize / 2))
			lowValue += stepSize
		event.accepted = editMode
	}

	Keys.onDownPressed: {
		if (editMode && (lowValue - stepSize) >= (minValue - stepSize / 2))
			lowValue -= stepSize
		event.accepted = editMode
	}

	Keys.onRightPressed: {
		if (editMode && (highValue + stepSize) <= (maxValue + stepSize / 2))
			highValue += stepSize
		event.accepted = editMode
	}

	Keys.onLeftPressed: {
		if (editMode && (highValue - stepSize) >= (lowValue - stepSize / 2))
			highValue -= stepSize
		event.accepted = editMode
	}

	Keys.onReturnPressed: save()

	Keys.onEscapePressed: cancel()

	function disable() {
		lowValue = lowDisabledValue
		highValue = highDisabledValue
	}

	function enable() {
		lowValue = lowDefaultValue
		highValue = highDefaultValue
	}

	// converts value to be an integer multiple of stepSize and rounds to numOfDecimals
	function valueToStepSize(value) {
		var ret = stepSize * Math.round(value / stepSize)
		var scaler = Math.pow(10, root.numOfDecimals)
		return Math.round(ret * scaler) / scaler
	}
}
