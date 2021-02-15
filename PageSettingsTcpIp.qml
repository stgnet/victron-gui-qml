import QtQuick 1.1
import Qt.labs.components.native 1.0
import net.connman 0.1
import com.victron.velib 1.0

MbPage {
	id: root
	title: qsTr("Ethernet")
	property string technologyType: "ethernet"
	property string path: Connman.getServiceList(technologyType)[0] ? Connman.getServiceList(technologyType)[0] : ""
	property CmService service: Connman.getService(path)
	property string security: service ? service.security.toString() : ""
	property bool secured: security.indexOf("none") === -1 && security !== ""
	property string serviceMethod: service && service.ipv4Config["Method"] ? service.ipv4Config["Method"] : "--"
	property bool readonlySettings: serviceMethod !== "manual"
	property bool wifi: technologyType === "wifi"
	property string agentPath: "/com/victronenergy/ccgx"
	property CmAgent agent;
	property alias showLinkLocal: linklocal.show

	Connections {
		target: Connman
		onServiceRemoved: {
			if ( path == root.path && root.visible )
				root.model = unplugged
		}
		onServiceAdded: {
			root.path = Connman.getServiceList(technologyType)[0]
			if ( path == root.path && root.visible && !service) {
				service = Connman.getService(path)
				root.model = serviceItems
			}
		}
	}

	FnCmStates {
		id: cmState
	}

	model: service ?  serviceItems : unplugged
	VisualItemModel {
		id: unplugged

		MbItemValue {
			description: qsTr("State")
			item.value: wifi ? qsTr("Connection lost") : qsTr("Unplugged")
		}
	}

	VisualItemModel {
		id: serviceItems

		MbItemValue {
			description: qsTr("State")
			item.value: service ? cmState.getState(service.state, wifi) : undefined
		}

		MbItemValue {
			description: qsTr("Name")
			item.value: service ? service.name : undefined
			show: wifi
		}

		MbEditBox {
			id: passwordInput
			description: qsTr("Password")
			maximumLength: 35
			onEditDone: {
				sendPassword(newValue)
				listview.currentIndex = 1;
			}
			show: (wifi && (service.state === "idle" || service.state === "failure") && !service.favorite && secured)
			writeAccessLevel: User.AccessUser
		}

		MbOK {
			id: connect
			description: qsTr("Connect to network?")
			onClicked: {
				service.connect();
				listview.currentIndex = 1;
			}
			show: (wifi && (service.state === "idle" || service.state === "failure") && (service.favorite || !secured))
			writeAccessLevel: User.AccessUser
		}

		MbOK {
			id: forget
			description: qsTr("Forget network?")
			onClicked: {
				service.remove();
				listview.currentIndex = 1;
			}
			show: wifi && service.favorite
			writeAccessLevel: User.AccessUser
		}

		MbItemValue {
			description: qsTr("Signal strength")
			item.value: service ? service.strength + " %" : undefined
			show: wifi
		}

		MbItemValue {
			description: qsTr("MAC address")
			item.value: service ? service.ethernet["Address"] : undefined
		}

		MbItemOptions {
			id: method
			description: qsTr("IP configuration")
			localValue: serviceMethod
			writeAccessLevel: User.AccessUser
			possibleValues: [
				MbOption{description: qsTr("Automatic"); value: "dhcp"},
				MbOption{description: qsTr("Manual"); value: "manual"},
				MbOption{description: qsTr("Off"); value: "off"; readonly: true},
				MbOption{description: qsTr("Fixed"); value: "fixed"; readonly: true}
			]
			onOptionSelected: {
				setMethod(value)
			}
		}

		MbEditBoxIp {
			id: ipaddress
			description: qsTr("IP address")
			readonly: readonlySettings || !method.userHasWriteAccess
			item.value: service ? service.ipv4["Address"] : undefined
			onEditDone: setIpv4Property("Address", newValue)
		}

		MbEditBoxIp {
			id: netmask
			description: qsTr("Netmask")
			readonly: readonlySettings || !method.userHasWriteAccess
			item.value: service ? service.ipv4["Netmask"] : undefined
			onEditDone: setIpv4Property("Netmask", newValue)
		}

		MbEditBoxIp {
			id: gateway
			description: qsTr("Gateway")
			readonly: readonlySettings || !method.userHasWriteAccess
			item.value: service ? service.ipv4["Gateway"] : undefined
			onEditDone: setIpv4Property("Gateway", newValue)
		}

		MbEditBoxIp {
			id: nameserver
			description: qsTr("DNS server")
			readonly: readonlySettings || !method.userHasWriteAccess
			item.value: service ? service.nameservers[0] : undefined
			onEditDone: service.nameserversConfig = newValue
		}

		MbEditBoxIp {
			id: linklocal
			show: false
			description: qsTr("Link-local IP address")
			readonly: true
			item.value: vePlatform.linkLocalAddr
		}
	}

	Component.onCompleted: {
		if (wifi)
			agent = Connman.registerAgent(agentPath)
	}

	Component.onDestruction: {
		if (wifi)
			Connman.unRegisterAgent(agentPath)
	}

	function sendPassword(password) {
		if (wifi) {
			agent.passphrase = password
			service.connect()
		}
	}

	function setIpv4Property(name, value) {
		var ipv4Config = service.ipv4
		ipv4Config[name] = value
		service.ipv4Config = ipv4Config
	}

	function setMethod(selectedMethod) {
		if (!service)
			return

		var ipv4Config = service.ipv4
		var nameserversConfig = service.nameservers
		var oldMethod = ipv4Config["Method"]

		switch (selectedMethod) {
		case "dhcp":
			if (oldMethod === "manual") {
				ipv4Config['Address'] = "255.255.255.255"
				service.ipv4Config = ipv4Config
			}
			ipv4Config["Method"] = "dhcp"
			nameserversConfig = []
			break
		case "manual":
			ipv4Config["Method"] = "manual"
			var addr = service.checkIpAddress(ipv4Config["Address"])
			/*
			 * Make sure the ip settings are valid when switching to "manual"
			 * When the ip settings are not valid, connman will continuously disconnect
			 * and reconnect the service and it is impossible to set the ip-address.
			 */
			if (!addr) {
				ipv4Config["Address"] = "169.254.1.2"
				ipv4Config["Netmask"] = "255.255.255.0"
				ipv4Config["Gateway"] = "169.254.1.1"
			}
			break
		}
		if (ipv4Config["Method"] !== oldMethod) {
			service.ipv4Config = ipv4Config
			service.nameserversConfig = nameserversConfig
		}
	}
}
