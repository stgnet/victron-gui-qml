import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	property bool show: allowedRoles.valid
	property string bindPrefix
	property int productId

	property int em24ProductId: 0xb017
	property int smappeeProductId: 0xb018

	function getRoleName(r)
	{
		switch (r) {
		case "grid":
			return qsTr("Grid meter");
		case "pvinverter":
			return qsTr("PV inverter");
		case "genset":
			return qsTr("Generator");
		default:
			return '--';
		}
	}

	Component {
		id: mbOptionFactory
		MbOption {}
	}

	function getRoleList(roles)
	{
		if (!roles)
			return [];

		var options = [];
		for (var i = 0; i < roles.length; i++) {
			var params = {
				"description": getRoleName(roles[i]),
				"value": roles[i],
			}
			options.push(mbOptionFactory.createObject(root, params));
		}

		return options;
	}

	/*
	 * This is a bit weird, when changing the role in a cgwacs service, it will
	 * directly disconnect, without a reply or signal that the value changed. So
	 * the gui blindly trust the remote for now to change its servicename and
	 * wait for it, which can take up to some seconds. It is not reacting in
	 * the meantime, but also not stuck. Eventually it ends up finding the new
	 * service, but it would not hurt to find a better way to do this.
	 */
	function updateServiceName(role)
	{
		var s = bindPrefix.split('.');

		if (s[2] === role)
			return;

		s[2] = role;
		bindPrefix = s.join('.');
	}

	function em24Locked()
	{
		return em24SwitchPos.item.valid && em24SwitchPos.item.value == 3;
	}

	function em24SwitchText(pos)
	{
		switch (pos) {
		case 0: return qsTr("Unlocked (kVARh)");
		case 1: return qsTr("Unlocked (2)");
		case 2: return qsTr("Unlocked (1)");
		case 3: return qsTr("Locked");
		}
		return qsTr("Unknown");
	}

	VBusItem {
		id: allowedRoles
		bind: Utils.path(root.bindPrefix, "/AllowedRoles")
		onValueChanged: role.possibleValues = getRoleList(value)
	}

	model: VisualItemModel {
		MbItemOptions {
			id: role
			description: qsTr("Role")
			bind: Utils.path(root.bindPrefix, "/Role")
			onOptionSelected: updateServiceName(newValue)
		}

		MbItemOptions {
			description: qsTr("Position")
			bind: Utils.path(root.bindPrefix, "/Position")
			show: role.value === "pvinverter"
			possibleValues: [
				MbOption { description: qsTr("AC Input 1"); value: 0 },
				MbOption { description: qsTr("AC Input 2"); value: 2 },
				MbOption { description: qsTr("AC Output"); value: 1 }
			]
		}

		/* EM24 settings */

		MbItemOptions {
			description: qsTr("Phase configuration")
			show: productId == em24ProductId
			bind: Utils.path(root.bindPrefix, "/PhaseConfig")
			readonly: em24Locked()
			possibleValues: [
				MbOption { description: "3P.n"; value: 0 },
				MbOption { description: "3P.1"; value: 1 },
				MbOption { description: "2P";   value: 2 },
				MbOption { description: "1P";   value: 3 },
				MbOption { description: "3P";   value: 4 }
			]
		}

		MbItemValue {
			id: em24SwitchPos
			description: qsTr("Switch position")
			show: productId == em24ProductId
			item.bind: Utils.path(root.bindPrefix, "/SwitchPos")
			item.text: item.valid ? em24SwitchText(item.value) : "--"
		}

		MbItemText {
			text: qsTr("Set switch in an unlocked position to change settings")
			show: productId == em24ProductId && em24Locked()
		}

		/* Smappee settings */

		MbItemOptions {
			description: qsTr("Phase configuration")
			show: productId == smappeeProductId
			bind: Utils.path(root.bindPrefix, "/PhaseConfig")
			possibleValues: [
				MbOption { description: qsTr("Single phase"); value: 0 },
				MbOption { description: qsTr("2-phase"); value: 2 },
				MbOption { description: qsTr("3-phase"); value: 1 }
			]
		}

		MbSubMenu {
			description: qsTr("Current transformers")
			show: productId == smappeeProductId
			subpage: Component {
				PageSmappeeCTList {
					bindPrefix: root.bindPrefix
				}
			}
		}

		MbSubMenu {
			description: qsTr("Devices")
			show: productId == smappeeProductId
			subpage: Component {
				PageSmappeeDeviceList {
					bindPrefix: root.bindPrefix
				}
			}
		}
	}
}
