import QtQuick 2.2
import "../common"
import Phoenix 1.0 as Phoenix

ButtonBehavior
{
	id: buttonBehavior

	property variant iconSource
	property alias text: text.text
	property alias label: label.text
	property bool suppressDisabledEffect: false
	property variant tooltipDirection

	anchors.fill: undefined
	width: 70
	height: 71

	//==========================================================================
	// Background Border
	//==========================================================================
	ButtonStateBorder
	{
		anchors.fill: parent

		source: "../images/statusicon_border.png"
		border { top: 2; right: 2; bottom: 2; left: 2; }

		// Button State
		buttonState: buttonBehavior.buttonState
		buttonProperties: ButtonStateProperies
		{
			activated	{ opacity: 1.0 }
			normal		{ opacity: 1.0 }
			pressed		{ opacity: 1.0 }
			hovered		{ opacity: 1.0 }
			disabled	{ opacity: 1.0 }
		}
	}

	//==========================================================================
	// Contents
	//==========================================================================
	Column
	{
		anchors.verticalCenter: parent.verticalCenter
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenterOffset: label.text === "" ? 0 : 3

		spacing: 2

		Row
		{
			anchors.horizontalCenter: parent.horizontalCenter

			spacing: 5

			ButtonStateImage
			{
				id: icon

				property real desaturation: !suppressDisabledEffect && !buttonBehavior.enabled ? 1.0: 0.0;

				// Button State
				buttonState: buttonBehavior.buttonState
				buttonProperties: ButtonStateProperies
				{
					activated	{ opacity: 1.0; }
					normal		{ opacity: 0.8; value: buttonBehavior.iconSource; }
					pressed		{ opacity: 0.7; offsetX: 1; offsetY: 1; }
					hovered		{ opacity: 1.0; }
					disabled	{ opacity: 0.9; desaturation: icon.desaturation }
				}
			}

			ButtonStateText
			{
				id: text

				font.family: fonts.regularFont.name
				font.pixelSize: 20

				anchors.verticalCenter: parent.verticalCenter

				buttonProperties: ButtonStateProperies
				{
					activated	{ opacity: 1.0; color: "white" }
					normal		{ opacity: 0.8; color: "white" }
					pressed		{ opacity: 0.7; color: "white"; offsetX: 1; offsetY: 1; }
					hovered		{ opacity: 1.0; color: "white" }
					disabled	{ opacity: 0.9; color: "white" }
				}
			}
		}

		ButtonStateText
		{
			id: label

			font.family: fonts.regularFont.name
			font.pixelSize: 12

			anchors.horizontalCenter: parent.horizontalCenter

			buttonProperties: ButtonStateProperies
			{
				activated	{ opacity: 1.0; color: "white" }
				normal		{ opacity: 0.8; color: "white" }
				pressed		{ opacity: 0.7; color: "white"; offsetX: 1; offsetY: 1; }
				hovered		{ opacity: 1.0; color: "white" }
				disabled	{ opacity: 0.9; color: "white" }
			}
		}
	}
}
