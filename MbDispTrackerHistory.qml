import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbItem {
	id: root
	height: itemColumn.height + style.marginItemVertical

	property int day
	property string bindPrefix
	property int trackers

	function getBind(name)
	{
		return Utils.path(bindPrefix, "/", day, "/", name)
	}

	function getPvBind(tracker, name)
	{
		return Utils.path(bindPrefix, "/", day, "/Pv/", tracker, "/", name)
	}

	function getDayAsString(day)
	{
		if (day === 0)
			return qsTr("Today (Yield/P<sub>max</sub>/V<sub>max</sub>)")
		if (day === 1)
			return qsTr("Yesterday (Yield/P<sub>max</sub>/V<sub>max</sub>)")
		return qsTr("%1 days ago (Yield/P<sub>max</sub>/V<sub>max</sub>)").arg(day)
	}

	function formatTime(minutes)
	{
		if (minutes === undefined)
			return "--:--"

		return Math.floor(minutes / 60) + ":" + Utils.pad(minutes % 60, 2)
	}

	MbColumn {
		id: itemColumn
		spacing: 2

		MbTextDescription {
			x: style.marginItemHorizontal
			text: getDayAsString(day);
			font.pixelSize: 22
			isCurrentItem: root.style.isCurrentItem
		}

		Rectangle {
			id: line
			height: 1
			width: root.width;
			color: style.isCurrentItem ? "#fff" : "#000"
		}

		MbRowSmall {
			isCurrentItem: root.isCurrentItem
			description: qsTr("Total")

			MbTextBlock {
				item {
					bind: getBind("Yield")
					decimals: 2
					unit: "kWh"
				}
				height: 20; width: 106
			}

			MbTextBlock {
				item {
					bind: getBind("MaxPower")
					unit: "W"
				}
				height: 20; width: 106
			}

			MbTextBlock {
				id: maxPvVoltage
				item {
					bind: getBind("MaxPvVoltage")
					decimals: 2
					unit: "V"
				}
				height: 20; width: 106
			}
		}

		Repeater {
			model: trackers > 1 ? trackers : 0

			delegate: 	MbColumn {
				spacing: itemColumn.spacing

				MbRowSmall {
					isCurrentItem: root.isCurrentItem
					description: qsTr("Tracker %1").arg(index + 1)

					MbTextBlock {
						item {
							bind: getPvBind(index, "Yield")
							decimals: 2
							unit: "kWh"
						}
						height: 20; width: 106
					}

					MbTextBlock {
						item {
							bind: getPvBind(index, "MaxPower")
							unit: "W"
						}
						height: 20; width: 106
					}

					MbTextBlock {
						item {
							bind: getPvBind(index, "MaxVoltage")
							decimals: 2
							unit: "V"
						}
						height: 20; width: 106
					}
				}
			}
		}
	}
}
