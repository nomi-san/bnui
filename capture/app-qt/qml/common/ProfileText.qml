import QtQuick 2.2
import Phoenix 1.0
import QtGraphicalEffects 1.0 as Effects
import "../common"

Item
{
	id: avatar

	property bool displayRealName: true
	property int maximumWidth: 224

	property variant identity
	property bool clickable: false
	property bool hovered: false
	property bool avatarSize: false

	// implicitWidth (or desiredWidth) carries our desired width from the
	// inside out.  We then limit it here to be no more than maximumWidth and
	// pass it down to the children via width values.
	width: Math.min(maximumWidth, implicitWidth)
	implicitWidth: userName2.width
	implicitHeight: userName2.height

	Item
	{
		id: userName2

		anchors.left: parent.left

		implicitWidth: (displayName.implicitWidth
					   + (realName.visible ? realName.anchors.leftMargin + realName.implicitWidth : 0)
					   + (dropdown.implicitWidth + 6))
		height: displayName.height

		Effects.Glow
		{
			id: bloomEffect

			property bool glow: false
			visible: glow && source.width > 0 && source.height > 0
			anchors.fill: displayName
			anchors.centerIn: displayName

			// Effect properties
			source: displayName
			radius: displayName.font.pixelSize
			samples: bloomEffect.radius * 2
			spread: 0.2
			fast: true
			transparentBorder: true
		}

		Text
		{
			id: displayName

			width: Math.min(parent.width, implicitWidth)

			font.family: fonts.regularFont.name
			font.pixelSize: 18;
			color: "#ffffff";
			opacity: avatar.hovered ? 1.0 :0.9
			text: identity.battleTag

			// This is required her ebecause otherwise the mac will elide - it seems
			// mac is eliding even when the space available is equal to the space it needs.
			elide: Math.abs(implicitWidth - width) < 1 ? Text.ElideNone : Text.ElideRight
		}

		Text
		{
			id: realName

			visible: displayRealName

			anchors.left: displayName.right
			anchors.leftMargin: 6
			anchors.right: parent.right
			anchors.baseline: displayName.baseline

			font.family: fonts.regularFont.name
			font.pixelSize: 13;
			color: "#92e2ff";
			opacity: avatar.hovered ? 1.0 : 0.7
			text: identity.accountName
			elide: Text.ElideRight
		}

		Image
		{
			id: dropdown
			x: displayName.width + 6
			y: 8
			visible: clickable

			source: "../images/arrow_down.png"
			opacity: avatar.hovered ? 1.0 : 0.8
		}
	}

	ButtonBehavior
	{
		id: buttonBehavior
		onPressed:
		{
			if (clickable)
			{
				var anchorRect = util.globalGeometry(avatar);
				var centeredRect = util.globalGeometry(dropdown);
				anchorRect.height += 3;
				centeredRect.height = 1;
				appController.ShowStatusMenu(centeredRect, anchorRect);
			}
			else
			{
				displayToolTip(true);
			}
		}
		onHoveredChanged:
		{
			avatar.hovered = buttonBehavior.containsMouse
		}

		function displayToolTip(popupMode)
		{
			util.showToolTip(buttonBehavior,
				displayName,
				buttonBehavior.toolTip,
				buttonBehavior.tipType,
				true,
				popupMode);
		}

		toolTip: {
			return "<span style=\"color:rgba(130, 197, 255, 100%)\">" + identity.battleTag + "</span>" +
				"<span style=\"color:rgba(255, 255, 255, 50%)\">#" + identity.battleTagId + "</span>" +
				"<br><span style=\"color:rgba(255, 255, 255, 50%)\">" + qsTr("Connected to:") + " </span>" +
				"<span style=\"color:rgba(130, 197, 255, 100%)\">" + loginController.loginRegion + "</span>";
		}

		tipType: ToolTip.ArrowUp

		onShowToolTip: displayToolTip(false);

	}

	states:
	[
		State
		{
			name: "Hover"
			when: buttonBehavior.containsMouse

			PropertyChanges { target: bloomEffect; glow: true; }
		}
	]
}
