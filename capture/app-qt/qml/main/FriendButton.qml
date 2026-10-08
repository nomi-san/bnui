import QtQuick 2.2
import Phoenix 1.0
import "../common"

Button
{
	id: friendButton

	height: 32
	// Override Button width calc
	width: icon.paintedWidth + bSpacer + text.desiredTextWidth + horizontalPadding * 2
	backgroundImages: ButtonThemeImages {}
	bSpacer: 3
	labelHorizontalOffset: -1
	horizontalPadding: 10
	desiredTextWidth: textRuler.implicitWidth

	property string _fontFamily: fonts.regularFont.name
	property int _fontSize: 13
	property int _friendCount: battlenet.onlineFriends

	iconSource:
	{
		return "../images/menu-friends-normal.png"
	}

	// Opacities are baked into alert icons since icons have a dot to which opacity should
	// not apply. We only have 1 non-alert icon however so apply opacities to it.
	iconOpacity: ButtonThemeOpacities
	{
		normal: 0.6
		hovered: 0.8
		pressed: 0.4
		disabled: 0.2
	}

	textOpacity: ButtonThemeOpacities
	{
		normal: 0.7
		hovered: 0.9
		pressed: 0.4
		disabled: 0.2
	}

	/*
	 * This ruler is used to pretend that all digits in the current font have
	 * the same width.
	 */
	Text
	{
		id: textRuler

		visible: false

		text:
		{
			var count = _friendCount > 0 ? _friendCount : "0";
			/* Assume zero is the widest digit */
			return (new String(count)).replace(/./g, "0");
		}

		font
		{
			family: _fontFamily
			pixelSize: _fontSize
		}
	}

	text
	{
		text: _friendCount

		width: textRuler.implicitWidth

		font.family: _fontFamily
		font.pixelSize: _fontSize
	}

	toolTip:
	{
		var count = battlenet.friendRequests.count;
		var tooltipText = (count > 0) ?
				//: Tooltip for the friend button (if there are pending friend requests).
				qsTr("%n pending friends request(s)", "", count) :
				//: Tooltip for the friend button (if there are no pending friend requests).
				qsTr("Open friends list");
		return tooltipText.replace(/%1/g, count.toString());
	}

	tipType: ToolTip.ArrowUp
	onShowToolTip:
	{
		var centeredRect = util.globalGeometry(friendButton.icon);
		var anchorRect = util.globalGeometry(friendButton);
		anchorRect.y -= 5;
		appController.ShowToolTipExplicit(centeredRect, friendButton.toolTip, friendButton.tipType, self, anchorRect, friendButton.noDelay, false, true);
	}
	onClicked:
	{
		var position = friendButton.mapToItem(null, 0, friendButton.height)

		var posX = self.x + position.x;
		var posY = self.y + position.y;

		windowManager.DisplayFriendsWindow(posX + friendButton.width, posY);
	}
}
