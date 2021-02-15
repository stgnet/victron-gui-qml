import QtQuick 1.1
import Qt.labs.components.native 1.0
import "utils.js" as Utils

StackPage {
	id: listPage

	property alias model: browser.model
	property alias delegate: browser.delegate
	property alias currentIndex: browser.currentIndex
	property alias listview: browser
	property variant summary
	property int _visibleIndex: browser.currentIndex
	property int _visibleCount: countVisibleItems()
	property bool _lastItemReached
	property bool _firstItemReached
	property bool userInteraction

	// Custom toolbarhandler for the page when not in edit mode
	property variant pageToolbarHandler

	toolbarHandler: browser.currentItem && browser.currentItem.toolbarHandler && !browser.currentItem.toolbarHandler.isDefault ? browser.currentItem.toolbarHandler :
						pageToolbarHandler ? pageToolbarHandler :
						browser.currentItem && browser.currentItem.toolbarHandler ? browser.currentItem.toolbarHandler : mainToolbarHandler
	showStatusBar: true

	onActiveChanged: {
		if (active) {
			scrollIndicator = getScrollIndicator()
			listview.positionViewAtIndex(listview.currentIndex, ListView.Visible)
		}
	}

	onModelChanged: initListView()

	// Called after the page is popped and the transition finished.
	// Restore initial state, so there is no difference between entering the
	// menu the first time and the subsequent one for pages which do not get
	// destoyed.
	function cleanup()
	{
		userInteraction = false
		initListView()
	}

	function initListView()
	{
		if (userInteraction)
			return;

		listview.currentIndex = firstVisibleItem()
		scrollIndicator = getScrollIndicator()
		listview.positionViewAtIndex(listview.currentIndex, ListView.Beginning)
	}

	ListView {
		id: browser
		height: 210
		width: parent.width
		focus: listPage.status === PageStatus.Active || listPage.status === PageStatus.Activating
		snapMode: ListView.SnapOneItem
		clip: true
		cacheBuffer: height + 1 // QTBUG-61537

		Component.onCompleted: {
			currentIndex = firstVisibleItem()
			if (currentIndex !== -1)
				positionViewAtIndex(currentIndex, ListView.Beginning)
		}

		Keys.onLeftPressed: if (listPage.status === PageStatus.Active && pageStack.depth > 1) pageStack.pop()

		Keys.onUpPressed: {
			if (_visibleIndex > 0) {
				_visibleIndex--
			}
			event.accepted = false
		}

		Keys.onDownPressed: {
			if (_visibleIndex < _visibleCount - 1) {
				_visibleIndex++
			}
			event.accepted = false
		}

		Keys.onReturnPressed: if (toolbarHandler) toolbarHandler.rightAction(false)
		Keys.onEscapePressed: if (toolbarHandler) toolbarHandler.leftAction(false)
		Keys.onSpacePressed: if (toolbarHandler) toolbarHandler.centerAction()

		Keys.onPressed: userInteraction = true
		onCurrentItemChanged: scrollIndicator = getScrollIndicator()
	}

	MouseArea {
		anchors.fill: browser
		onPressed: {
			userInteraction = true
			mouse.accepted = false
		}
	}

	/* As some items are not visible (show = false) a extra work is necessary to implement scroll indicators. We need to iterate the
	model to count visible items only. We also need to keep the count of current index to get the index related to visible items.
	The correct way to implement the scroll indicator should be using "atYEnd" property, but does not work correctly when scrolling
	to the end holding down the "down" key, and is also not usable when the listview have non-visible items.*/

	function getScrollIndicator() {
		var up = false
		var down = false
		var updown = false
		var icon = ""
		var count = _visibleCount
		var index = _visibleIndex

		if (count > 6) {
			if (index == count - 1)
				_lastItemReached = true

			if (index < count - 6 && _lastItemReached)
				_lastItemReached = false

			if (index == 0)
				_firstItemReached = true

			if (index > 5)
				_firstItemReached = false

			down = !_lastItemReached
			up = !_firstItemReached
			updown = up && down
			icon = updown ? "icon-toolbar-arrow-up-down" :
					down ? "icon-toolbar-arrow-down" :
					up ? "icon-toolbar-arrow-up" :
					""
		}

		return icon
	}

	function countVisibleItems()
	{
		// When model is a not a VisualItemModel all items are visible
		if (!Utils.qmltypeof(browser.model, "QDeclarativeVisualItemModel"))
			return browser.count

		var count = 0

		if (browser.model && browser.model.children !== undefined)
			for (var i = 0; i < browser.model.count; i++) {
				count += browser.model.children[i].show ? 1: 0
			}
		else
			count = browser.count

		return count
	}

	function firstVisibleItem()
	{
		if (browser.model && browser.model.children !== undefined)
			for (var i = 0; i < browser.model.count; i++) {
				if (browser.model.children[i].show)
					return i
				browser.model.children[i].showChanged.connect(initListView)
			}
		return 0;
	}
}
