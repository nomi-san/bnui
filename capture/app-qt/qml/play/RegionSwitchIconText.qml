import QtQuick 2.2

import "../common"

Item
{
	height: column.height

	property alias iconSource: icon.source
	property alias text: textItem.text

	Rectangle
	{
		anchors.fill: parent
		color: "#1f252f"
		border.color: "#3d434f"
		border.width: 1
	}

	Column
	{
		id: column

		anchors.left: parent.left
		anchors.right: parent.right

		Spacer { height: 14; }

		Image
		{ 
			id: icon
			anchors.horizontalCenter: parent.horizontalCenter
		}

		Spacer { height: 4; }

		TextNormal 
		{ 
			id: textItem

			// Define height so that text is vertically centered and aligned with texts from other cards
			height: 35
			
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.leftMargin: 10
			anchors.rightMargin: 10
			font.pixelSize: 12;
			text: qsTr("GAME PURCHASES") 
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
		}

		Spacer { height: 7; }
	}	
}
