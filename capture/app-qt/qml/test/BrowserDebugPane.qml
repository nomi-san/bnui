import QtQuick 2.2
import QtQuick.Controls 1.4 as Controls
import QtQuick.Layouts 1.2

import Phoenix 1.0
import browser 1.0

import "../common"
import "../main"
import "../common/util.js" as Util

Item
{
	id: popupRoot

	width: bg.width
	height: bg.height

	Rectangle
	{
		id: bg

		color: "light blue"

		width: layout.width + 20
		height: layout.height + 20
	}

	property variant browserView: undefined

	ColumnLayout
	{
		id: layout
		x: 10
		y: 10

		Text
		{
			text: "Browser Debug Pane"
			font.bold: true
			font.pointSize: 12.0
		}

		RowLayout
		{
			Rectangle
			{
				color: "#ffffff"
				width: 75
				height: frameRate.height

				Text
				{
					id: frameRateText

					text: "Frame Rate:"
					anchors.centerIn: parent
				}
			}
			

			Controls.TextField
			{
				id: frameRate
				width: 50

				onTextChanged: {
					browserView.frameRate = parseInt(frameRate.text)
					console.log("Frame Rate: " + parseInt(frameRate.text) + " / " + browserView.frameRate);
				}
			}
		}
	}
}