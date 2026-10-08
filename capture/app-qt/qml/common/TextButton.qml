import QtQuick 2.2

Item
{
	id: container

	//==========================================================================
	// Properties Declarations
	//==========================================================================
	property int desiredWidth: text.paintedWidth
	property int minumimWidth: text.paintedWidth
	property alias text: text
	property int fontSize: 12

	// MouseArea States
	property alias hovered: buttonBehavior.containsMouse
	property alias pressed: buttonBehavior.pressed

	// Tooltip
	property alias tipType: buttonBehavior.tipType
	property alias toolTip: buttonBehavior.toolTip
	property alias noDelay: buttonBehavior.noDelay

	property ButtonThemeOpacities textOpacity: ButtonThemeOpacities
	{
		normal: 0.9
		hovered: 1
		pressed: 0.8
		disabled: 0.1
	}

	property ButtonThemeColors textColor: ButtonThemeColors
	{
		normal: "#ffffff"
		hovered: "#ffffff"
		pressed: "#ffffff"
		disabled: "#ffffff"
	}

	//==========================================================================
	// Signals
	//==========================================================================
	signal clicked
	signal entered
	signal showToolTip()

	//==========================================================================
	// Properties
	//==========================================================================
	height: text.paintedHeight
	width: minumimWidth > desiredWidth ? minumimWidth : desiredWidth

	//==========================================================================
	// Child Objects
	//==========================================================================
	Text
	{
		id: text
		anchors.verticalCenter: parent.verticalCenter
		anchors.horizontalCenter: parent.horizontalCenter
		font.pixelSize: fontSize
		font.family: fonts.regularFont.name
		opacity: textOpacity.normal
		color: textColor.normal
		smooth: parent.smooth
		style: Text.Normal
		styleColor: "#00adef"

		Behavior on opacity { NumberAnimation { duration: 200 } }
	}

	ButtonBehavior
	{
		id: buttonBehavior
		anchors.fill: parent
		onClicked: container.clicked()
		onEntered: container.entered()
		onShowToolTip: container.showToolTip()
		enabled: container.enabled
	}

	//==========================================================================
	// States
	//==========================================================================
	StateGroup
	{
		states:
		[
			State
			{
				name: "disabled"
				when: !enabled

				PropertyChanges { target: text; opacity: textOpacity.disabled; color: textColor.disabled; }
			},
			State
			{
				name: "down"
				when: pressed
				PropertyChanges { target: text; opacity: textOpacity.pressed; color: textColor.pressed; anchors.verticalCenterOffset: 1; anchors.horizontalCenterOffset: 1}
			},
			State
			{
				name: "hovered"
				when: hovered
				PropertyChanges { target: text; opacity: textOpacity.hovered; color: textColor.hovered; }

			},
			State
			{
				name: ""
				PropertyChanges { target: text; opacity: textOpacity.normal; color: textColor.normal; }
			}
		]
	}
}
