import QtQuick 2.2
import Phoenix 1.0 as Phoenix

Phoenix.ToolTipMouseArea
{
	id: container

	property variant targetItem: undefined
	property bool touchEnabled: true

	onShowToolTip:
	{
		if (!popupMode || container.touchEnabled)
		{
			container.displayToolTip(popupMode)
		}
	}

	function displayToolTip(popupMode)
	{
		// If targetItem is set, center tooltip on targetItem
		if (targetItem !== undefined)
			util.showToolTip(container, targetItem, container.toolTip, container.tipType, container.noDelay, popupMode)
		// Otherwise, center on ToolTipItem
		else
			util.showToolTip(container, container, container.toolTip, container.tipType, container.noDelay, popupMode)
	}
}
