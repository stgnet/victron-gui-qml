import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	property string gateway: "can0"
	property bool busOffCounters

	Timer {
		interval: 1000
		running: true
		repeat: true
		triggeredOnStart: true

		function percentage(count, total)
		{
			if (!total)
				return ""
			var perc = count / total * 100
			return " (" + perc.toFixed(2) + "%)"
		}

		onTriggered: {
			if (!gateway)
				return

			var json = vePlatform.canBusStats(gateway)
			var stats = JSON.parse(json)[0]

			stateItem.show = stats.linkinfo !== undefined
			if (stats.linkinfo) {
				state.item.text = stats.linkinfo.info_data.state
				tec.item.text = "TEC: " + stats.linkinfo.info_data.berr_counter.tx
				rec.item.text = "REC: " + stats.linkinfo.info_data.berr_counter.rx

				busOffCounters = stats.linkinfo.info_xstats !== undefined
				if (stats.linkinfo.info_xstats) {
					busOff.item.text = stats.linkinfo.info_xstats.bus_off
					errorPassive.item.text = stats.linkinfo.info_xstats.error_passive
					busWarn.item.text = stats.linkinfo.info_xstats.error_warning
				}
			}

			rx_dropped.item.text = "dropped: " + stats.stats64.rx.dropped + percentage(stats.stats64.rx.dropped, stats.stats64.rx.packets)
			rx_errors.item.text = "errors: " + stats.stats64.rx.errors + percentage(stats.stats64.rx.errors, stats.stats64.rx.packets)
			rx_over_errors.item.text = "overruns: " + stats.stats64.rx.over_errors + percentage(stats.stats64.rx.over_errors, stats.stats64.rx.packets)
			rx_packets.item.text = "packets: " + stats.stats64.rx.packets

			tx_dropped.item.text = "dropped: " + stats.stats64.tx.dropped + percentage(stats.stats64.tx.dropped, stats.stats64.tx.packets)
			tx_errors.item.text = "errors: " + stats.stats64.tx.errors + percentage(stats.stats64.tx.errors, stats.stats64.tx.packets)
			tx_packets.item.text = "packets: " + stats.stats64.tx.packets
		}
	}

	model: VisualItemModel {
		MbItemRow {
			id: stateItem
			description: "State"

			MbTextBlock {
				id: state
			}

			MbTextBlock {
				id: tec
			}

			MbTextBlock {
				id: rec
			}
		}

		MbItemValue {
			id: busOff
			description: "Bus off count"
			show: busOffCounters
		}

		MbItemValue {
			id: errorPassive
			description: "Error passive count"
			show: busOffCounters
		}

		MbItemValue {
			id: busWarn
			description: "Bus warning count"
			show: busOffCounters
		}

		MbItemRow {
			description: "RX"

			MbTextBlock {
				id: rx_packets
			}

			MbTextBlock {
				id: rx_dropped
			}
		}

		MbItemRow {
			MbTextBlock {
				id: rx_over_errors
			}

			MbTextBlock {
				id: rx_errors
			}
		}

		MbItemRow {
			description: "TX"

			MbTextBlock {
				id: tx_packets
			}

			MbTextBlock {
				id: tx_dropped
			}
		}

		MbItemRow {
			MbTextBlock {
				id: tx_errors
			}
		}
	}
}
