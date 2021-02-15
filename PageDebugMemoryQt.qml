import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	title: "Qt allocations"

	model: VisualItemModel {
		MbItemValue {
			id: cacheSize
			description: "Image cache size"
			item.value: QuickView.imageCacheSize()

			Timer {
				interval: 1000
				running: true
				repeat: true
				onTriggered: cacheSize.item.value = QuickView.imageCacheSize()
			}
		}
	}
}
