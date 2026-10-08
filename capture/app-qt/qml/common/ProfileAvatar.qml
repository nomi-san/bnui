import QtQuick 2.2
import QtGraphicalEffects 1.0
import Phoenix 1.0 as Phoenix

import "../common"

Item
{
	id: avatar

	property bool clickable: true
	property bool hovered: avatarContainer.containsMouse || buttonBehavior.containsMouse
	property bool pressed: avatarContainer.pressed || buttonBehavior.pressed

	property bool isOffline: loginController.isOffline
	//: Offline tooltip text
	property string offlineTooltipText : qsTr("We couldn't log you in to Battle.net. While you are offline, friends & chat will be unavailable, and you will have to log in when playing games or accessing account management.");
	//: Opening Avatar Selector tooltip text
	property string editAvatarTooltipText: qsTr("Change avatar")
	property bool automaticReconnecting: loginController.isAutomaticReconnectInProgress || loginController.fastReconnecting

	property int avatarSize: 40
	property string avatarUrl: "image://avatarProvider/0/0"

	width: userNameGrid.width + 25
	height: 32

	property int actualWidth: avatar.width + myAvatar.width - 12

	Component.onCompleted: updateAvatarUrl();

	ButtonBehavior
	{
		id: avatarContainer

		width: myAvatar.width
		height: myAvatar.height

		anchors.right: userNameGrid.left
		anchors.rightMargin: avatar.pressed ? 9 : 8
		anchors.verticalCenter: parent.verticalCenter
		anchors.fill: undefined
		enabled: !isOffline

		// Raise the Avatar above the Name grid to make the edit avatar icon show
		// up correctly when hovering over the overlap between the two
		z: 1

		Loader
		{
			id: myAvatar
			sourceComponent: isOffline ? offlineComponent : avatarComponent

			// we need to compensate for the avatarloader adding 2 pixels of empty
			// space where the border could've gone
			width: avatarSize + (isOffline ? 0 : 2)
			height: avatarSize + (isOffline ? 0 : 2)

			Component
			{
				id: avatarComponent

				Item
				{
					width: avatarSize
					height: avatarSize

					Item
					{
						id: avatarWithBackground
						anchors.fill: parent

						Image
						{
							id: avatarImage
							source: avatarUrl
							cache: false
						}
					}

					// Mask out the status icon so it is not affected by the ColorOverlay
					OpacityMask
					{
						id: biteOpacityMask
						anchors.fill: parent
						source: avatarWithBackground
						invert: true
						maskSource: Rectangle
						{
							width: avatarSize
							height: avatarSize
							color: "transparent"
							Rectangle
							{
								width: 12
								height: width
								color: "red"
								radius: width * 0.5

								anchors.bottom: parent.bottom
								anchors.right: parent.right
							}
						}
					}

					// Apply overlay on hover to indicate its editable
					ColorOverlay
					{
						id: blackOverlay
						visible: avatarContainer.containsMouse
						color: "black"
						opacity: 0.65
						anchors.fill: avatarWithBackground
						source: biteOpacityMask
					}

					Image
					{
						id: editImage
						anchors.centerIn: parent
						visible: avatarContainer.containsMouse
						source: "../images/avatar_edit_pencil.png"
						cache: false
					}
				}
			}

			Component
			{
				id: offlineComponent

				Item
				{
					width: avatarSize
					height: avatarSize

					layer.enabled: true

					Rectangle
					{
						anchors.fill: parent
						id: avatarMask

						color: "red"
						opacity: 0.5

						radius: width * 0.5
						layer.enabled: true
						visible: false
					}

					Item
					{
						anchors.fill: parent

						AnimatedImage
						{
							paused: !automaticReconnecting
							anchors.fill: parent
							source: "../images/icon_offline_reconnecting_48.gif"
						}

						Rectangle
						{
							anchors.fill: parent
							id: borderFill

							border.color: "#263040"
							border.width: 2

							color: "transparent"
						}

						layer.enabled: true
						layer.samplerName: "source"

						// mask the avatar with a circle to give it the same round appearance as normal
						// avatars
						layer.effect: ShaderEffect {
							property variant maskSource: avatarMask

							fragmentShader: "
								varying highp vec2 qt_TexCoord0;
								uniform highp float qt_Opacity;
								uniform lowp sampler2D source;
								uniform lowp sampler2D maskSource;
								void main(void) {
									gl_FragColor = texture2D(source, qt_TexCoord0.st) * (texture2D(maskSource, qt_TexCoord0.st).a) * qt_Opacity;
								}
							"
						}
					}
				}
			}
		}

		TouchToolTipItem
		{
			anchors.fill: parent
			noDelay: true
			enabled: isOffline && !loginController.showOfflineBalloon
			tipType: Phoenix.ToolTip.ArrowUp
			//: Offline auto reconnect tooltip
			toolTip: automaticReconnecting ? qsTr("Attempting to reconnect") + "\n\n" + offlineTooltipText : offlineTooltipText
		}

		tipType: Phoenix.ToolTip.ArrowUp
		onPressed: avatar.showAvatarSelect();
		toolTip: editAvatarTooltipText
		onShowToolTip: avatar.showAvatarTooltip();
	}

	Grid
	{
		// Grid so we can adjust vert/horiz anchor offets for 'button-like' effect
		id: userNameGrid

		spacing: 5

		anchors.verticalCenter: parent.verticalCenter
		anchors.verticalCenterOffset: avatar.pressed ? 1 : 0
		anchors.right: parent.right
		anchors.rightMargin: avatar.pressed ? 4 : 5

		horizontalItemAlignment: Grid.AlignHCenter
		verticalItemAlignment: Grid.AlignVCenter

		Text
		{
			id: displayName

			font.family: fonts.regularFont.name
			font.pixelSize: 13;
			color: "#ffffff";
			opacity: 0.7

			// Battletag should always be available since if it isn't, we direct users
			// to the create battletag page before showing the main window
			text: battlenet.isBattleTagAvailable ? battlenet.battleTag : qsTr("No Battletag")

			// This is required here because otherwise the mac will elide - it seems
			// mac is eliding even when the space available is equal to the space it needs.
			elide: Math.abs(implicitWidth - width) < 1 ? Text.ElideNone : Text.ElideRight
		}

		Item
		{
			id: dropdownContainer

			width: dropdown.width
			height: dropdown.height

			visible: clickable && !isOffline
			opacity: 0.6

			Image
			{
				id: dropdown
				source: "../images/arrow_down.png"

				// Push dropdown down by 1px so it matches our selected font pixelSize
				anchors.top: parent.top
				anchors.topMargin: 1
			}
		}

		states:
		[
			State
			{
				name: 'hovered'; when: avatar.hovered;
				PropertyChanges { target: displayName; opacity: 0.9; }
				PropertyChanges { target: dropdownContainer; opacity: 0.8; }
			},
			State
			{
				name: 'pressed'; when: avatar.pressed;
				PropertyChanges { target: displayName; opacity: 0.4; }
				PropertyChanges { target: dropdownContainer; opacity: 0.4; }
			}
		]

		transitions:
		[
			Transition
			{
				from: 'hovered'; to: '*'
				NumberAnimation { target: displayName; property: "opacity"; duration: borderHoverAnimationDuration }
				NumberAnimation { target: dropdownContainer; property: "opacity"; duration: borderHoverAnimationDuration }
			}
		]
	}

	Item
	{
		id: biteMaskLayer
		anchors.fill: glueRect

		Rectangle
		{
			id: biteMask
			radius: width * 0.5
			color: "red"
			opacity: isOffline ? 0.0 : 1.0 // no mask when offline

			anchors.bottom: parent.bottom
			anchors.bottomMargin: -7
			anchors.left: parent.left
			anchors.leftMargin: -2

			width: 16
			height: width
		}

		visible: false
		layer.enabled: true
		clip: true
	}

	Item
	{
		id: glueRect

		anchors.fill: parent
		anchors.rightMargin: -1 // reach over into next item
		z: -2

		Rectangle
		{
			id: hoverRect
			color: "transparent"

			visible: opacity != 0.0

			anchors.fill: parent
			border.color: "#fff"
			border.width: 1

			opacity: 0.0
		}

		Rectangle
		{
			id: dimmedBackground

			anchors.fill: parent
			anchors.rightMargin: 1
			anchors.topMargin: 1
			anchors.bottomMargin: 1

			color: "#000"
			opacity: dimmedBackgroundOpacity
		}

		Rectangle
		{
			id: topBorder

			height: 1
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.rightMargin: 1
			color: "#fff"
			opacity: borderOpacity
		}

		Rectangle
		{
			id: bottomBorder

			height: 1
			anchors.bottom: parent.bottom
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.rightMargin: 1

			color: "#fff"
			opacity: borderOpacity
		}

		layer.enabled: true
		layer.samplerName: "source"

		// mask the "bite" of the avatar out from the background.
		// the biteMaskLayer must have the same rect as this so that the
		// mask can be properly applied
		layer.effect: ShaderEffect {
			property variant maskSource: biteMaskLayer

			fragmentShader: "
				varying highp vec2 qt_TexCoord0;
				uniform highp float qt_Opacity;
				uniform lowp sampler2D source;
				uniform lowp sampler2D maskSource;
				void main(void) {
					gl_FragColor = texture2D(source, qt_TexCoord0.st) * (1.0 - texture2D(maskSource, qt_TexCoord0.st).a) * qt_Opacity;
				}
			"
		}
	}

	ButtonBehavior
	{
		id: buttonBehavior

		anchors.fill: parent
		z: 0

		visible: clickable && !isOffline
		onPressed: avatar.handlePressed();
		enabled: !isOffline;

		toolTip: {
			return "<center><span style=\"color:rgba(130, 197, 255, 100%)\">" + battlenet.battleTag + "</span>" +
				"<span style=\"color:rgba(255, 255, 255, 50%)\">#" + battlenet.battleTagId + "</span>" +
				"<br>" + qsTr("Change your online status") + "</center>";
		}

		tipType: Phoenix.ToolTip.ArrowUp
		onShowToolTip: avatar.showTooltip();
	}

	Behavior on width
	{
		SequentialAnimation
		{
			PropertyAction { target: avatar; property: "clip"; value: true }
			NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
			PropertyAction { target: avatar; property: "clip"; value: false }
		}
	}

	StateGroup
	{
		states:
		[
			State
			{
				name: "hovered"; when: profileButton.hovered || profileButton.pressed
				PropertyChanges { target: hoverRect; opacity: hoverRectOpacity  }
			}
		]

		transitions: Transition
		{
			from: "hovered"; to: "*"
			NumberAnimation { target: hoverRect; property: "opacity"; duration: borderHoverAnimationDuration }
		}
	}

	function showTooltip()
	{
		var centeredRect = util.globalGeometry(dropdownContainer);
		var anchorRect = util.globalGeometry(buttonBehavior);
		anchorRect.y -= 4;
		appController.ShowToolTipExplicit(centeredRect, buttonBehavior.toolTip, buttonBehavior.tipType, self, anchorRect, buttonBehavior.noDelay, false, true);
	}

	function showAvatarSelect()
	{
		profileController.OpenAvatarSelectWindow("ProfileAvatar");
	}

	function showAvatarTooltip()
	{
		var centeredRect = util.globalGeometry(avatarContainer);
		var anchorRect = util.globalGeometry(avatarContainer);
		anchorRect.y -= 8;
		appController.ShowToolTipExplicit(centeredRect, editAvatarTooltipText, buttonBehavior.tipType, self, anchorRect, buttonBehavior.noDelay, false, true);
	}

	function handlePressed()
	{
		var anchorRect = util.globalGeometry(buttonBehavior);
		var centeredRect = util.globalGeometry(dropdownContainer);
		// 10px between bottom of Rectangle and top of tooltip
		anchorRect.y -= 5;
		// Arrows are centered with each other (x offset by 1 so we move to match pressed state)
		centeredRect.y = 1;
		centeredRect.x += 1;
		appController.ShowStatusMenu(centeredRect, anchorRect);
	}

	function updateAvatarUrl()
	{
		var url = battlenet.avatarUrl;
		if (url == avatarUrl)
			avatarUrl = ""; // In case URL is same but the avatar picture has changed.
		avatarUrl = url;
	}

	Connections
	{
		target: battlenet
		function onAvatarUrlChanged() {
			updateAvatarUrl();
		}
	}
}
