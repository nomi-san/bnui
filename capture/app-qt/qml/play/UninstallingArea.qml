import QtQuick 2.2
import "../common"

Item
{
	id: container

	property variant progressObject

	Spinner
	{
		id: spinner
		anchors
		{
			left: parent.left
			leftMargin: 10
			verticalCenter: statusText.verticalCenter
		}
		small: true
	}

	TextBusyArea
	{
		id: statusText

		// Replace all '|' characters with \u009C as this is a multi-length string.
		// This property caches progress object provided status text.
		statusText: progressObject.statusText.replace(/\|/g, "\u009C");
		running: progressObject.statusTextHasDots

		anchors
		{
			left: spinner.right
			leftMargin: 10
			right: parent.right
			rightMargin: 12
			verticalCenter: parent.verticalCenter
			verticalCenterOffset: -1
		}

		layer.enabled: true
		layer.effect: DropShadowEffect {}
	}
}
