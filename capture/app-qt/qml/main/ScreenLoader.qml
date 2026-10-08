import QtQuick 2.2
import "../common"

Loader
{
	id: loader
	anchors
	{
		left: parent.left
		right: parent.right
		top: parent.top
		bottom: notificationBar.visible ? notificationBar.top : parent.bottom
	}

	source: screen.qmlSource
	visible: false
}
