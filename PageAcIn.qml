import QtQuick 1.1
import com.victron.velib 1.0

MbPage {
	id: root

	property variant service
	property string bindPrefix
	// froniusInverterProductId should always be equal to VE_PROD_ID_PV_INVERTER_FRONIUS
	property int froniusInverterProductId: 0xA142
	// carloGavazziEmProductId should always be equal to VE_PROD_ID_CARLO_GAVAZZI_EM
	property int carloGavazziEmProductId: 0xB002
	// fisherPandaProductId should always be equal to VE_PROD_ID_FISCHER_PANDA_GENSET
	property int fisherPandaProductId: 0xB040

	title: service.description
	summary: model !== 0 ? model.summary : ""
	model: 0

	VBusItem {
		id: productIdItem
		bind: service.path("/ProductId")
		onValidChanged: if (valid && root.model === 0) setPageModel()
	}

	function setPageModel()
	{
		if (productIdItem.value === fisherPandaProductId) {
			root.model = Qt.createQmlObject('PageAcInModelFpGenset {}', root)
		} else {
			root.model = Qt.createQmlObject('PageAcInModelDefault {}', root)
		}
	}
}
