import QtQuick 2.2

Item
{
	id: container

	property alias text: textItem.text

	implicitWidth: content.width
	implicitHeight: content.height

	signal clicked()

	ButtonBehavior
	{
		id: buttonBehavior
		onClicked: container.clicked();
	}

	Row
	{
		id: content
		anchors.verticalCenter: parent.verticalCenter

		spacing: 5

		ButtonStateText
		{
			id: textItem

			font.family: fonts.regularFont.name
			font.pixelSize: 13

			anchors.verticalCenter: parent.verticalCenter

			// Button State
			buttonState: buttonBehavior.buttonState
			buttonProperties: ButtonStateProperies
			{
				activated	{ opacity: 1.0; color: "white" }
				normal		{ opacity: 1.0; color: "#00aeff" }
				pressed		{ opacity: 1.0; color: "white" }
				hovered		{ opacity: 1.0; color: "white" }
				disabled	{ opacity: 1.0; color: "#3f3f3f" }
			}
		}

		ButtonStateImage
		{
			id: icon
			anchors.verticalCenter: parent.verticalCenter

			// Button State
			buttonState: buttonBehavior.buttonState
			buttonProperties: ButtonStateProperies
			{
				activated	{ opacity: 1.0; }
				normal		{ value: "../images/icon_web_link.png"; opacity: 1.0; }
				pressed		{ opacity: 1.0; }
				hovered		{ opacity: 1.0; }
				disabled	{ opacity: 0.9; }
			}
		}
	}
}
