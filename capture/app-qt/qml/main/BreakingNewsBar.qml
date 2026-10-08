import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

Rectangle
{
	id: breakingNewsBar
	color: "#360e10"

	//==========================================================================
	// Horizontal bar with breaking news text displayed
	//==========================================================================
	Item
	{
		id: iconWithText
		
		anchors
		{
			left: parent.left
			right: parent.right
			rightMargin: 20
			verticalCenter: parent.verticalCenter
		}

		//==========================================================================
		// Breaking news icon
		//==========================================================================
		Image
		{
			id: icon
			source: "../images/icon_breaking_news_bar.png"
			anchors
			{
				leftMargin: 7
				left: parent.left
				verticalCenter: parent.verticalCenter
			}
		}
		
		//==========================================================================
		// Status text for offline banner
		//==========================================================================
		Text
		{
			id: breakingNewsText
			width: parent.width - icon.width - 15
	
			anchors
			{
				left: icon.right
				leftMargin: 9
				verticalCenter: parent.verticalCenter
			}

			text: convertHtmlToText();

			wrapMode: Text.NoWrap
	
			font.family: fonts.regularFont.name
			font.pixelSize: 13;
			// This check is needed for elide to behave correctly on Mac
			elide: Math.abs(implicitWidth - width) < 1 ? Text.ElideNone : Text.ElideRight
			color: "#ffffff"
			opacity: 0.7

			textFormat: Text.PlainText

			function convertHtmlToText()
			{
				var inputText = appController.serviceAlertMonitor.breakingNews
				var returnText = "" + inputText;

				//-- remove BR tags and replace them with line break
				returnText = returnText.replace(/<br>/gi, "\n");
				returnText = returnText.replace(/<br\s\/>/gi, "\n");
				returnText = returnText.replace(/<br\/>/gi, "\n");

				//-- remove P and A tags but preserve what's inside of them
				returnText = returnText.replace(/<p.*>/gi, "\n");
				returnText = returnText.replace(/<a.*href="(.*?)".*>(.*?)<\/a>/gi, " $2 ($1)");

				//-- remove all inside SCRIPT and STYLE tags
				returnText = returnText.replace(/<script.*>[\w\W]{1,}(.*?)[\w\W]{1,}<\/script>/gi, "");
				returnText = returnText.replace(/<style.*?>(.|\n)*?<\/style>/gi, "");
				//-- remove all else
				returnText = returnText.replace(/<(?:.|\s)*?>/g, "");

				//-- get rid of more than 2 multiple line breaks:
				returnText = returnText.replace(/(?:(?:\r\n|\r|\n)\s*){2,}/gim, "\n\n");
				returnText = returnText.replace(/(?:(?:\r\n|\r|\n)\s*)/gim, " ");

				//-- get rid of more than 2 spaces:
				returnText = returnText.replace(/ +(?= )/g,'');

				//-- get rid of html-encoded characters:
				returnText = returnText.replace(/&nbsp;/gi," ");
				returnText = returnText.replace(/&amp;/gi,"&");
				returnText = returnText.replace(/&quot;/gi,'"');
				returnText = returnText.replace(/&lt;/gi,'<');
				returnText = returnText.replace(/&gt;/gi,'>');

				//-- return
				return returnText;
			}
		}
	}
	
	MouseArea
	{
		id: breakingNewsTextTooltip
		anchors.fill: parent
		hoverEnabled: true
		enabled: true
		onEntered:
		{
			util.showToolTip(breakingNewsBar, breakingNewsBar,
			//: Tooltip for breaking news bar.
				qsTr("Click to view full message"), Phoenix.ToolTip.ArrowDown, 0)
			breakingNewsBar.color = "#461113"
		}
		onExited:
		{
			breakingNewsBar.color = "#360e10"
		}
		onClicked:
		{
			appController.serviceAlertMonitor.ShowBreakingNewsDialog();
		}
	}

	Rectangle
	{
		border.color: "#ffffff"
		border.width: 1
		color: "#00000000"
		opacity: 0.1

		anchors.fill: parent
	}
}	
