import QtQuick 2.2
import QtGraphicalEffects 1.0 as Effects

ButtonBase
{
    id: container

    //==========================================================================
    // Properties Declarations
    //==========================================================================
    default property alias childItems: button.data
    property alias text: text
    property alias iconDistance: button.spacing
    property int fontSize: 13
	property real vOffset: 0
	property real hOffset: 0
	property real iconOffset: 0
    property string fontFamily: fonts.regularFont.name
    property string iconSource: ""
    property alias icon: icon
    property alias childItemSpacing: button.spacing
    property alias container: button

    property ButtonThemeOpacities iconOpacity: ButtonThemeOpacities
	{
		normal: 0.8
		hovered: 1
		pressed: 0.6
		disabled: 0.1
	}

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
    // Properties
    //==========================================================================

	width: 110
	height: 77

    //==========================================================================
    // Child Objects
    //==========================================================================
	Column
    {
        id: button
		anchors.centerIn: parent
		anchors.horizontalCenterOffset: hOffset
		anchors.verticalCenterOffset: vOffset
		spacing: 3

		Image
		{
			id: icon;

			source: iconSource

			anchors.horizontalCenter: parent.horizontalCenter
			anchors.horizontalCenterOffset: iconOffset

			opacity: iconOpacity.normal

			layer.enabled: false
			layer.effect: Effects.Desaturate { desaturation: 1.0; }
		}

        Text
        {
            id: text
            font.pixelSize: 12
            font.family: container.fontFamily
            opacity: textOpacity.normal
			text: container.text.text
			color: textColor.normal
        }
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
				PropertyChanges { target: icon; layer.effect: true; }
            },
            State
            {
                name: "down"
                when: pressed
                PropertyChanges { target: text; opacity: textOpacity.pressed; color: textColor.pressed; }
                PropertyChanges	{ target: button; anchors.verticalCenterOffset: vOffset+1; anchors.horizontalCenterOffset: hOffset+1 }
				PropertyChanges { target: icon; opacity: iconOpacity.pressed; }
            },
            State
            {
                name: "hovered"
                when: hovered
                PropertyChanges { target: text; opacity: textOpacity.hovered; color: textColor.hovered; }
				PropertyChanges { target: icon; opacity: iconOpacity.hovered; }

            },
            State
            {
                name: ""
                PropertyChanges { target: text; opacity: textOpacity.normal; color: textColor.normal; }
				PropertyChanges { target: icon; opacity: iconOpacity.normal; }
            }
        ]
    }
}
