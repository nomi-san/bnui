import QtQuick 2.2
import QtQuick.Layouts 1.2

import Phoenix 1.0

import "../common"
import "../main"
import "../common/util.js" as Util

ColumnLayout
{
	anchors.margins: 25
	spacing: 20

	Text
	{
		id: titleText

		text: "Control Demos"
		font.family: "Blizzard"
		font.pixelSize: 24
		color: "#ffffff"

	}

	RowLayout
	{
		// The left column
		ColumnLayout
		{
			id: leftColumn
			//Rectangle { anchors.fill: parent; color: "plum" }

			Text
			{
				id: leftColTitleText

				text: "Qml Demos"
				font.family: "Blizzard"
				font.pixelSize: 18
				color: "#ffffff"

			}

			RowLayout
			{
				Button
				{
					width: 140
					height: 40
					id: testButton

					text
					{
						text: "Open Popup Menu"
						font.family: "Blizzard"
						font.pixelSize: 14
					}

					toolTip: "I have a tooltip!"
					tipType: ToolTip.ArrowUp
					noDelay: true
					onShowToolTip: util.showToolTip(testButton, testButton, testButton.toolTip, testButton.tipType, testButton.noDelay)

					onClicked:
					{
						var anchorRect = util.globalGeometry(testButton);
						var centeredRect = util.globalGeometry(testButton);
						anchorRect.height -= 5;
						centeredRect.height = 1;
						helpers.ShowStatusMenu(centeredRect, anchorRect);
					}
				}
			}

			RowLayout
			{
				Button
				{
					width: 140
					height: 40
					id: testButton2

					text
					{
						text: "Open Popup Dialog"
						font.family: "Blizzard"
						font.pixelSize: 14
					}

					onClicked:
					{
						self.ShowDialog();
					}
				}
			}

			Spacer
			{
				Layout.fillHeight: true
			}
		}

		// put some space between the two columns
		Spacer
		{
			Layout.fillWidth: true
		}


		ColumnLayout
		{
			id: rightColumn

			//Rectangle { anchors.fill: parent; color: "plum" }

			Button
			{
				width: 240
				height: 60
				id: browserNativeButton

				text
				{
					text: "BrowserWidget (Native)"
					font.family: "Blizzard"
					font.pixelSize: 14
				}

				onClicked:
				{
					self.ShowBrowserDialog(false);
				}
			}

			Button
			{
				width: 240
				height: 60
				id: browserOffscreenButton

				text
				{
					text: "BrowserWidget (Offscreen)"
					font.family: "Blizzard"
					font.pixelSize: 14
				}

				onClicked:
				{
					self.ShowBrowserDialog(true);
				}
			}

			Spacer
			{
				Layout.fillHeight: true
			}
		}
	}
}