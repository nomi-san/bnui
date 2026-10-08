import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

Item
{
	id: emptyScreenContent

	property string backgroundUrl: playScreen.defaultBackgroundUrl;
	property string backgroundColor: playScreen.defaultBackgroundColor;

	Column
	{
		anchors.verticalCenter: parent.verticalCenter
		anchors.verticalCenterOffset: -(mainScreen.topNavHeight / 2)
		anchors.horizontalCenter: parent.horizontalCenter

		spacing: 10

		layer.enabled: true
		layer.effect: DropShadowEffect {}

		Text
		{
			id: heading
			
			anchors.horizontalCenter: parent.horizontalCenter
			horizontalAlignment: Text.AlignHCenter
			font.family: fonts.lightFont.name
			font.pixelSize: 48
			smooth: true
			color: "white"

			text: qsTr("Oops!")
		}

		Text
		{
			id: text
			anchors.horizontalCenter: parent.horizontalCenter
			horizontalAlignment: Text.AlignHCenter

			color: "white"
			font.family: fonts.regularFont.name;
			font.pixelSize: 14;
			width: Math.min(600, emptyScreenContent.width)
			text: gameController.errorString
			textFormat: Text.RichText

			onLinkActivated: Qt.openUrlExternally(link);
			wrapMode: Text.WordWrap
		}

	}	
}
