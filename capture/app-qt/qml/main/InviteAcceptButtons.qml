import QtQuick 2.2
import Phoenix 1.0
import QtQuick.Controls 1.4
import "../common"

Rectangle
{
	id: inviteButtons
	anchors.left: parent.left
	anchors.right: parent.right
	height: acceptButton.height + 8
	color: "transparent"

	property string acceptText: qsTr("Accept")
	property string declineText: qsTr("Decline")

	signal acceptButtonClicked()
	signal declineButtonClicked()

	Button
	{
		id: acceptButton
		height: 24

		text.color: "#cfd2d7"
		text.text: acceptText
		text.elide: Text.ElideRight
		text.maximumLineCount: 1
		text.font.pixelSize: 12
		horizontalPadding: 10

		onClicked: inviteButtons.acceptButtonClicked()
	}

	Button
	{
		id: declineButton
		height: 24

		anchors.left: acceptButton.right
		anchors.leftMargin: 8

		text.color: "#cfd2d7"
		text.text: declineText
		text.elide: Text.ElideRight
		text.maximumLineCount: 1
		text.font.pixelSize: 12
		horizontalPadding: 10

		backgroundImages: ButtonThemeImages
		{
			normal: "../controls/btn_secondary_normal.png"
			hovered: "../controls/btn_secondary_hover.png"
			pressed: "../controls/btn_secondary_pressed.png"
			disabled: "../controls/btn_secondary_disabled.png"
		}

		onClicked: inviteButtons.declineButtonClicked()
	}
}
