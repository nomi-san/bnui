import QtQuick 2.2
import Phoenix 1.0 as Phoenix

//==========================================================================
// Prevent mouse events from propagating
//==========================================================================
Phoenix.ToolTipMouseArea
{
	hoverEnabled: true
	acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton | Qt.XButton1 | Qt.XButton2

	// Is this the only way to prevent tooltip from showing?
	//: This is an unused tooltip string.
	toolTip: qsTr("Unused")
	tipType: Phoenix.ToolTip.ArrowDown
}
