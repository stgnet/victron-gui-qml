import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root

	property string bindPrefix: "com.victronenergy.settings"

	title: "I/O"

	function rebootToRemoveToast()
	{
		var text = qsTr("This sensor will remain visible on the devices list, " +
						"reboot to remove it.")
		toast.createToast(text, 5000)
	}

	model: VisualItemModel {
		MbSubMenu {
			description: qsTr("Analog inputs")
			subpage: Component {
				MbPage {
					title: qsTr("Analog inputs")
					model: VisualItemModel {
						MbSwitch {
							name: qsTr("Tank level sensor 1")
							bind: Utils.path(bindPrefix, "/Settings/AnalogInput/Resistive/1/Function2")
							show: valid
							onCheckedChanged: if (valid && !checked) rebootToRemoveToast()
						}

						MbSwitch {
							name: qsTr("Tank level sensor 2")
							bind: Utils.path(bindPrefix, "/Settings/AnalogInput/Resistive/2/Function2")
							show: valid
							onCheckedChanged: if (valid && !checked) rebootToRemoveToast()
						}

						MbSwitch {
							name: qsTr("Tank level sensor 3")
							bind: Utils.path(bindPrefix, "/Settings/AnalogInput/Resistive/3/Function2")
							show: valid
							onCheckedChanged: if (valid && !checked) rebootToRemoveToast()
						}

						MbSwitch {
							name: qsTr("Tank level sensor 4")
							bind: Utils.path(bindPrefix, "/Settings/AnalogInput/Resistive/4/Function2")
							show: valid
							onCheckedChanged: if (valid && !checked) rebootToRemoveToast()
						}

						MbSwitch {
							name: qsTr("Temperature sensor 1")
							bind: Utils.path(bindPrefix, "/Settings/AnalogInput/Temperature/1/Function2")
							show: valid
							onCheckedChanged: if (valid && !checked) rebootToRemoveToast()
						}

						MbSwitch {
							name: qsTr("Temperature sensor 2")
							bind: Utils.path(bindPrefix, "/Settings/AnalogInput/Temperature/2/Function2")
							show: valid
							onCheckedChanged: if (valid && !checked) rebootToRemoveToast()
						}

						MbSwitch {
							name: qsTr("Temperature sensor 3")
							bind: Utils.path(bindPrefix, "/Settings/AnalogInput/Temperature/3/Function2")
							show: valid
							onCheckedChanged: if (valid && !checked) rebootToRemoveToast()
						}

						MbSwitch {
							name: qsTr("Temperature sensor 4")
							bind: Utils.path(bindPrefix, "/Settings/AnalogInput/Temperature/4/Function2")
							show: valid
							onCheckedChanged: if (valid && !checked) rebootToRemoveToast()
						}
					}
				}
			}
		}

		MbSubMenu {
			description: qsTr("Digital inputs")
			subpage: Component {
				MbPage {
					id: digitalInputsPage
					title: qsTr("Digital inputs")
					model: VisualItemModel {
						MbItemDigitalInput {
							description: qsTr("Digital input 1")
							bind: Utils.path(bindPrefix, "/Settings/DigitalInput/1/Type")
							onDisabled: rebootToRemoveToast()
						}

						MbItemDigitalInput {
							description: qsTr("Digital input 2")
							bind: Utils.path(bindPrefix, "/Settings/DigitalInput/2/Type")
							onDisabled: rebootToRemoveToast()
						}

						MbItemDigitalInput {
							description: qsTr("Digital input 3")
							bind: Utils.path(bindPrefix, "/Settings/DigitalInput/3/Type")
							onDisabled: rebootToRemoveToast()
						}

						MbItemDigitalInput {
							description: qsTr("Digital input 4")
							bind: Utils.path(bindPrefix, "/Settings/DigitalInput/4/Type")
							onDisabled: rebootToRemoveToast()
						}

						MbItemDigitalInput {
							description: qsTr("Digital input 5")
							bind: Utils.path(bindPrefix, "/Settings/DigitalInput/5/Type")
							onDisabled: rebootToRemoveToast()
						}
					}
				}
			}
		}
	}
}
