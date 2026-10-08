import QtQuick 2.2
import Phoenix 1.0
import "../common"

Button
{
	id: notificationButton

	width: 34 + textBorder.width + 8
	height: 32
	bSpacer: hasNotifications ? 7 : -1 		// Spacing between Bell and Counter
	backgroundImages: ButtonThemeImages {}

	y: 1 // Shift down by one pixel to align with the FriendsButton count

	property bool hasNotifications: notificationCount > 0
	property bool hasNewNotifications: notificationController.hasNewNotifications

	property int notificationCount: notificationController.notificationCount

	property alias menuParent: notificationButton.icon

	function getWindowPoint(item, x, y)
	{
		return window.mapFromItem(item, x, y)
	}

	function updateArrowPoint()
	{
		notificationButton.arrowPoint = getWindowPoint(menuParent, pointX, pointY)
	}

	property real parentWidth: 0
	onParentWidthChanged:
	{
		updateArrowPoint()
	}

	// Our arrow icon has a 1 pixel point at its halfway point and the
	// notification bell icon has an odd width, thus the -2 pixels
	property int pointX: Math.round(menuParent.width / 2) - 2
	property int pointY: menuParent.height + 9
	property point arrowPoint: getWindowPoint(menuParent, pointX, pointY)

	iconSource: "../images/notifications/bell-icon.png"

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

	//: Tooltip for button to open the Notification Center
	toolTip: qsTr("Open Notification Center");
	tipType: ToolTip.ArrowUp;

	onShowToolTip:
	{
		if (notificationController.showNotificationMenu)
			return;

		var centeredRect = util.globalGeometry(notificationButton.icon);
		var anchorRect = util.globalGeometry(notificationButton);
		anchorRect.y -= 5
		appController.ShowToolTipExplicit(centeredRect, notificationButton.toolTip, notificationButton.tipType, self, anchorRect, notificationButton.noDelay, false, true);
	}

	property bool ignoreClick: false
	property var dropdown: null
	onClicked:
	{
		if(ignoreClick)
		{
			ignoreClick = false
			return
		}

		if (dropdown && dropdown.visible)
		{
			notificationController.showNotificationMenu = false
		}
		else
		{
			notificationController.SetNotificationsSeen();
			notificationController.showNotificationMenu = true
		}
	}

	// Notification Counter outline
	Rectangle
	{
		id: textBorder
		color: hasNewNotifications ? "#cc0000" : "transparent"
		visible: hasNotifications
		height: 17
		width: hasNotifications ? textRuler.implicitWidth + 8 : 0
		radius: 3

		// Notification counter text
		Text
		{
			id: textCount
			// Counter displays at max 99 notifications
			text: notificationCount > 99 ? '99+' : notificationCount
			anchors.centerIn: parent
			font
			{
				family: fonts.regularFont.name
				pixelSize: 13
			}

			anchors.margins: 4
			color: notificationButton.effectiveTextColor
			opacity: hasNewNotifications ? 1.0 : notificationButton.effectiveTextOpacity
		}

		Text
		{
			id: textRuler
			visible: false

			text:
			{
				/* Assume zero is the widest digit */
				return (new String(textCount.text)).replace(/./g, "0");
			}

			font.family: textCount.font.family
			font.pixelSize: textCount.font.pixelSize
		}
	}

	// Notification Center Dropdown visibility stuff
	property bool notificationMenuVisible: notificationController.showNotificationMenu && notificationController.notificationCenterEnabled
	SimpleLoader
	{
		id: menuLoader
		visible: notificationMenuVisible
		component: NotificationDropdown
		{
			id: notificationDropdown

			property int rightEdgeSpacing: 45
			visible: notificationMenuVisible

			targetHorizontalSpacing: rightEdgeSpacing
			targetPoint: arrowPoint

			onAboutToHide:
			{
				// Any click in QML will close the dropdown, including a click
				// over the notificationButton which will both close the dropdown
				// and then trigger the click handler. To avoid this, we detect
				// this case and ignore the click in the handler
				ignoreClick = notificationButton.hovered
				notificationController.showNotificationMenu = false
			}

			Component.onCompleted:
			{
				dropdown = notificationDropdown
				updateArrowPoint()
			}
		}
	}
}
