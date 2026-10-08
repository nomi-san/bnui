import QtQuick 2.2
import QtQuick.Layouts 1.1
import browser 1.0

BrowserItemBase
{
	id: webview
	property variant delegate
	property alias loadingIcon: loadingIcon

	property bool showLoadingIcon: webview.loadingIndicator.visible

	Binding
	{
		// make sure the controller knows about the browser
		target: delegate
		property: "browserItem"
		value: webview
	}

	SpinnerLogo
	{
		id: loadingIcon
		small: false
		anchors.centerIn: webview
		visible: webview.loadingIndicator.visible
		playing: webview.loadingIndicator.visible
	}

	Item
	{
		id: fullscreen
		visible: webview.fullscreen
		anchors.fill: parent

		RowLayout
		{
			spacing: 32
			anchors.centerIn: parent

			ColumnLayout
			{
				spacing: 7

				Text
				{
					Layout.alignment: Qt.AlignCenter
					font.family: fonts.lightFont.name
					font.pixelSize: 22
					color: "white"
					verticalAlignment: Text.AlignVCenter
					text: qsTr("Full-screen mode enabled.")
				}

				Button
				{
					id: turnOffButton
					onClicked: { webview.reclaimBrowser(); }
					Layout.alignment: Qt.AlignCenter
					text
					{
						text: qsTr("Turn off full-screen mode")
						font.family: fonts.regularFont.name
						font.pixelSize: 15
					}
				}
			}
		}
	}
}
