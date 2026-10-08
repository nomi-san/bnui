import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

Rectangle
{
	id: feedbackBar
	color: "#1C2337"

	Item
	{
		id: textArea

		anchors
		{
			left: parent.left
			right: parent.right
			rightMargin: 20
			verticalCenter: parent.verticalCenter
		}

		Text
		{
			id: feedbackText

			width: parent.width
			horizontalAlignment: Text.AlignHCenter
			anchors.verticalCenter: parent.verticalCenter

			color: "#ffffff"
			opacity: 1
			font.family: fonts.regularFont.name
			font.pixelSize: 13
			textFormat: Text.RichText

			property string linkColor: hoveredLink ? "#ffffff" : "#00aeff"


			//: Text in the feedback bar next to the feedback link telling the user how to send feedback.
			//: %1 and %2 are markup that together create a link out of "Give us your feedback".
			text: qsTr("What do you think about the Battle.net App beta? %1Give us your feedback%2")
			.arg("<a href='feedback' style='text-decoration: none; color: " + linkColor + ";'>")
			.arg("</a>");

			onLinkActivated:
			{
				if (link == "feedback")
					appController.OpenFeedbackDialog();
			}

			MouseArea
			{
				anchors.fill: parent
				acceptedButtons: Qt.NoButton // we don't want to eat clicks on the Text
				cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
			}
		}
	}

	VertButton
	{
		id: dismissButton
		visible: true

		anchors
		{
			right: parent.right
			top: parent.top
			bottom: parent.bottom
			rightMargin: 15
		}

		width: icon.width
		height: icon.height
		backgroundImages: ButtonThemeImages {}
		iconSource: "../images/btn_exit.png"
		onClicked: appController.DismissFeedbackBar();
		iconOpacity: ButtonThemeOpacities
		{
			normal: 0.4
			hovered: 0.5
			pressed: 0.3
			disabled: 0.1
		}
	}

	Rectangle
	{
		color: "#ffffff"
		opacity: 0.1

		anchors.left: parent.left
		anchors.leftMargin: 1
		anchors.right: parent.right
		anchors.rightMargin: 1
		anchors.top: parent.top

		height: 1
	}
}
