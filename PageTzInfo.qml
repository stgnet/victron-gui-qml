import QtQuick 1.1
import com.victron.velib 1.0

// Page showing the current Date Time selection
MbPage {
	id: pageTzInfo

	model: VisualItemModel {

		MbItemValue {
			id: dateUTC
			description: qsTr("Date/Time UTC")

			Timer {
				interval: 1000
				running: parent.visible
				repeat: true
				triggeredOnStart: true
				onTriggered: dateUTC.item.value = vePlatform.getUTCDateTime()
			}
		}

		MbEditBoxDateTime {
			id: dateLocal
			description: qsTr("Date/Time local")
			writeAccessLevel: User.AccessUser
			onEditDone: vePlatform.setSystemTime(item.value)

			Timer {
				interval: 1000
				running: !dateLocal.editMode
				repeat: true
				triggeredOnStart: true
				onTriggered: dateLocal.item.value = new Date().getTime() / 1000
			}
		}

		MbSubMenu {
			id: tzItem
			description: qsTr("Time zone")
			item.value: getTimeZoneLabel()
			subpage: Component {
				PageTzMenu {
					title: qsTr("Regions")
				}
			}
			iconId: ""
			writeAccessLevel: User.AccessUser
			cornerMark: true

			function getTimeZoneLabel()
			{
				if (TimeZone.city === "UTC")
					return TimeZone.city

				var component = Qt.createComponent("Tz" + TimeZone.region + "Data.qml");
				var tzData = component.createObject(tzItem)
				for (var i = 0; i < tzData.count; i++) {
					if (tzData.get(i).city === TimeZone.city)
							return tzData.get(i).name
				}
			}
		}
	}
}
