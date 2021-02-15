import QtQuick 1.1

MbPage {
	Rectangle {
		anchors.fill: parent
		color: "white"

		Rectangle {
			id: one
			x: 50
			y: 30
			width: 20
			height: 50
			color: "blue"
		}

		Rectangle {
			id: two
			x: 400
			y: 140
			width: 50
			height: 50
			color: "red"
		}

		OverviewConnection {
			ballCount: 5
			path: corner
			active: true

			anchors {
				left: one.right; top: one.verticalCenter
				right: two.right; bottom: two.verticalCenter
			}

			// prevent: QDeclarativeComponent: Cannot create new component
			// instance before completing the previous
			Component.onCompleted: value = -1
		}

		OverviewConnection {
			ballCount: 5
			path: corner
			active: true

			anchors {
				left: two.left; top: two.verticalCenter
				right: one.left; bottom: one.verticalCenter
			}

			// prevent: QDeclarativeComponent: Cannot create new component
			// instance before completing the previous
			Component.onCompleted: value = -1
		}
	}
}
