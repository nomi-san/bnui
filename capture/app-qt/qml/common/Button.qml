import QtQuick 2.5
import Phoenix 1.0
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
    property int vPressedOffset: 1
    property int hPressedOffset: 1
    property int bSpacer: 5
    property real iconOffset: 0
    property string fontFamily: fonts.regularFont.name
    property string iconSource: ""
    property alias icon: icon
    property alias childItemSpacing: button.spacing
    property int buttonColumns: 2
    property int horizontalPadding: 36
    property int labelVerticalOffset: 0
    property int labelHorizontalOffset: 0
    property alias container: button
    property alias desiredTextWidth: text.desiredTextWidth
    property int fadeOutDuration: 0
    property color effectiveTextColor: textColor.normal;
    property real effectiveTextOpacity: textOpacity.normal;

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

    property real effectiveIconOpacity: iconOpacity.normal

    //==========================================================================
    // Properties
    //==========================================================================
    desiredWidth: button.width
    minumimWidth: (iconSource != "" ? icon.paintedWidth : 0) + (iconSource != "" ? bSpacer : 0) + text.desiredTextWidth + horizontalPadding * 2

    width: minumimWidth > desiredWidth ? minumimWidth : desiredWidth
    height: 38

    //==========================================================================
    // Child Objects
    //==========================================================================
    Grid
    {
        id: button
        spacing: (iconSource != "") ? bSpacer : 0
        columns: buttonColumns

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: parent.labelVerticalOffset
        anchors.horizontalCenterOffset: parent.labelHorizontalOffset

        horizontalItemAlignment: Grid.AlignHCenter
        verticalItemAlignment: Grid.AlignVCenter

        Image
        {
            id: icon

            source: iconSource
            opacity: effectiveIconOpacity

            layer.enabled: false
            layer.effect: Effects.Desaturate { desaturation: 1.0; }
        }

        Text
        {
            id: text

            property int desiredTextWidth: paintedWidth

            font.pixelSize: 13
            font.family: container.fontFamily
            opacity: container.effectiveTextOpacity
            color: container.effectiveTextColor
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

                PropertyChanges {
                    target: icon;
                    layer.enabled: true;
                }
                PropertyChanges {
                    target: container;
                    effectiveIconOpacity: iconOpacity.disabled;
                    effectiveTextOpacity: textOpacity.disabled;
                    effectiveTextColor: textColor.disabled;
                }
            },
            State
            {
                name: "down"
                when: pressed

                PropertyChanges {
                    target: button;
                    anchors.verticalCenterOffset: labelVerticalOffset + vPressedOffset;
                    anchors.horizontalCenterOffset: labelHorizontalOffset + hPressedOffset
                }
                PropertyChanges {
                    target: container;
                    effectiveIconOpacity: iconOpacity.pressed;
                    effectiveTextOpacity: textOpacity.pressed;
                    effectiveTextColor: textColor.pressed;
                }
            },
            State
            {
                name: "hovered"
                when: hovered

                PropertyChanges {
                    target: container;
                    effectiveIconOpacity: iconOpacity.hovered;
                    effectiveTextOpacity: textOpacity.hovered;
                    effectiveTextColor: textColor.hovered;
                }
            }
        ]

        transitions:
        [
            Transition
            {
                from: "hovered"; to: "*"

                NumberAnimation {
                    target: container;
                    property: "effectiveTextOpacity";
                    duration: fadeOutDuration
                }
                NumberAnimation {
                    target: container;
                    property: "effectiveIconOpacity";
                    duration: fadeOutDuration
                }
            }
        ]
    }
}
