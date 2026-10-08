import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

PlayScreenButton
{
	id: button

	width: 26; height: 26;
	iconSource: "../images/progressbar_button_cancel.png"

	tipType: Phoenix.ToolTip.ArrowDown | button.tooltipDirection
	noDelay: true

	onShowToolTip:
	{
		util.showToolTip(button, button, button.toolTip, button.tipType, noDelay);
	}
}
