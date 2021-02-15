import QtQuick 1.1
import Qt.labs.components.native 1.0

StackPage {
	id: root
	property bool autoSelect: true
	property bool flowing: true
	property bool moving: false
	property bool maximized: !flowing && !moving && active
	property variant currentItem
	property alias model: pathView.model
	property alias currentIndex: pathView.currentIndex
	property int defaultIndex: 0

	visible: false
	tools: currentItem !== undefined && currentItem.mbTools !== undefined ? currentItem.mbTools : mbTools
	showToolBar: currentItem !== undefined && currentItem.showToolBar && !flowing

	Keys.onReturnPressed: if (active) pageStack.pop(); // Go to previous page on the menu
	// Keys.onUpPressed: if (flowing) { autoSelect = !autoSelect; resetAutoselect() }
	Keys.onSpacePressed: if (flowing) switchMode()
	Keys.onEscapePressed: if (flowing) pathView.incrementCurrentIndex(); else switchMode();
	Keys.onLeftPressed: if (flowing) pathView.decrementCurrentIndex();
	Keys.onRightPressed: if (flowing) pathView.incrementCurrentIndex();

	onCurrentItemChanged: resetAutoselect()
	onFlowingChanged: if (flowing) currentItem.status = PageStatus.Inactive


	// trigger a "maximize" animation after component completion
	Component.onCompleted: {
		resetAutoselect()
		currentIndex = defaultIndex
		flowing = false
	}

	// Since the overview themselves are no longer in the pagestack themselves,
	// handle state for them, to enable / disable keyhandling by the overview themself
	onMaximizedChanged: {
		if (currentItem !== undefined) {
			pathView.focus = true
			currentItem.status = maximized ? PageStatus.Active : PageStatus.Inactive
		}
	}

	function switchMode()
	{
		if (currentItem === undefined)
			return

		if (flowing) {
			flowing = false
		} else {
			flowing = true
			resetAutoselect();
		}
	}

	// Background image
	Image {
		source: "image://theme/pageflow-background"
		anchors.fill: parent
		visible: flowing
	}

	Text {
		id: title
		font.pixelSize: 25
		height: flowing ? paintedHeight : 0
		text: root.currentItem !== undefined ? root.currentItem.title : ""
		color: "white"
		anchors {
			horizontalCenter: parent.horizontalCenter
			bottom: parent.bottom
		}

		Behavior on height {NumberAnimation {duration: 200; easing.type: Easing.InOutQuad}}
	}

	Component {
		id: pathDelegate

		Loader {
			property bool isCurrentItem: PathView.isCurrentItem
			source: pageSource
			width: 480
			height: 272
			scale: PathView.isCurrentItem && !flowing ? 1 : PathView.itemScale
			visible: PathView.isCurrentItem || flowing
			z: PathView.depth
			onXChanged: if (isCurrentItem) root.moving = x !== 0
			onSourceChanged: if (isCurrentItem) switchMode()

			// qml from 4.8 does not have currentItem yet, so manually keep track of it
			onLoaded: {
				item.visible = true
				if (isCurrentItem) root.currentItem = item
			}

			onIsCurrentItemChanged: {
				if (item != undefined && isCurrentItem) root.currentItem = item
			}

			// Perform animation only when the currentItem is scaling from/to fullscreen
			Behavior on scale {
				NumberAnimation {
					duration: isCurrentItem && scale >= 0.510 ? 200 : 0
				}
			}

			// White background for the page
			Rectangle {
				color: "white"
				anchors.fill: parent
				visible: parent.scale !== 1
			}

			// If the page is removed, jump to another page, scaling it twice performs a better
			// transition effect and keeps the focus
			Component.onDestruction: {
				if (!isCurrentItem)
					return
				switchMode()
				//currentItem = undefined
				if (pathView.currentIndex !== 0)
					pathView.decrementCurrentIndex()
				else
					pathView.incrementCurrentIndex()
			}
		}
	}

	Rectangle {
		id: timeLine
		height: 3
		width: 0
		visible: openTimer.running
		anchors {
			bottom: parent.bottom; bottomMargin: 35
			horizontalCenter: parent.horizontalCenter
		}

		Behavior on width { NumberAnimation {from: 0; to: 240; duration: openTimer.interval}}
	}

	function resetAutoselect()
	{
		if (autoSelect)
			openTimer.restart()
		else
			openTimer.stop()
	}

	Timer {
		id: openTimer
		interval: 2000
		running: autoSelect && flowing && root.active
		onTriggered: if (autoSelect && currentItem !== undefined) flowing = false
		onRunningChanged: timeLine.width = running ? 240 : 0
	}

	MouseArea {
		anchors.fill: parent
		enabled: !flowing && !moving && !pathView.moving

		property int startDragX
		property int startParentX

		onPressed: {
			startDragX = mouse.x
			startParentX = parent.x
		}

		onMousePositionChanged: {
			parent.x += (mouse.x - startDragX)
		}

		onReleased: {
			if ((parent.x - startParentX) > 4) {
				pathView.decrementCurrentIndex()
			} else if ((startParentX - parent.x) > 4) {
				pathView.incrementCurrentIndex()
			} else if (currentItem) {
				currentItem.showToolbar()
			}

			parent.x = startParentX
		}
	}

	PathView {
		id: pathView
		anchors.fill: parent
		delegate: pathDelegate
		visible: parent.visible
		focus: root.active

		// the flicking behavior is sub-optimal with the touch screen, the interactivity
		// is handled with a mousearea above.
		interactive: false

		// When scaling down the page some borders dissapear, values set here are calculated
		// to keep the best looking possible.
		path: Path {
			startX: pathView.pathX(0); startY: pathView.pathY(0);
			PathAttribute { name: "itemScale"; value: pathView.getNearScale()}
			PathAttribute { name: "depth"; value: 10 }
			PathPercent { value: 0.0 }
			PathLine { x: pathView.pathX(1); y: pathView.pathY(1);}
			PathPercent { value: flowing ? 0.25 : 0.5 }
			PathLine { x: pathView.pathX(2); y: pathView.pathY(2);}
			PathAttribute { name: "depth"; value: 0 }
			PathAttribute { name: "itemScale"; value: pathView.getFarScale()}
			PathLine { x: pathView.pathX(3); y: pathView.pathY(3);}
			PathPercent { value: flowing ? 0.75 : 0.5 }
			PathLine { x: pathView.pathX(0); y: pathView.pathY(0);}
			PathPercent { value: 1.0}
		}

		function getNearScale() {
			return flowing ? 0.515 : 1.0
		}

		function getFarScale() {
			return flowing ? (pathView.count % 2 == 0 ? 0.212 : 0.210) : 1.0
		}

		function pathX(index) {
			return (flowing ? flowPoints[index] : nonFlowPoints[index]).x;
		}

		function pathY(index) {
			return (flowing ? flowPoints[index] : nonFlowPoints[index]).y;
		}

		property variant nonFlowPoints : [
			{x: 240, y: 136},
			{x: 550, y: 136},
			{x: 240, y: 136},
			{x: -70, y: 136}
		];

		property variant flowPoints : [
			{x: 240, y: 160},
			{x: 550, y: 75},
			{x: 240, y: 49},
			{x: -70, y: 75}
		];
	}
}
