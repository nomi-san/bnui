import QtQuick 2.2

import "../common"

Balloon
{
	id: container

	property variant balloonText

	leftPadding: 19
	rightPadding: 6
	topPadding: 16
	bottomPadding: 18
	closeButton.anchors.topMargin: 4

	target: balloonTarget
	style: BalloonStyle
	{
		borderImage: "../images/hintbox_green_border.png"
		borderTop: 13
		borderRight: 18
		borderBottom: 23
		borderLeft: 18
		contentPaddingTop: 7
		contentPaddingRight: 8
		contentPaddingBottom: 8
		contentPaddingLeft: 8
		arrowUpImage: "../images/hintbox_green_arrow_up.png"
		arrowRightImage: "../images/hintbox_green_arrow_right.png"
		arrowDownImage: "../images/hintbox_green_arrow_down.png"
		arrowLeftImage: "../images/hintbox_green_arrow_left.png"
	}

	Row
	{
		Image
		{
			id: code
			source: "../images/icon_claim_key.png"
			smooth: true
			y: 4
		}

		Spacer
		{
			width: 14
		}

		TextNormal
		{
			id: balloonTooltipText
			width: Math.max(170, balloonTooltipText.paintedWidth)
			wrapMode: Text.WordWrap
			font.pixelSize: 16
			font.family: fonts.regularFont.name
			color: "#ffffff"
			opacity: 1.0

			smooth: true

			text: container.balloonText
		}
	}
}
