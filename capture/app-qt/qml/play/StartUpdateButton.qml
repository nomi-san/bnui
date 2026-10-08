import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

PlayScreenButton
{
	id: startUpdateButton
	property variant progressObject

	signal startUpdateClicked();

	onClicked: startUpdateClicked();

	enabled: true
	visible: progressObject.canStartUpdateNow

	width: 26; height: 26;
	iconSource: "../images/progressbar_button_start_now.png"

	//: Tooltip for 'start this update now' button button.
	toolTip: qsTr("Start this update now<br/><br/>Give this update priority over all other game updates.")

	tipType: Phoenix.ToolTip.ArrowDown | startUpdateButton.tooltipDirection
	noDelay: true

	onShowToolTip:
	{
		util.showToolTip(startUpdateButton, startUpdateButton, startUpdateButton.toolTip, startUpdateButton.tipType, noDelay);
	}
}
