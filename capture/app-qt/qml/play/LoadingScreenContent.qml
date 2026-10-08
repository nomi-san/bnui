import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

Item
{
	id: loadingScreenContent

	property string backgroundUrl: playScreen.defaultBackgroundUrl;
	property string backgroundColor: playScreen.defaultBackgroundColor;

	Column
	{
		anchors.centerIn: parent
		anchors.verticalCenterOffset: -(mainScreen.topNavHeight / 2)

		SpinnerLogo
		{			
			anchors.horizontalCenter: parent.horizontalCenter
			visible: true
		}

		Spacer { height: 10 }

		TextBusyArea
		{
			id: messageText
			running: true

			anchors.horizontalCenter: parent.horizontalCenter
			color: "white"
			font.family: fonts.regularFont.name;
			font.pixelSize: 14;

			statusText: gameController.loadingString

			layer.enabled: true
			layer.effect: DropShadowEffect {}
		}

		Spacer { height: 5 }

		Text
		{
			id: clickableMessage
			anchors.horizontalCenter: parent.horizontalCenter
			horizontalAlignment: Text.AlignHCenter

			color: "white"
			font.family: fonts.regularFont.name;
			font.pixelSize: 14;
			width: Math.min(600, loadingScreenContent.width)
			text: gameController.loadingStringFooter
			textFormat: Text.RichText

			onLinkActivated: Qt.openUrlExternally(link);
			wrapMode: Text.WordWrap

			layer.enabled: true
			layer.effect: DropShadowEffect {}
		}
	}	
}
