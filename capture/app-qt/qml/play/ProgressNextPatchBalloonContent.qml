import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

Balloon
{
	id: container
	leftPadding: 14
	rightPadding: 10
	topPadding: 10
	bottomPadding: 12
	showCloseButton: false
	property variant progressObject
	property string warningColor:
	{
		if (progressObject.networkWarningType === Phoenix.Progress.Critical)
		{
			return "#fb2d2d";
		}
		if (progressObject.networkWarningType === Phoenix.Progress.Warning)
		{
			return "#ffdd00"
		}
		else
		{
			return "#16A803"
		}
	}

	Column
	{
		width: 358
		TextNormal
		{
			id: title
			text: qsTr("Background Download")
			font.pixelSize: 18
			color: warningColor
			anchors.left: parent.left
			anchors.right: parent.right
			wrapMode: Text.WrapAtWordBoundaryOrAnywhere
			textFormat: Text.RichText
		}

		Spacer { height: 6}

		TextNormal
		{
			id: bodyText
			color: "white"
			text: networkimpedimentActive ? progressObject.networkWarningToolTip : progressObject.toolTip;
			anchors.left : parent.left
			anchors.right : parent.right
			wrapMode: Text.WrapAtWordBoundaryOrAnywhere
			textFormat: Text.RichText
		}

		Spacer { height: 6 }

		GameTabProgressBar
		{
			id: progressBar
			visible: progressObject.nextPatchProgressBarVisible;
			height: 10
			barColor: warningColor
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.rightMargin: 8
			value: { return progressObject.progress }
		}

		Spacer
		{
			height:
			{
				if (!progressBar.visible)
				{
					return 0;
				}
				return 6;
			}
		}

		Column
		{
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.rightMargin: (container.leftPadding - container.rightPadding)
			Item
			{
				anchors.left: parent.left
				anchors.right: parent.right
				height: downloadingStatusText.height

				TextBusyArea
				{
					id: downloadingStatusText

					color: "white"

					// Replace all '|' characters with \u009C as this is a multi-length string.
					// This property caches progress object provided status text.
					statusText: progressObject.statusText.replace(/\|/g, "\u009C");
					running: progressObject.statusTextHasDots

					anchors.right : percentageText.left
					anchors.left : parent.left
					anchors.rightMargin: 10
					visible: progressObject.theme !== Phoenix.Progress.Grey
				}

				TextNormal
				{
					id: percentageText
					anchors.right : parent.right
					color: "white"
					text: Math.round(progressObject.progress* 100)  + "%"
					visible: true
				}
				visible: progressObject.theme !== Phoenix.Progress.Grey
			}

			Spacer { height: 3 }

			TextNormal
			{
				color: "#7D7F84"
				font.pixelSize: 13
				text: gameController.nextPatchDownloadLimit

				anchors.left : parent.left
				anchors.right : parent.right
				wrapMode: Text.WrapAtWordBoundaryOrAnywhere
				visible: gameController.nextPatchDownloadLimit !== ""
			}
			visible: progressObject.theme !== Phoenix.Progress.Grey
		}
	}
}

