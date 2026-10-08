import QtQuick 2.2

Text
{
	id: container

	color: buttonProperties.normal.color;
	opacity: buttonProperties.normal.opacity;

	//==========================================================================
	// ButtonBehavior properties
	//==========================================================================
	property string buttonState: ""
	property variant buttonProperties: ButtonStateProperies {}

	states:
	[
		State
		{
			name: "disabled"
			when: buttonState == "disabled"
			PropertyChanges { target: container; color: buttonProperties.disabled.color; opacity: buttonProperties.disabled.opacity; }
		},
		State
		{
			name: "pressed"
			when: buttonState == "pressed"
			PropertyChanges { target: container; color: buttonProperties.pressed.color; opacity: buttonProperties.pressed.opacity; }
		},
		State
		{
			name: "hovered"
			when: buttonState == "hovered"
			PropertyChanges { target: container; color: buttonProperties.hovered.color; opacity: buttonProperties.hovered.opacity; }
		},
		State
		{
			name: "activated"
			when: buttonState == "activated"
			PropertyChanges { target: container; color: buttonProperties.activated.color; opacity: buttonProperties.activated.opacity; }
		}
	]
}
