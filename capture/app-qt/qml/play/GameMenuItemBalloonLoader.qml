import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

SimpleLoader
{
	id: container

	property variant anchorTarget
	property variant tipType: Phoenix.ToolTip.ArrowUp
	property variant balloonText
	property variant modelItem

	component: GameMenuItemBalloonMessage
	{
		id: redeemCodeReminder
		balloonText: container.balloonText

		tipType: container.tipType
		target: container.anchorTarget
		onCloseButtonClicked: container.modelItem.balloonTooltipDismissed()
	}
}
