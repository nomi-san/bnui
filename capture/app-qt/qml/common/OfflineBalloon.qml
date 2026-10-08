import QtQuick 2.2
import QtQuick.Layouts 1.1
import Phoenix 1.0 as Phoenix
import "../common"

SimpleLoader
{
	id: offlineBalloon

	property string timerText
	property string text
	property string errorText
	property string errorUrl

	property variant anchorTarget

	visible: loginController.showOfflineBalloon
	opacity: offlineBalloon.visible ? 1.0 : 0
	Behavior on opacity { NumberAnimation { duration: 200; } }

	/* This is the balloon message that is displayed when
	   the connection attempt fails. */
	component: Balloon
	{
		id: offlineBalloonMessage

		property bool showBalloonError: (offlineBalloon.errorText.length > 0) && (offlineBalloon.errorUrl.length > 0)

		onCloseButtonClicked: loginController.CloseOfflineBalloon();
		target: offlineBalloon.anchorTarget
		tipType: Phoenix.ToolTip.ArrowUp
		leftPadding: 19
		rightPadding: 6
		topPadding: 16
		bottomPadding: 10
		closeButton.anchors.topMargin: 4


		Connections
		{
			target: offlineBalloon
			function onOpacityChanged() {
				update();
			}
		}

		function update() {
			offlineBalloonMessage.updateArrowOffset();
		}


		ColumnLayout
		{
			spacing: 10

			TextNormal
			{
				id: mainText
				wrapMode: Text.WordWrap
				text: offlineBalloon.text

				Layout.maximumWidth: 280
			}

			TextNormal
			{
				id: timerText
				wrapMode: Text.WordWrap
				text: {
					return offlineBalloon.timerText == "" ? ""
						: "<b><font color=\"#ffffff\">" + offlineBalloon.timerText + "</font></b>";
				}
				visible: offlineBalloon.timerText != "";

				Layout.maximumWidth: 280
			}

			WebLinkTextButton
			{
				id: button
				text: offlineBalloon.errorText
				onClicked: Qt.openUrlExternally(offlineBalloon.errorUrl)
				visible: offlineBalloonMessage.showBalloonError

				Layout.maximumWidth: 280
			}
		}
	}
}
