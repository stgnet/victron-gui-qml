import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

OverviewPage {
	id: root

	property variant sys: theSystem
	property string settingsPrefix: "com.victronenergy.settings"
	property string systemPrefix: "com.victronenergy.system"
	property VBusItem _systemState: VBusItem { bind: Utils.path(systemPrefix, "/SystemState/State") }
	property bool hasSystemState: _systemState.valid

	title: qsTr("Tiles")

	Column {
		Row {
			height: 136

			Tile {
				width: 150
				height: parent.height
				title: qsTr("BATTERY")

				values: [
					TileText {
						text: sys.battery.soc.absFormat(0)
						font.pixelSize: 45
					},
					TileText {
						text: {
							if (!sys.battery.state.valid)
								return "---"
							switch(sys.battery.state.value) {
								case sys.batteryStateIdle: return qsTr("idle")
								case sys.batteryStateCharging : return qsTr("charging")
								case sys.batteryStateDischarging : return qsTr("discharging")
							}
						}
					},
					TileText {
						text: sys.battery.power.absFormat(0)
					},
					TileText {
						text: sys.battery.voltage.format(1) + "   " + sys.battery.current.format(1)
					}
				]
			}

			Tile {
				id: hubTile
				width: 180
				height: parent.height
				title: qsTr("SYSTEM")
				color: "#73c27d"
				VBusItem{
					id: systemName
					bind: Utils.path(settingsPrefix, "/Settings/SystemSetup/SystemName")
				}

				values: [
					TileText {
						text: systemName.valid && systemName.value !== "" ? systemName.value : sys.systemType.valid ? sys.systemType.value.toUpperCase() : ""
						font.pixelSize: text.length > 5 ? text.length > 16 ? 20 : 30 : 45
						wrapMode: Text.WordWrap
						width: systemTile.width
					},
					TileText {
						text: systemState.text
						font.pixelSize:  sys.systemType.valid ? 20 : 24

						SystemState {
							id: systemState
							bind: hasSystemState?Utils.path(systemPrefix, "/SystemState/State"):Utils.path(sys.vebusPrefix, "/State")
						}
					},
					TileText {
						text: systemReason.text
						font.pixelSize: 16
						SystemReason {
							id: systemReason
						}
					}
				]
			}

			Tile {
				id: stateTile

				property variant activeNotifications: NotificationCenter.notifications.filter(function isActive(obj) { return obj.active} )

				function notificationText()
				{
					if (activeNotifications.length === 0)
						return qsTr("no alarms")

					var descr = []
					for (var n = 0; n < activeNotifications.length; n++) {
						var notification = activeNotifications[n];

						var text = notification.serviceName + " - " + notification.description;
						if (notification.value !== "" )
							text += ":  " + notification.value

						descr.push(text)
					}

					return descr.join("  |  ")
				}

				width: 150
				height: parent.height
				title: qsTr("STATUS")
				color: "#4789d0"

				Timer {
					id: wallClock

					running: true
					repeat: true
					interval: 1000
					triggeredOnStart: true
					onTriggered: time = Qt.formatDateTime(new Date(), "hh:mm")

					property string time
				}

				values: [
					TileText {
						id: systemTile
						text: wallClock.time
						font.pixelSize: 45
					},
					Marquee {
						text: stateTile.notificationText()
						width: stateTile.width
						interval: 100
						fontSize: 13

					},
					MbIcon {
						iconId: "icon-statusbar-warning"
						anchors.horizontalCenter: parent.horizontalCenter;
						visible: stateTile.activeNotifications.length > 0

						TileText {
							id: totalAlarmsText
							text: stateTile.activeNotifications.length
							font.pixelSize: 13
							anchors.left: parent.right;
							anchors.bottom: parent.bottom; anchors.bottomMargin: -3
						}
					}
				]
			}
		}

		ListView {
			id: bottomRow
			height: 136
			width: 480
			orientation: ListView.Horizontal
			snapMode: ListView.SnapOneItem
			focus: root.active
			clip: true

			// Try to keep the selected index at the left. This fails when
			// there is not more data at the right to move..
			onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Beginning)

			model: VisualItemModel {

				TileAcPower {
					width: 160
					height: bottomRow.height
					title: qsTr("AC INPUT")
					color: "#82acde"
					connection: sys.acInput
				}

				TileAcPower {
					width: 160
					height: bottomRow.height
					title: qsTr("AC LOADS")
					color: "#e68e8a"
					connection: sys.acLoad
				}

				Tile {
					width: 160
					height: bottomRow.height
					title: qsTr("PV CHARGER")
					color: "#2cc36b"
					show: sys.pvCharger.power.valid

					values: [
						TileText {
							font.pixelSize: 30
							text: sys.pvCharger.power.uiText
						}
					]
				}

				TileAcPower {
					width: 160
					height: bottomRow.height
					title: qsTr("PV INVERTER")
					color: "#e74c3c"
					connection: sys.pvOnAcIn1
					show: connection.powerL1.valid
				}

				TileAcPower {
					width: 160
					height: bottomRow.height
					title: qsTr("PV INVERTER")
					color: "#e74c3c"
					connection: sys.pvOnAcIn2
					show: connection.powerL1.valid
				}

				TileAcPower {
					width: 160
					height: bottomRow.height
					title: qsTr("PV INVERTER")
					color: "#e74c3c"
					connection: sys.pvOnAcOut
					show: connection.powerL1.valid
				}

				Tile {
					width: 160
					height: bottomRow.height
					title: qsTr("DC SYSTEM")
					color: "#16a085"
					show: sys.dcSystem.power.valid && hasDcSys.value === 1

					VBusItem {
						id: hasDcSys
						bind: "com.victronenergy.settings/Settings/SystemSetup/HasDcSystem"
					}

					values: [
						TileText {
							font.pixelSize: 30
							text: sys.dcSystem.power.format(0)
						},
						TileText {
							text: !sys.dcSystem.power.valid ? "---" :
								  sys.dcSystem.power.value < 0 ? qsTr("to battery") : qsTr("from battery")
						}
					]
				}

				Rectangle {
					width: 160
					height: bottomRow.height
					color: "#538ed7"
					border.width: 2
					border.color: "#fff"

					MbIcon {
						iconId: "overview-victron-logo"
						anchors.centerIn: parent
					}
				}
			}
		}
	}
}
