// When all items in a submenu can be optional, the submenu
// might not be shown at all. By placing VBusItemCheckValid inside
// an Item with id itemContainer property anyItemValid, it will
// reflect if any of the items are valid.
VBusItem {
	onValidChanged: {
		if (valid)
			itemContainer.anyItemValid = true
	}
}
