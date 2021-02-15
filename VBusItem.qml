import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

QtObject {
	id: root

	// the unique id of the item to bind to
	property variant bind

	// runtime properties (readonly)
	property alias value: _item.value
	property bool valid: value !== undefined
	property alias seen: _item.seen

	/*
	 * By default the text represenation from the remote side is used. If it is an empty
	 * string it is substituted with the invalidText property. Local formating can be done
	 * by assigning a value to decimals or unit. The text property can always be overwritten
	 * to be an arbitrary function taking value as input. So this should work as well:
	 *
	 * item {
	 *   value: 20
	 *   text: someFunction(value)
	 * }
	 */
	property string __text: _localFormatter ?
							(valid ? value.toFixed(decimals < 0 ? 0 : decimals) + unit : "") :
							_item.text
	property string _text: __text ? __text : invalidText /* needed for workaround for QtQuick 1.1, see below */
	property string text: _text
	property bool textValid: __text !== ""
	property string unit
	property int decimals: -1
	property string invalidText: "--"

	/*
	 * Settings related properties (can be overwritten)
	 * Note this must be enabled by setting isSetting to true or otherwise an attempt
	 * is always made to fetch these from the remote side.
	 */
	property bool isSetting: false
	property double min: isSetting && _item.min ? _item.min : 0
	property double max: isSetting && _item.max ? _item.max : 100
	property double step: 1
	property variant defaultValue: isSetting && _item.defaultValue

	property bool _localFormatter : unit || decimals != -1

	// to be deleted, same as text
	property string uiText: text

	// note: the dbus/ stub is temporarily and will be removed again...
	property VeQuickItem veQItem: VeQuickItem {
		id: _item

		// for the moment remove the dbus/ prefix when specified and add it back later, so it is always there
		// mind it, passing dbus/ only confuses the cpp side and will make it assert.
		property string rid: bind ? (Array.isArray(bind) ? Utils.pathFromArray(bind) : bind).replace("dbus/", "") : ""
		uid: rid ? "dbus/" + rid : ""
	}

	function setValue(variant)
	{
		_item.setValue(variant)
	}

	/*
	 * Workaround for Qt Quick 1.1: when text is reassigned it still gets updated from
	 * _item.text even though it is no longer assigned to it. Hence explicity break updates
	 * of _text by an assignment. Qt Quick 2.0 and up work as expected though, so this can
	 * be removed once it is no longer used.
	 */
	property bool _workAroundActive;
	onTextChanged: {
		if (!_workAroundActive && text !== _text) {
			_workAroundActive = true
			_text = text
		}
	}

	function format(decimals)
	{
		if (!valid)
			return invalidText

		return value.toFixed(decimals) + unit;
	}

	function absFormat(decimals)
	{
		if (!valid)
			return invalidText

		return Math.abs(value).toFixed(decimals) + unit;
	}
}
