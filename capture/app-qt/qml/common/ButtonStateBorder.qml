import QtQuick 2.2

BorderImage
{
	id: container

	source: buttonProperties.normal.value;
	opacity: buttonProperties.normal.opacity;

	//==========================================================================
	// ButtonBehavior properties
	//==========================================================================
	property string buttonState: ""
	property variant buttonProperties: ButtonStateProperies {}

	StateGroup
	{
		states:
		[
			State
			{
				name: "disabled"
				when: buttonState == "disabled" && buttonProperties.disabled.opacity !== undefined
				PropertyChanges { target: container; opacity: buttonProperties.disabled.opacity; }
			},
			State
			{
				name: "pressed"
				when: buttonState == "pressed" && buttonProperties.pressed.opacity !== undefined
				PropertyChanges { target: container; opacity: buttonProperties.pressed.opacity; }
			},
			State
			{
				name: "hovered"
				when: buttonState == "hovered" && buttonProperties.hovered.opacity !== undefined
				PropertyChanges { target: container; opacity: buttonProperties.hovered.opacity; }
			},
			State
			{
				name: "activated"
				when: buttonState == "activated" && buttonProperties.activated.opacity !== undefined
				PropertyChanges { target: container; opacity: buttonProperties.activated.opacity; }
			}
		]
	}

	StateGroup
	{
		states:
		[
			State
			{
				name: "disabled"
				when: buttonState == "disabled" && buttonProperties.disabled.value !== undefined
				PropertyChanges { target: container; source: buttonProperties.disabled.value; }
			},
			State
			{
				name: "pressed"
				when: buttonState == "pressed" && buttonProperties.pressed.value !== undefined
				PropertyChanges { target: container; source: buttonProperties.pressed.value; }
			},
			State
			{
				name: "hovered"
				when: buttonState == "hovered" && buttonProperties.hovered.value !== undefined
				PropertyChanges { target: container; source: buttonProperties.hovered.value; }
			},
			State
			{
				name: "activated"
				when: buttonState == "activated" && buttonProperties.activated.value !== undefined
				PropertyChanges { target: container; source: buttonProperties.activated.value; }
			}
		]
	}
}
