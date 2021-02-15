import QtQuick 1.1
import com.victron.velib 1.0

MbEditBox {
	writeAccessLevel: User.AccessUser
	matchString: "0123456789"
	ignoreChars: "."
	maximumLength: 15
	overwriteMode: true
	numericOnlyLayout: true
	invalidText: "---"

	function getEditText() {
		if (!item.valid)
			return "000.000.000.000"
		var res = item.value.split('.')
		for (var i= 0; i < res.length; i++)
			res[i] = ("000" + res[i]).substr(-3)
		return res.join('.');
	}

	function editTextToValue() {
		var res = _editText.split('.')
		for (var i= 0; i < res.length; i++)
			res[i] = parseInt(res[i], 10)
		return res.join('.');
	}

	function wrapAround(pos) {
		var n = pos % 4
		switch (n) {
		case 0:
			return 3
		case 1:
			if (_editText[pos - 1] === '2')
				return 6
			break
		case 2:
			if (_editText.substr(pos - 2, 2) === "25")
				return 6
		}

		return 10
	}

	function validate(newText, pos) {
		var wrap = wrapAround(pos)

		if ((newText[pos] - "0") >= wrap) {
			var text = qsTr("Only numbers up to %1 are valid on this location").arg(wrap - 1)
			toast.createToast(text, 3000)
			return null
		}

		if ((pos % 4) == 0 && newText[pos] === "2") {
			if (newText[pos + 1] > "5")
				newText = setValueAt(newText, pos + 1, "5", false);
			if (newText[pos + 1] === "5" && newText[pos + 2] > "5")
				newText = setValueAt(newText, pos + 2, "5", false);
		}

		if ((pos % 4) === 1 && newText.substr(pos - 1, 2) === "25" && newText[pos + 1] > "5")
			newText = setValueAt(newText, pos + 1, "5", false);

		return newText
	}
}
