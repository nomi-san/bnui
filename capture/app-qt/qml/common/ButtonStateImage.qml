import QtQuick 2.2
import QtGraphicalEffects 1.0 as Effects

Item
{
	id: container

	implicitWidth: image.implicitWidth
	implicitHeight: image.implicitHeight
	opacity: buttonProperties.normal.opacity;

	//==========================================================================
	// ButtonBehavior properties
	//==========================================================================
	property string buttonState: ""
	property variant buttonProperties: ButtonStateProperies {}

	//==========================================================================
	// Internal properties
	//==========================================================================
	property real _desaturation: 0.0

	Image
	{
		id: image

		anchors.centerIn: parent
		anchors.verticalCenterOffset: buttonProperties.normal.offsetX
		anchors.horizontalCenterOffset: buttonProperties.normal.offsetY

		source: buttonProperties.normal.value === undefined ? "" : buttonProperties.normal.value;

		layer.enabled: true
		layer.effect: Effects.Desaturate { id: effect; desaturation: container._desaturation }
	}

	StateGroup
	{
		states:
		[
			State
			{
				name: "disabled"
				when: buttonState == "disabled" && buttonProperties.disabled.opacity !== undefined
				PropertyChanges {
					target: container;
					opacity: buttonProperties.disabled.opacity;
					_desaturation: buttonProperties.disabled.desaturation;
				}
			},
			State
			{
				name: "pressed"
				when: buttonState == "pressed" && buttonProperties.pressed.opacity !== undefined
				PropertyChanges {
					target: container;
					opacity: buttonProperties.pressed.opacity;
					_desaturation: buttonProperties.pressed.desaturation;
				}
			},
			State
			{
				name: "hovered"
				when: buttonState == "hovered" && buttonProperties.hovered.opacity !== undefined
				PropertyChanges {
					target: container;
					opacity: buttonProperties.hovered.opacity;
					_desaturation: buttonProperties.hovered.desaturation;
				}
			},
			State
			{
				name: "activated"
				when: buttonState == "activated" && buttonProperties.activated.opacity !== undefined
				PropertyChanges {
					target: container;
					opacity: buttonProperties.activated.opacity;
					_desaturation: buttonProperties.activated.desaturation;
				}
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
				PropertyChanges { target: image; source: buttonProperties.disabled.value; }
			},
			State
			{
				name: "pressed"
				when: buttonState == "pressed" && buttonProperties.pressed.value !== undefined
				PropertyChanges { target: image; source: buttonProperties.pressed.value; }
			},
			State
			{
				name: "hovered"
				when: buttonState == "hovered" && buttonProperties.hovered.value !== undefined
				PropertyChanges { target: image; source: buttonProperties.hovered.value; }
			},
			State
			{
				name: "activated"
				when: buttonState == "activated" && buttonProperties.activated.value !== undefined
				PropertyChanges { target: image; source: buttonProperties.activated.value; }
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
				when: buttonState == "disabled"
				PropertyChanges
				{
					target: image;
					anchors.verticalCenterOffset: buttonProperties.disabled.offsetX;
					anchors.horizontalCenterOffset: buttonProperties.disabled.offsetY;
				}
			},
			State
			{
				name: "pressed"
				when: buttonState == "pressed"
				PropertyChanges
				{
					target: image;
					anchors.verticalCenterOffset: buttonProperties.pressed.offsetX;
					anchors.horizontalCenterOffset: buttonProperties.pressed.offsetY;
				}
			},
			State
			{
				name: "hovered"
				when: buttonState == "hovered"
				PropertyChanges
				{
					target: image;
					anchors.verticalCenterOffset: buttonProperties.hovered.offsetX;
					anchors.horizontalCenterOffset: buttonProperties.hovered.offsetY;
				}
			},
			State
			{
				name: "activated"
				when: buttonState == "activated"
				PropertyChanges
				{
					target: image;
					anchors.verticalCenterOffset: buttonProperties.activated.offsetX;
					anchors.horizontalCenterOffset: buttonProperties.activated.offsetY;
				}
			}
		]
	}
}
