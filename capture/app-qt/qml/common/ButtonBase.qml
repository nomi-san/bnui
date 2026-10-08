import QtQuick 2.2
import Phoenix 1.0

Item
{
	id: container

	//==========================================================================
	// Properties Declarations
	//==========================================================================
	property int desiredWidth: button.width
	property int minumimWidth: button.width
	
	// Support tooltip for disabled button
	property alias tipType: buttonBehavior.tipType
	property alias toolTip: buttonBehavior.toolTip
	property alias noDelay: buttonBehavior.noDelay
	property alias enabled: buttonBehavior.enabled
	property alias showToolTipWhenDisabled: buttonBehavior.showToolTipWhenDisabled
	property alias acceptedButtons: buttonBehavior.acceptedButtons

	// MouseArea States
	property alias hovered: buttonBehavior.containsMouse
	property alias pressed: buttonBehavior.pressed
	property alias cursorShape: buttonBehavior.cursorShape

	property ButtonThemeImages backgroundImages: ButtonThemeImages
	{
		normal: "../controls/btn_primary_normal.png"
		hovered: "../controls/btn_primary_hover.png"
		pressed: "../controls/btn_primary_pressed.png"
		disabled: "../controls/btn_primary_disabled.png"
	}

	property ButtonThemeOpacities backgroundOpacity: ButtonThemeOpacities
	{
		normal: 1.0
		hovered: 1.0
		pressed: 1.0
		disabled: 1.0
	}

	//==========================================================================
	// Tooltip
	//==========================================================================
	function triggerToolTip(popupMode)
	{
		// If icon is set, center tooltip on icon
		if (iconSource !== "")
			util.showToolTip(container, icon, container.toolTip, container.tipType, container.noDelay, popupMode)
		// Otherwise, center on button
		else
			util.showToolTip(container, container, container.toolTip, container.tipType, container.noDelay, popupMode)
	}

	//==========================================================================
	// Signals
	//==========================================================================
	signal clicked(variant mouse)
	signal entered
	signal mousePressed
	signal showToolTip(variant popupMode)

	//==========================================================================
	// Properties
	//==========================================================================
	height: 41;
	width: desiredWidth;

	//==========================================================================
	// Child Objects
	//==========================================================================
	BorderImage
	{
		id: button

		anchors.centerIn: parent
		width: container.width
		height: container.height
		source: backgroundImages.normal
		opacity: backgroundOpacity.normal
		border.left: 5; border.top: 4
		border.right: 5; border.bottom: 5

		states:
		[
			State
			{
				name: "disabled"
				when: !buttonBehavior.enabled
				PropertyChanges { target: button; source: backgroundImages.disabled; opacity: backgroundOpacity.disabled }
			},
			State
			{
				name: "pressed"
				when: buttonBehavior.pressed
				PropertyChanges { target: button; source: backgroundImages.pressed; opacity: backgroundOpacity.pressed }
			},
			State
			{
				name: "hovered"
				when: buttonBehavior.containsMouse
				PropertyChanges { target: button; source: backgroundImages.hovered; opacity: backgroundOpacity.hovered }
			},
			State
			{
				name: ""
				PropertyChanges { target: button; source: backgroundImages.normal; opacity: backgroundOpacity.normal }
			}
		]
	}

	ButtonBehavior
	{
		id: buttonBehavior
		anchors.fill: parent
		onClicked: container.clicked(mouse)
		onEntered: container.entered()
		enabled: container.enabled
		onPressed: container.mousePressed()
		onShowToolTip: container.showToolTip(popupMode)
	}
}
