import QtQuick 2.2
import Phoenix 1.0

import "../../common"
import "../../common/util.js" as Util

Text
{
	id: debugArea

	font.pixelSize: 10
	anchors.margins: 4
	font.family: fonts.regularFont.name
	property variant view: playView

	function licenseIdText(str) {
		if (str === "") {
			return "<i>none</i>";
		}
		return str;
	}

	function getKeyValues() {
		if (!view.product || !view.account)
			return null;
		var obj = {
			"uid": view.product.uid,
			"uniqueId": view.product.uniqueId,
			"selectedRegion": view.account.regionCode,
		}
		if (view.account.accountName) {
			obj["accountName"] = view.account.accountName;
		}
		obj["dataSource"] = licenseIdText(view.account.dataSource);
		obj["tags"] = view.account.tags;

		if (_verbose) {
			obj["details"] = Util.outputProperties(view.account);
		}
		return obj;
	}

	function keyValuesToText(obj) {
		var string = ""
		for (var key in obj) {
			if (obj.hasOwnProperty(key)) {
				var value = obj[key];
				if (string)
					string += "<br />";
				string += "<font color='white'>" + key + "[ " +
					"<font color='#B2DCFF'><b>" + value + "</b></font> ]</font>";
			}
		}
		return string
	}

	text: keyValuesToText(getKeyValues());

	property bool _verbose: false;

	Rectangle
	{
		anchors.fill: parent
		anchors.margins: -4
		color: "black"
		opacity: 0.5
		z: -1

		MouseArea
		{
			anchors.fill: parent
			acceptedButtons: Qt.LeftButton | Qt.RightButton;

			onClicked: {
				if (mouse.button == Qt.RightButton) {
					debugArea.visible = false;
				} else {
					_verbose = !_verbose;
				}
			}
		}
	}
}
