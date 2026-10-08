import Phoenix 1.0
import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0 as Effects

import "../common"

Item
{
	id: textButton

	//==========================================================================
	// Properties Declarations
	//==========================================================================
	// nav button
	property int screenIndex: 0
	property alias screenDisplayName: text.text
	property string screenMainImage: ""
	property string screenNotificationImage: ""
	property string screenNotificationText: ""
	property bool screenHasNotification: false
	property bool menuMode: false

	property int desiredWidth: text.paintedWidth
	property int minumimWidth: text.paintedWidth
	property alias text: text
	property int fontSize: _pageSelector_fontSize_normal

	// MouseArea States
	property alias hovered: buttonBehavior.containsMouse
	property bool pressed: buttonBehavior.pressedButtons & Qt.LeftButton

	// Tooltip
	property alias tipType: buttonBehavior.tipType
	property alias toolTip: buttonBehavior.toolTip
	property alias noDelay: buttonBehavior.noDelay
	property real relPosToTopNav: 0.0

	property ButtonThemeOpacities textOpacity: ButtonThemeOpacities
	{
		normal: 0.7
		hovered: 1.0
		pressed: 0.5
		disabled: 0.1
	}

	property ButtonThemeOpacities selectedOpacity: ButtonThemeOpacities
	{
		normal: 1.0
		hovered: 1.0
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
	signal clicked(variant mouse)
	signal entered


	//==========================================================================
	// Properties
	//==========================================================================
	height: text.paintedHeight
	width: textContainer.width

	anchors.verticalCenter: parent.verticalCenter

	property bool shouldDisplayNotification: (menuMode === shouldCollapse) &&
		screenHasNotification;

	// Using "Image" for still images is nothing but a workaround.
	// If a still image is initially loaded to "AnimatedImage",
	// AnimatedImage won't animate even if mng/gif is loaded later.
	// Note that it works fine if mng/gif is loaded initially and
	// switching png <-> mng/gif back and forth.

	property bool isAnimated: {
		return (
			screenNotificationImage.endsWith(".mng") ||
			screenNotificationImage.endsWith(".mng") ||
			screenNotificationImage.endsWith(".gif")
		);
	}

	property bool showNotificationImage: shouldDisplayNotification &&
		screenNotificationImage !== ""
	property bool showNotificationText: shouldDisplayNotification &&
		screenNotificationText !== "" && screenNotificationImage === ""

	//==========================================================================
	// Child Objects
	//==========================================================================

	AnimatedImage
	{
		visible: showNotificationImage && isAnimated
		paused: !self.isActive || !visible
		source: visible ? screenNotificationImage : ""
		parent: topNavHeader
		anchors.bottom: parent.bottom
		x: relPosToTopNav
	}

	Image
	{
		visible: showNotificationImage && !isAnimated
		source: visible ? screenNotificationImage : ""
		parent: topNavHeader
		anchors.bottom: parent.bottom
		x: relPosToTopNav
	}

	Item
	{
		id: textContainer

		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		height: text.height

		width: {
			var calcWidth = 0;
			if (screenMainImage.length > 0) {
				calcWidth += mainImage.width;
			}
			else if (text) {
				calcWidth += text.paintedWidth;
			}
			return calcWidth;
		}

		Text
		{
			id: text
			// Prefer to show the image if we have one, and never show text at the same time.
			visible: screenMainImage.length == 0;

			anchors.left: textContainer.left
			anchors.verticalCenter: parent.verticalCenter
			width: paintedWidth + 10

			font.pixelSize: fontSize
			font.family: _pageSelector_fontFamily
			font.capitalization: _pageSelector_fontCapitalization
			opacity: textOpacity.normal
			color: textColor.normal
			smooth: true
			style: Text.Normal
			styleColor: "#00adef"

			layer.enabled: false
			layer.effect: Effects.Glow
			{
				radius: 20
				samples: radius * 2
				spread: 0.15
				fast: true
				transparentBorder: true
			}
			Behavior on opacity { NumberAnimation { duration: 200 }}
		}

		Image
		{
			id: mainImage
			anchors.left: textContainer.left
			anchors.verticalCenter: parent.verticalCenter
			visible: screenMainImage.length > 0
			opacity: textOpacity.normal
			smooth: true
			source: screenMainImage
			width: sourceSize.width

			layer.enabled: false
			layer.effect: Effects.Glow
			{
				radius: 20
				color: "#80FFFFFF"
				samples: radius * 2
				spread: 0.15
				fast: true
				transparentBorder: true
			}

			Behavior on opacity { NumberAnimation { duration: 200 }}
		}
	}

	Item
	{
		id: notificationAnchor

		width: textContainer.width
		height: textContainer.height

		anchors.left: textContainer.left
		anchors.top: textContainer.top
	}

	Rectangle
	{
		id: notificationText
		visible: showNotificationText

		color: "#ff0000"
		smooth: true
		radius: 3

		width: textNotification.width + 9
		height: 14

		anchors.top: notificationAnchor.bottom
		anchors.topMargin: -2
		anchors.horizontalCenter: notificationAnchor.horizontalCenter

		Text
		{
			id: textNotification

			text: screenNotificationText
			color: textColor.normal
			font.bold: true
			font.pixelSize: 11
			font.family: fonts.regularFont.name

			anchors.horizontalCenter: notificationText.horizontalCenter
			anchors.verticalCenter: notificationText.verticalCenter
			anchors.horizontalCenterOffset: -1
		}
	}

	ButtonBehavior
	{
		id: buttonBehavior
		anchors.fill: parent
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		onClicked: textButton.clicked(mouse)
		onEntered: textButton.entered()
		enabled: textButton.enabled
		tipType: ToolTip.ArrowUp
		noDelay: true

		onShowToolTip:
		{
			util.showToolTip(textButton, textButton,
				textButton.toolTip, textButton.tipType, textButton.noDelay);
		}
	}

	//==========================================================================
	// States
	//==========================================================================
	StateGroup
	{
		id: buttonStates
		states:
		[
			State
			{
				name: "disabled"
				when: !enabled

				PropertyChanges {
					target: text;
					opacity: textOpacity.disabled;
					color: textColor.disabled;
				}
				PropertyChanges {
					target: mainImage;
					opacity: textOpacity.disabled;
				}
			},
			State
			{
				name: "down"
				when: pressed
				PropertyChanges {
					target: textContainer;
					anchors.verticalCenterOffset: 1;
					anchors.leftMargin: 1;
				}
				PropertyChanges {
					target: text
					opacity: textOpacity.pressed;
					color: textColor.pressed;
				}
				PropertyChanges {
					target: mainImage;
					opacity: textOpacity.pressed;
				}
			},
			State
			{
				name: "hovered"
				when: hovered

				PropertyChanges {
					target: text;
					opacity: textOpacity.hovered;
					color: textColor.hovered;
				}

				PropertyChanges {
					target: mainImage;
					opacity: textOpacity.hovered;
				}
			}
		]
	}

	StateGroup
	{
		id: selectionStates

		states:
		[
			State
			{
				name: "Selected"
				when: textButton.screenIndex === screenController.currentScreen

				PropertyChanges {
					target: textButton;
					textOpacity: selectedOpacity;
				}
				PropertyChanges {
					target: text;
					layer.enabled: true;
				}
				PropertyChanges {
					target: mainImage;
					layer.enabled: true;
				}
			}
		]
	}
}
