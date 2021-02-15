import QtQuick 1.1
import com.victron.velib 1.0


MbPage {
	id: root

	model: VisualItemModel {
		MbOK {
			description: qsTr("UTC")
			writeAccessLevel: User.AccessUser
			value: TimeZone.city == "UTC" ? "√" : ""
			onClicked: {
				TimeZone.region = ""
				TimeZone.city = "UTC"
				pageStack.pop()
			}
		}

		MbSubMenu {
			id: africa
			description: qsTr("Africa")
			subpage: Component {
				PageTzSelect {
					title: africa.description
					model: TzAfricaData {}
					region: "Africa"
				}
			}
		}

		MbSubMenu {
			id: america
			description: qsTr("America")
			subpage: Component {
				PageTzSelect {
					title: america.description
					model: TzAmericaData {}
					region: "America"
				}
			}
		}

		MbSubMenu {
			id: antarctica
			description: qsTr("Antarctica")
			subpage: Component {
				PageTzSelect {
					title: antarctica.description
					model: TzAntarcticaData {}
					region: "Antarctica"
				}
			}
		}

		MbSubMenu {
			id: arctic
			description: qsTr("Arctic")
			subpage: Component {
				PageTzSelect {
					title: arctic.description
					model: TzArcticData {}
					region: "Arctic"
				}
			}
		}

		MbSubMenu {
			id: asia
			description: qsTr("Asia")
			subpage: Component {
				PageTzSelect {
					title: asia.description
					model: TzAsiaData {}
					region: "Asia"
				}
			}
		}

		MbSubMenu {
			id: atlantic
			description: qsTr("Atlantic")
			subpage: Component {
				PageTzSelect {
					title: atlantic.description
					model: TzAtlanticData {}
					region: "Asia"
				}
			}
		}

		MbSubMenu {
			id: australia
			description: qsTr("Australia")
			subpage: Component {
				PageTzSelect {
					title: australia.description
					model: TzAustraliaData {}
					region: "Australia"
				}
			}
		}

		MbSubMenu {
			id: europe
			description: qsTr("Europe")
			subpage: Component {
				PageTzSelect {
					title: europe.description
					model: TzEuropeData {}
					region: "Europe"
				}
			}
		}

		MbSubMenu {
			id: indian
			description: qsTr("Indian")
			subpage: Component {
				PageTzSelect {
					title: indian.description
					model: TzIndianData {}
					region: "Indian"
				}
			}
		}

		MbSubMenu {
			id: pacific
			description: qsTr("Pacific")
			subpage: Component {
				PageTzSelect {
					title: pacific.description
					model: TzPacificData {}
					region: "Pacific"
				}
			}
		}
		MbSubMenu {
			id: etc
			description: qsTr("Etc")
			subpage: Component {
				PageTzSelect {
					title: etc.description
					model: TzEtcData {}
					region: "Etc"
				}
			}
		}
	}
}
