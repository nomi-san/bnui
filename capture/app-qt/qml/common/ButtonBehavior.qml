import QtQuick 2.2
import Phoenix 1.0

ToolTipMouseArea
{
	id: behavior

	//==========================================================================
	// Properties Declarations
	//==========================================================================
	property string buttonState: getButtonState()

	//==========================================================================
	// Properties
	//==========================================================================
	anchors.fill: parent
	hoverEnabled: true

	//==========================================================================
	// functions
	//==========================================================================
	function getButtonState()
	{
		var state = "";

		if (!behavior.enabled)
			state = "disabled";
		else if (behavior.pressed)
			state = "pressed"
		else if (behavior.containsMouse)
			state = "hovered"
		else if (behavior.focus)
			state = "activated"

		return state;
	}
}
