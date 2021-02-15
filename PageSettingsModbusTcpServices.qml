import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	model: serviceCount.value
	title: "Modbus TCP services"

	VBusItem {
		id: serviceCount
		bind: "com.victronenergy.modbustcp/Services/Count"
	}

	delegate: Component {
		MbItem {
			property string servicePath: Utils.path("com.victronenergy.modbustcp/Services/", index)

			VBusItem {
				id: serviceName
				bind: Utils.path(servicePath, "/ServiceName")
			}

			VBusItem {
				id: productName
				bind: Utils.path(serviceName.value, "/ProductName")
			}

			VBusItem {
				id: unitId
				bind: Utils.path(servicePath, "/UnitId")
			}

			function shortServiceName(serviceName) {
				if (serviceName === undefined)
					return undefined
				return serviceName.split('.', 3).join('.')
			}

			function formatName(productName, serviceName) {
				if (productName !== undefined)
					return productName
				if (serviceName !== undefined)
					return shortServiceName(serviceName)
				return "--"
			}

			height: description.height + sn.height + 3 * style.marginDefault
			anchors.margins: style.marginDefault

			MbTextDescription {
				id: description
				text: formatName(productName.value, serviceName.value)
				anchors.top: parent.top
				anchors.left: parent.left
				anchors.margins: style.marginDefault
			}

			MbTextDescription {
				id: sn
				text: shortServiceName(serviceName.value)
				anchors.top: description.bottom
				anchors.left: parent.left
				anchors.margins: style.marginDefault
			}

			MbTextDescription {
				text: qsTr("Unit ID") + ": " + unitId.value
				anchors.top: description.bottom
				anchors.right: parent.right
				anchors.margins: style.marginDefault
			}
		}
	}
}
