import QtQuick 1.1
import com.victron.velib 1.0

/*
 * This object contains all charger errors.
 * These errors are valid for all MPPT and Skylla-i models.
 */
MbItemValue {
	item.text: item.valid ? error.description(item.value) : item.invalidText

	ChargerError {
		id: error
	}
}
