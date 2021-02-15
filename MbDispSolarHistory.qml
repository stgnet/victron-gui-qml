import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbItem {
	id: root
	//height: Math.max(listview.height / (fullHistory ? 1 : 2), itemColumn.height)
	height: itemColumn.height + style.marginItemVertical

	property int day
	property string bindPrefix
	property bool fullHistory

	function getBind(name)
	{
		return Utils.path(bindPrefix, "/", day, "/", name)
	}

	function getDayAsString(day)
	{
		if (day === 0)
			return qsTr("Today")
		if (day === 1)
			return qsTr("Yesterday")
		return qsTr("%1 days ago").arg(day)
	}

	function formatTime(minutes)
	{
		if (minutes === undefined)
			return "--:--"

		return Math.floor(minutes / 60) + ":" + Utils.pad(minutes % 60, 2)
	}

	MbColumn {
		id: itemColumn
		spacing: fullHistory ? 2 : 3

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
			description: qsTr("Yield") + (consumption.visible ? qsTr("/consumption") : "")

			MbTextBlock {
				item {
					bind: getBind("Yield")
					decimals: 2
					unit: "kWh"
				}
				height: 20; width: 106
			}

			MbTextBlock {
				id: consumption
				item {
					bind: getBind("Consumption")
					decimals: 2
					unit: "kWh"
				}
				height: 20; width: 106; visible: item.valid
			}
		}

		MbRowSmall {
			isCurrentItem: root.isCurrentItem
			description: maxPvVoltage.visible ? qsTr("PV (P<sub>max</sub>/V<sub>max</sub>)") : qsTr("PV P<sub>max</sub>")

			MbTextBlock {
				item {
					bind: getBind("MaxPower")
					unit: "W"
				}
				height: 20; width: 106
			}

			MbTextBlock {
				id: maxPvVoltage
				visible: fullHistory
				item {
					bind: getBind("MaxPvVoltage")
					decimals: 2
					unit: "V"
				}
				height: 20; width: 106
			}
		}

		MbRowSmall {
			isCurrentItem: root.isCurrentItem
			description: qsTr("Battery (V<sub>min</sub>/V<sub>max</sub>/I<sub>max</sub>)")
			visible: fullHistory

			MbTextBlock {
				item {
					bind: getBind("MinBatteryVoltage")
					decimals: 2
					unit: "V"
				}
				height: 20; width: 70
			}

			MbTextBlock {
				item {
					bind: getBind("MaxBatteryVoltage")
					decimals: 2
					unit: "V"
				}
				height: 20; width: 70
			}

			MbTextBlock {
				item {
					bind: getBind("MaxBatteryCurrent")
					decimals: 1
					unit: "A"
				}
				height: 20; width: 70
			}
		}

		MbRowSmall {
			isCurrentItem: root.isCurrentItem
			visible: fullHistory
			description: qsTr("Charge time (Bulk/Abs/Float)")

			MbTextBlock {
				item {
					bind: getBind("TimeInBulk")
					text: formatTime(item.value)
				}
				height: 20; width: 70
			}

			MbTextBlock {
				item {
					bind: getBind("TimeInAbsorption")
					text: formatTime(item.value)
				}
				height: 20; width: 70
			}

			MbTextBlock {
				item {
					bind: getBind("TimeInFloat")
					text: formatTime(item.value)
				}
				height: 20; width: 70
			}
		}

		Repeater {
			id: errorRepeater
			model: fullHistory ? numberOfErrors : 0

			// mmm
			property list<VBusItem> errors: [
					VBusItem { bind: getBind("LastError1") },
					VBusItem { bind: getBind("LastError2") },
					VBusItem { bind: getBind("LastError3") },
					VBusItem { bind: getBind("LastError4") }
			]
			property int numberOfErrors: errors[3].value > 0 ? 4 :
										errors[2].value > 0 ? 3 :
										errors[1].value > 0 ? 2 :
										errors[0].value > 0 ? 1 :
										1 // show a single "no error"

			property ChargerError formatter: ChargerError {}
			property variant labels: [
				qsTr("Last error"),
				qsTr("2nd last error"),
				qsTr("3rd last error"),
				qsTr("4th last error")
			]

			delegate: MbRowSmall {
				isCurrentItem: root.isCurrentItem
				description: errorRepeater.labels[index]
				MbBlock {
					height: 20
					MbTextValue {
						width: 270
						horizontalAlignment: Text.AlignLeft
						clip: true
						item {
							bind: getBind("LastError") + (index + 1)
							text: item.valid ? errorRepeater.formatter.description(item.value) : item.invalidText
						}
					}
				}
			}
		}
	}
}
