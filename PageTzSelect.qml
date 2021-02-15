import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	id: pageTimeZone
	property string region: ""
	currentIndex: 1

	Component {
		id: cityItem

		MbItem {
			id: tzItem
			writeAccessLevel: User.AccessUser
			height: 53

			onClicked: {
				TimeZone.city = city
				// Go directly to the TzInfo page
				pageStack.pop(pageTzInfo)
			}

			Column {
				spacing: 3
				anchors {
					left: parent.left; leftMargin: style.marginDefault
					verticalCenter: tzItem.verticalCenter
				}

				MbTextDescription {
					isCurrentItem: tzItem.style.isCurrentItem
					text: qsTranslate("Tz" + pageTimeZone.title + "Data", name)
				}

				MbTextDescription {
					isCurrentItem: tzItem.style.isCurrentItem
					text: group
					font.pixelSize: 13
				}
			}

			MbTextValue {
				visible: city == TimeZone.city
				item.value: city == TimeZone.city ? "√" : ""
				anchors {
					right: parent.right; rightMargin: style.marginDefault + 5
					verticalCenter: parent.verticalCenter
				}

				MbGreyRect { height: parent.height + 6; width: parent.width + 10 }
			}
		}
	}

	delegate: cityItem

	Component.onCompleted: {
		TimeZone.region = region
	}
}
