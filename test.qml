import QtQuick 1.1

import Qt.labs.components.native 1.0
import com.victron.velib 1.0

PageStackWindow {
	id: rootWindow

	initialPage: PageTest {}

	Toast {
		id: toast
		transform: Scale {
			xScale: screen.width / 480
			yScale: screen.height / 272
			origin.x: toast.width / 2
		}
	}

	function backToMainMenu() {
		pageStack.pop(initialPage);
	}

	// stolen from main.qml
	ToolBarLayout {
		id: mbTools
		height: parent.height

		Item {
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: mbTools.left
			height: mbTools.height
			width: 200

			MouseArea {
				anchors.fill: parent
				onClicked: {
					if (pageStack.currentPage && pageStack.currentPage.toolbarHandler)
						pageStack.currentPage.toolbarHandler.leftAction()
					// in main.qml we showOverview here - but there is no overview in test app.
				}
			}

			Row {
				anchors.centerIn: parent

				MbIcon {
					anchors.verticalCenter: parent.verticalCenter
					iconId: pageStack.currentPage ? pageStack.currentPage.leftIcon : ""
				}

				Text {
					anchors.verticalCenter: parent.verticalCenter
					text: pageStack.currentPage ? pageStack.currentPage.leftText : ""
					color: "white"
					font.bold: true
					font.pixelSize: 16
				}
			}
		}

		MbIcon {
			id: centerScrollIndicator

			anchors {
				horizontalCenter: parent.horizontalCenter
				verticalCenter: mbTools.verticalCenter
			}
			iconId: pageStack.currentPage ? pageStack.currentPage.scrollIndicator : ""
		}

		Item {
			anchors.verticalCenter: parent.verticalCenter
			height: mbTools.height
			anchors.right: mbTools.right
			width: 200

			MouseArea {
				anchors.fill: parent
				onClicked: {
					if (pageStack.currentPage && pageStack.currentPage.toolbarHandler)
						pageStack.currentPage.toolbarHandler.rightAction()
					else
						backToMainMenu()
				}
			}

			Row {
				anchors.centerIn: parent

				MbIcon {
					iconId: pageStack.currentPage ? pageStack.currentPage.rightIcon : ""
					anchors.verticalCenter: parent.verticalCenter
				}

				Text {
					text: pageStack.currentPage ? pageStack.currentPage.rightText : ""
					anchors.verticalCenter: parent.verticalCenter
					color: "white"
					font.bold: true
					font.pixelSize: 16
				}
			}
		}
	}

	Timer {
		id: mover
		property double pos: _counter / _loops
		property int _counter: 7
		property int _loops: 13

		interval: 100
		running: true
		repeat: true
		onTriggered: if (_counter >= (_loops - 1)) _counter = 0; else _counter++
	}
}
