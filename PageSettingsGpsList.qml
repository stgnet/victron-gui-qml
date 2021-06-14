import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root

	title: "GPS devices"
	model: VisualModels {
		VisualDataModel {
			model: VeQItemSortTableModel {
				dynamicSortFilter: true

				filterFlags: VeQItemSortTableModel.FilterOffline
				filterRole: VeQItemTableModel.IdRole
				filterRegExp: "^com\.victronenergy\.gps"

				model: VeQItemTableModel {
					uids: ["dbus"]
					flags: VeQItemTableModel.AddChildren |
						   VeQItemTableModel.AddNonLeaves |
						   VeQItemTableModel.DontAddItem
				}
			}

			MbSubMenu {
				id: menu

				property string uid: model.uid
				property VBusItem productName: VBusItem { bind: Utils.path(uid, "/ProductName") }
				property VBusItem vrmInstance: VBusItem { bind: Utils.path(uid, "/DeviceInstance") }

				description: productName.valid && vrmInstance.valid ? productName.value + " <span style='color: " + (isCurrentItem ? "white" : "gray") + "'>[" + vrmInstance.text + "]</span>" : "---"
				subpage: Component {
					PageGps {
						bindPrefix: menu.uid
						title: menu.description
					}
				}
			}
		}

		VisualItemModel {
			MbSubMenu {
				id: settings
				description: qsTr("GPS Settings")
				subpage: Component {
					PageSettingsGps {
						title: settings.description
					}
				}
			}
		}
	}
}
