import QtQuick 2.3
import Phoenix 1.0 as Phoenix
import "../common"

Item
{
	property string headerText
	height: visible ? 20 : 0

	anchors
	{
		leftMargin: 18
		rightMargin: 18
	}

	Text
	{
		id: ht
		anchors.fill: parent
		
		verticalAlignment: Text.AlignVCenter
		color: "white"
		text: headerText
		font.family: fonts.regularFont.name
		font.pixelSize: 13
		visible: tabNavigation.width == tabNavigation.maxWidth
	}

	Rectangle
	{
		id: separator
		height: 1
		width: 34
		visible: tabNavigation.width != tabNavigation.maxWidth
		color: "#ffffffff"
		opacity: 0.2;
		anchors
		{
			top: parent.top
		}
	}
}
