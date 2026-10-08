import QtQuick 2.2
import Phoenix 1.0
import QtQuick.Controls 2.1
import "../common"

RadioButton
{
	id: control
	hoverEnabled: true
	implicitHeight: 20

	indicator: Image
	{
		id: buttonImage
		width: 20
		height: 20
		source: getIconSource()

		function getIconSource()
		{
			var url = "../controls/radiobutton_"
			url += control.checked ? "checked" : "unchecked"
			if (control.pressed)
			{
				url += "_pressed.png"
			}
			else
			{
				url += control.hovered ? "_hover.png" : ".png"
			}

			return url
		}
	}


	contentItem: ElidingText
	{
		text: control.text
		elide: Text.ElideRight
		maximumLineCount: 1
		font.family: fonts.regularFont.name
		font.pixelSize: 13
		color: "#cfd2d7"
		anchors.left: buttonImage.right
		anchors.leftMargin: 8
		anchors.top: parent.top
		anchors.topMargin: 2
		anchors.right: parent.right
	}
}
