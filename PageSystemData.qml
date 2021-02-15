import QtQuick 1.1

MbPage {
	id: root

	HubData {
		id: data
	}

	model: VisualItemModel {
		MbItemRow {
			description: qsTr("PV On ACIn1")
			values: MbRow {
				MbTextValue { text: data.pvOnAcIn1.power.uiText }
				MbTextValue { text: data.pvOnAcIn1.powerL1.uiText }
				MbTextValue { text: data.pvOnAcIn1.powerL2.uiText }
				MbTextValue { text: data.pvOnAcIn1.powerL3.uiText }
			}
		}

		MbItemRow {
			description: qsTr("PV On ACIn2")
			values: MbRow {
				MbTextValue { text: data.pvOnAcIn2.power.uiText }
				MbTextValue { text: data.pvOnAcIn2.powerL1.uiText }
				MbTextValue { text: data.pvOnAcIn2.powerL2.uiText }
				MbTextValue { text: data.pvOnAcIn2.powerL3.uiText }
			}
		}

		MbItemRow {
			description: qsTr("PV On AC Out")
			values: MbRow {
				MbTextValue { text: data.pvOnAcOut.power.uiText }
				MbTextValue { text: data.pvOnAcOut.powerL1.uiText }
				MbTextValue { text: data.pvOnAcOut.powerL2.uiText }
				MbTextValue { text: data.pvOnAcOut.powerL3.uiText }
			}
		}

		MbItemRow {
			description: qsTr("VE.Bus AC out")
			values: MbRow {
				MbTextValue { text: data.vebusAcOut.power.uiText }
				MbTextValue { text: data.vebusAcOut.powerL1.uiText }
				MbTextValue { text: data.vebusAcOut.powerL2.uiText }
				MbTextValue { text: data.vebusAcOut.powerL3.uiText }
			}
		}

		MbItemRow {
			description: qsTr("AC loads")
			values: MbRow {
				MbTextValue { text: data.acLoad.power.format(0) }
				MbTextValue { text: data.acLoad.powerL1.format(0) }
				MbTextValue { text: data.acLoad.powerL2.format(0) }
				MbTextValue { text: data.acLoad.powerL3.format(0) }
			}
		}

		MbItemRow {
			description: qsTr("Battery")
			values: MbRow {
				MbTextValue { text: data.battery.power.uiText }
				MbTextValue { text: data.battery.voltage.uiText }
				MbTextValue { text: data.battery.current.uiText }
			}
		}

		MbItemRow {
			description: qsTr("PV Charger")
			values: MbRow {
				MbTextValue { text: data.pvCharger.power.uiText }
			}
		}
	}
}
