import QtQuick 1.1
import "utils.js" as Utils
import Qt.labs.components.native 1.0

StackPage {
	property variant acSourceName: [qsTr("Not available"), qsTr("Grid"), qsTr("Generator"), qsTr("Shore")]
	property variant acSourceIcon: ["overview-ac-power", "overview-grid-power", "overview-generator-power", "overview-shore-power"]

	focus: active
	width: Screen.width
	height: Screen.height
	showToolBar: false

	// Show the toolbar to indicate only chose keys are active
	// The tiles overview uses the left / right keys so those can't be used.
	// Toolbar keys themselves are handled by main.qml
	Keys.onRightPressed: showToolbar()
	Keys.onLeftPressed: showToolbar()
	Keys.onUpPressed: showToolbar()
	Keys.onDownPressed: showToolbar()
	Keys.onSpacePressed: showToolbar()

	// show the toolbar, but auto hide it
	function showToolbar() {
		showToolBar = true
		hideToolBarTimer.start()
	}

	Timer {
		id: hideToolBarTimer
		interval: 3000
		running: false
		onTriggered: root.showToolBar = false
	}

	/*
	 * Determine direction of power flow, but ignore some noise
	 * Typically used for directions of the arrows, 1W @ 230V -> 4mA RMS.
	 * Since you don't want to overreact with the visual indication, only
	 * some arbritary significant power is shown as power flow. A less
	 * arbitrare choise would be to base it one the maximum or nominal power
	 * flow of the connection... This function ignores some low power values
	 * around zero, the flow function below returns the sign of it.
	 */
	function noNoise(power)
	{
		if (power === undefined || !power.valid)
			return 0;

		if (power.value < -30)
			return power.value
		if (power.value > 30)
			return power.value

		return 0;
	}

	function flow(power)
	{
		return Utils.sign(noNoise(power))
	}

	/* some common helpers for overviews */
	function getAcSourceIcon(type)
	{
		if (type === undefined)
			return "";
		if (type === 240)
			return ""
		return acSourceIcon[type]
	}

	function getAcSourceName(type)
	{
		if (type === undefined)
			return qsTr("AC Input")
		if (type === 240)
			return qsTr("Island")
		return acSourceName[type]
	}

	function decimalTime(seconds, nada)
	{
		if (!seconds.valid)
			return nada
		if (seconds.value == 0)
			return "--"
		if (seconds.value > 86400)
			return (seconds.value/3600).toFixed(0) + "Hr"
		if (seconds.value >= 3600)
			return (seconds.value/3600).toFixed(1) + "Hr"
		if (seconds.value >= 60)
			return (seconds.value/60).toFixed(1) + "Min"
		return seconds.value.toFixed(0) + "Sec"
	}

	function scaleTo(value, cutoff, max, pixels) {
		return Math.floor(Math.min(value, cutoff, max) * pixels / max)
	}

}
