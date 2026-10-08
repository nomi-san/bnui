import QtQuick 2.2
import Phoenix 1.0 as Phoenix

PlayScreenButton
{
	id: container

	width: 26; height: 26;
	iconSource: "../images/icon_setting_on.png"
	//: Tooltip for the cancel install button.
	toolTip: qsTr("Installation & update options")
	tipType: Phoenix.ToolTip.ArrowDown | container.tooltipDirection
	noDelay: true

	onShowToolTip:
	{
		util.showToolTip(container, container, container.toolTip, container.tipType, noDelay);
	}
}
