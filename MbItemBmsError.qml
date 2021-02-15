import QtQuick 1.1
import com.victron.velib 1.0

MbItemValue {
	item.text: item.valid ? error.description(item.value) : item.invalidText

	BmsError {
		id: error
	}
}
