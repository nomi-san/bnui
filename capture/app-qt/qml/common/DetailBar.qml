import QtQuick 2.2

Item
{
	id: container

	property alias barOpacity: detailBar.opacity
	property int dBarLeft: 54
	property int dBarRight: 54

	anchors.top: parent.top
	anchors.topMargin: 2
	anchors.left: parent.left
	anchors.right: parent.right
	anchors.leftMargin: container.dBarLeft
	anchors.rightMargin: container.dBarRight

	height: detailBar.height

	BorderImage
	{
		id: detailBar
		source: self.isActive ? "../controls/border_topbar.png"
							  : "../controls/border_topbar_inactive.png";
		border.left: 11; border.top: 0
		border.right: 11; border.bottom: 0
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
	}
}

