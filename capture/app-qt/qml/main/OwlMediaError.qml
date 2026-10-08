import QtQuick 2.2
import QtQuick.Layouts 1.1
import Phoenix 1.0 as Phoenix

import "../common"

Item
{
	id: errorContainer
	anchors.fill: parent
	RowLayout
	{
		id: mainLayout
		spacing: 32
		anchors.centerIn: parent

		ColumnLayout
		{
			id: mainColumns
			Layout.fillWidth: false
			spacing: 32

			Text
			{
				id: title
				Layout.alignment: Qt.AlignLeft

				wrapMode: Text.Wrap
				font.family: fonts.regularFont.name
				font.pixelSize: 30;
				color: "#CCFFFFFF"
				verticalAlignment: Text.AlignVCenter
				text: qsTr("Get into the action!")

				Layout.preferredWidth: width
				Layout.preferredHeight: height
			}

			Text
			{
				id: body
				Layout.alignment: Qt.AlignLeft
				wrapMode: Text.Wrap
				font.family: fonts.regularFont.name
				font.pixelSize: 13;
				color: "#CCFFFFFF"
				verticalAlignment: Text.AlignVCenter
				text: qsTr("To view Overwatch League video streams and other" +
					" content, visit the Overwatch League website.")

				Layout.maximumWidth: 345
				Layout.minimumWidth: 345
				Layout.preferredWidth: contentWidth
				Layout.preferredHeight: height
			}

			Button
			{
				id: owlButton
				onClicked: { screenController.owlScreen.OpenExternalBrowser(); }
				Layout.alignment: Qt.AlignLeft
				text
				{
					//: Open browser to Overwatch League website
					text: qsTr("Go Now")
					font.family: fonts.regularFont.name
					font.pixelSize: 13
				}
				backgroundImages: ButtonThemeImages
				{
					normal: "../controls/btn_orange_normal.png"
					hovered: "../controls/btn_orange_hover.png"
					pressed: "../controls/btn_orange_pressed.png"
					disabled: "../controls/btn_orange_disabled.png"
				}
			}
		}

		Image
		{
			id: mainImage
			Layout.fillWidth: false
			Layout.maximumWidth: width

			source: "../images/owl_logo_large.png"
		}
	}
}

