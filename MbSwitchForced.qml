import QtQuick 1.1
import com.victron.velib 1.0

MbSwitchText {
	property variant valueForcedFalse: 2
	property variant valueForcedTrue: 3
	property bool forced: item.valid && (item.value === valueForcedFalse || item.value === valueForcedTrue)

	checked: item.valid && (item.value === valueTrue ||item.value === valueForcedTrue)
	enabled: item.valid && userHasWriteAccess && !forced
	onText: item.valid && forced && checked ? qsTr("Forced on") : ""
	offText: item.valid && forced && !checked ? qsTr("Forced off") : ""

	function onEditAttemptWhenDisabled() {
		if (forced)
			toast.createToast(qsTr("The setting is forced and cannot be changed"), 3000, "icon-lock-active");
	}
}
