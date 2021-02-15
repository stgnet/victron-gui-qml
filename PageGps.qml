import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	title: "GPS"
	property string bindPrefix

	property VBusItem connected: VBusItem {	bind: Utils.path(bindPrefix, "/Connected") }
	property VBusItem fix: VBusItem { bind: Utils.path(bindPrefix, "/Fix") }
	property VBusItem longitude: VBusItem { bind: Utils.path(bindPrefix, "/Position/Longitude") }
	property VBusItem latitude: VBusItem { bind: Utils.path(bindPrefix, "/Position/Latitude") }

	property VBusItem format: VBusItem { bind: "com.victronenergy.settings/Settings/Gps/Format" }
	property VBusItem speedUnit: VBusItem { bind: "com.victronenergy.settings/Settings/Gps/SpeedUnit" }

	model: VisualItemModel {

		MbItemValue {
			description: qsTr("Status")
			item.text: getStatus()

			function getStatus()
			{
				if (connected.valid && connected.value) {
					if (fix.valid && fix.value)
						return qsTr("GPS OK (fix)");
					return qsTr("GPS connected, but no GPS fix");
				}
				return qsTr("No GPS connected");
			}
		}

		MbItemValue {
			description: qsTr("Latitude")
			item.text: latitude.valid ? formatCoord(latitude.value, ["N","S"], format.value) : latitude.text
		}

		MbItemValue {
			description: qsTr("Longitude")
			item.text: longitude.valid ? formatCoord(longitude.value, ["E","W"], format.value) : longitude.text
		}

		MbItemValue {
			VBusItem {
				id: speed
				bind: Utils.path(bindPrefix, "/Speed")
			}
			description: qsTr("Speed")
			item.text: speed.valid ? getValue() : speed.text

			function getValue()
			{
				if (speedUnit.value === "km/h")
					return (speed.value * 3.6).toFixed(1) + speedUnit.value
				if (speedUnit.value === "mph")
					return (speed.value * 2.236936).toFixed(1) + speedUnit.value
				if (speedUnit.value === "kt")
					return (speed.value * (3600/1852)).toFixed(1) + speedUnit.value
				return speed.value.toFixed(2) + "m/s"
			}
		}

		MbItemValue {
			VBusItem {
				id: course
				bind: Utils.path(bindPrefix, "/Course")
			}
			description: qsTr("Course")
			item.text: course.valid ? course.value.toFixed(1) + "°" : course.text
		}

		MbItemValue {
			description: qsTr("Altitude")
			item.bind: Utils.path(bindPrefix, "/Altitude")
		}

		MbItemValue {
			description: qsTr("Number of satellites")
			item.bind: Utils.path(bindPrefix, "/NrOfSatellites")
		}

		MbSubMenu {
			id: deviceItem
			description: qsTr("Device")
			subpage: Component {
				PageDeviceInfo {
					title: deviceItem.description
					bindPrefix: root.bindPrefix
				}
			}
		}
	}

	function formatCoord(val, dir, fmt)
	{
		var degrees = Math.abs(val)
		var minutes = (degrees % 1) * 60.0
		var seconds = (minutes % 1) * 60.0
		var direction = val >= 0 ? dir[0] : dir[1]

		switch (fmt)
		{
		/* DDD.DDDDDD */
		case 1:
			return val.toFixed(6)
		/* DDD:MM.MMMM[NESW] */
		case 2:
			return Math.floor(degrees).toFixed() + "° " +
					minutes.toFixed(4) + " " + direction
		/* DDD°MM'SS"[NESW] */
		default:
			return Math.floor(degrees).toFixed() + "° " +
					Math.floor(minutes).toFixed() + "' " +
					seconds.toFixed(1) + "\" " + direction
		}
	}
}
