import QtQuick 1.1

MbPage {
	id: root
	title: qsTr("Wireless AC sensors")
	model: Qwacs.sensors

	delegate: MbSubMenu {
		id: sensor
		property string sensorId: Qwacs.sensors[index]
		property string sensorPosition: Qwacs.getPosition(sensorId)

		description: sensorId
		item.value: sensorPosition
		subpage: { sensorId === "Gateway" ? gateway : postionSelect }

		Connections {
			target: Qwacs
			onPositionChanged: { sensorPosition = Qwacs.getPosition(sensorId) }
		}

		Component {
			id: postionSelect
			PageSettingsQwacsPositionsSelect {
				title: sensorPosition
				sensorId: sensor.sensorId
				model: sensorPostions

				Component.onCompleted: {
					for (var i = 0; i < sensorPostions.count; i++) {
						if (sensorPostions.get(i).position === sensorPosition) {
							currentIndex = i
							listview.positionViewAtIndex(i, ListView.Visible)
							break;
						}
					}
				}
			}
		}

		Component {
			id: gateway
			PageSettingsQwacsGateway {
				title: qsTr("Gateway")
			}
		}

		ListModel {
			id: sensorPostions
			ListElement {
				description : QT_TR_NOOP("Not connected")
				position: ""
			}
			ListElement {
				description: QT_TR_NOOP("AC-In1 L1")
				position: QT_TR_NOOP("ACIn1_L1")
			}
			ListElement {
				description: QT_TR_NOOP("AC-In1 L2")
				position: QT_TR_NOOP("ACIn1_L2")
			}
			ListElement {
				description: QT_TR_NOOP("AC-In1 L3")
				position: QT_TR_NOOP("ACIn1_L3")
			}
			ListElement {
				description: QT_TR_NOOP("AC-In2 L1")
				position: QT_TR_NOOP("ACIn2_L1")
			}
			ListElement {
				description: QT_TR_NOOP("AC-In2 L2")
				position: QT_TR_NOOP("ACIn2_L2")
			}
			ListElement {
				description: QT_TR_NOOP("AC-In2 L3")
				position: QT_TR_NOOP("ACIn2_L3")
			}
			ListElement {
				description: QT_TR_NOOP("AC-Out L1")
				position: QT_TR_NOOP("ACOut_L1")
			}
			ListElement {
				description: QT_TR_NOOP("AC-Out L2")
				position: QT_TR_NOOP("ACOut_L2")
			}
			ListElement {
				description: QT_TR_NOOP("AC-Out L3")
				position: QT_TR_NOOP("ACOut_L3")
			}
		}
	}

	MbItemText {
		visible: Qwacs.sensors.length === 0
		text: qsTr("No gateway")
		style: MbStyle {
			isCurrentItem: true
		}
	}
}
