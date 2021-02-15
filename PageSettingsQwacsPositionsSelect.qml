import QtQuick 1.1

MbPage {
	id: pagePositions
	property string sensorId: ""

	Component {
		id: positionItem
		//property string name: description

		MbOK {
			description: model.description
			value: position === Qwacs.getPosition(sensorId) ? "√" : ""
			onClicked: {
				Qwacs.setPosition(sensorId, position)
				pageStack.pop()
			}
		}
	}

	delegate: positionItem

	Component.onCompleted: {
		Qwacs.blinkOn(sensorId)
	}

	Component.onDestruction:  {
		Qwacs.blinkOff(sensorId)
	}
}
