import QtQuick 2.2
import Phoenix 1.0

import "../common"

PlayScreenButton
{
	id: container

	property variant productStatus
	property bool _multipleNotifications: productStatus.count > 1

	enabled: productStatus.clickable
	showToolTipWhenDisabled: true
	suppressDisabledEffect: true
	iconSource: productStatus.iconUrl === "" ? "" : "../" + productStatus.iconUrl
	text: _multipleNotifications ? productStatus.count : ""
	label: productStatus.text

	toolTip: productStatus.toolTipText
	noDelay: !_multipleNotifications
	tipType: ToolTip.ArrowDown | ToolTip.ArrowAtLeft
	onShowToolTip:
	{
		if (!productStatus.isMenuOpen)
			util.showToolTip(container, container, container.toolTip, container.tipType, container.noDelay)
	}

	buttonState:
	{
		var state = getButtonState();

		if (productStatus.isMenuOpen)
			state = "activated";
		else if (state === "pressed" && _multipleNotifications)
			state = "hovered"

		return state;
	}

	onPressed:
	{
		// Multiple Notifications
		if (_multipleNotifications)
		{
			var rect = util.globalGeometry(container);
			productStatus.ShowNotificationsMenu(rect, rect)
		}
		else
		{
			productStatus.clicked();
		}
	}
}
