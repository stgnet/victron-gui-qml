import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root

	property string adcService: "dbus/com.victronenergy.adc"
	property string bindPrefix: "com.victronenergy.settings"

	title: "I/O"

	function disconnectedDeviceToast()
	{
		var text = qsTr("This sensor will remain visible on the devices list, " +
						"Use remove disconnected devices to remove it.")
		toast.createToast(text, 5000)
	}

	model: VisualItemModel {
		MbSubMenu {
			description: qsTr("Analog inputs")
			subpage: Component {
				MbPage {
					title: qsTr("Analog inputs")
					model: VeQItemTableModel {
						uids: [Utils.path(adcService, "/Devices")]
						flags: VeQItemTableModel.AddChildren |
							   VeQItemTableModel.AddNonLeaves |
							   VeQItemTableModel.DontAddItem
					}
					delegate: MbSwitch {
						property VBusItem label: VBusItem {
							bind: [model.uid, "/Label"]
						}
						name: label.value
						bind: [model.uid, "/Function"]
						onCheckedChanged: if (valid && !checked) disconnectedDeviceToast()
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
							onDisabled: disconnectedDeviceToast()
						}

						MbItemDigitalInput {
							description: qsTr("Digital input 2")
							bind: Utils.path(bindPrefix, "/Settings/DigitalInput/2/Type")
							onDisabled: disconnectedDeviceToast()
						}

						MbItemDigitalInput {
							description: qsTr("Digital input 3")
							bind: Utils.path(bindPrefix, "/Settings/DigitalInput/3/Type")
							onDisabled: disconnectedDeviceToast()
						}

						MbItemDigitalInput {
							description: qsTr("Digital input 4")
							bind: Utils.path(bindPrefix, "/Settings/DigitalInput/4/Type")
							onDisabled: disconnectedDeviceToast()
						}

						MbItemDigitalInput {
							description: qsTr("Digital input 5")
							bind: Utils.path(bindPrefix, "/Settings/DigitalInput/5/Type")
							onDisabled: disconnectedDeviceToast()
						}
					}
				}
			}
		}
	}
}
