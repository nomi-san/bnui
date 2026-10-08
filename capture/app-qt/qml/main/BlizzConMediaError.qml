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
				text: qsTr("Join us at the convention!")

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
				text: qsTr("To see all the epic content BlizzCon has to offer, " +
					"visit the BlizzCon website.")

				Layout.maximumWidth: 345
				Layout.minimumWidth: 345
				Layout.preferredWidth: contentWidth
				Layout.preferredHeight: height
			}

			Button
			{
				id: goNowButton
				onClicked: { screenController.blizzConScreen.OpenExternalBrowser(); }
				Layout.alignment: Qt.AlignLeft
				text
				{
					//: Open browser to BlizzCon website
					text: qsTr("Go Now")
					font.family: fonts.regularFont.name
					font.pixelSize: 13
				}
				backgroundImages: ButtonThemeImages
				{
					normal: "../controls/btn_primary_normal.png"
					hovered: "../controls/btn_primary_hover.png"
					pressed: "../controls/btn_primary_pressed.png"
					disabled: "../controls/btn_primary_disabled.png"
				}
			}
		}

		Image
		{
			id: mainImage
			Layout.fillWidth: false
			Layout.maximumWidth: width

			source: "../images/blizzcon_logo_large.png"
		}
	}
}

