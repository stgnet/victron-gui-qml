import QtQuick 1.1

Tile {
	id: root

	property variant connection

	values: OverviewAcValues {
		connection: root.connection
	}
}
