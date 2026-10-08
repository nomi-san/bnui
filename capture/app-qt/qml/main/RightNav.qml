import QtQuick 2.2
import QtQuick.Layouts 1.2
import QtQuick.Window 2.2

import Phoenix 1.0 as Phoenix
import "../common"

Item
{
	id: rightNav

	property bool shouldCollapse: false
	property int borderedItemsWidth: {
		return profileButton.width +
			giftButton.width +
			voiceButton.width +
			notificationButton.width +
			friendsButton.width +
			rightBorderLine.width;
	}
	property int borderWidth: 1
	property real borderOpacity: 0.1
	property real dimmedBackgroundOpacity: 0.1
	property real hoverRectOpacity: 0.3
	property int borderHoverAnimationDuration: 100

	height: 32
	// Sum of each of the contained item's widths
	width: {
		return borderedItemsWidth + (profileButton.actualWidth - profileButton.width) +
			(offlineConnectButton.visible ? offlineConnectButton.width : 0) +
			(maintenanceIcon.visible ? maintenanceIcon.width : 0);
	}

	smooth: true

	// Maintenance alert icon
	Item
	{
		id: maintenanceIcon

		height: maintenanceIconImage.height
		width: maintenanceIconImage.width

		visible: appController.serviceAlertMonitor.hasMaintenanceMessage

		anchors.right: offlineConnectButton.left
		// Desired margin is 10, but image has 3px transparent border
		anchors.rightMargin: offlineConnectButton.visible ? 7 : 0
		anchors.verticalCenter: parent.verticalCenter

		Image
		{
			id: maintenanceIconImage

			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter

			source: "../images/maintenance-normal.png"
			opacity: 0.8

			MouseArea
			{
				id: maintenanceMouseArea

				anchors.fill: parent
				hoverEnabled: true
				enabled: true
				property string maintenanceText : appController.serviceAlertMonitor.maintenanceMessage
				onEntered:
				{
					maintenanceIconImage.opacity = 1.0
					util.showToolTip(maintenanceIcon, maintenanceIcon,
						maintenanceMouseArea.maintenanceText, Phoenix.ToolTip.ArrowUp, 0)
				}
				onExited:
				{
					maintenanceIconImage.opacity = 0.8
				}
				onClicked:
				{
					appController.serviceAlertMonitor.ShowMaintenanceDialog();
				}
			}
		}
	}

	OfflineConnectButton
	{
		id: offlineConnectButton

		visible: loginController.isOffline

		anchors.right: profileButton.left
		anchors.verticalCenter: parent.verticalCenter

		// Desired margin is 10, but ProfileButton uses significant clipping
		anchors.rightMargin: 37
	}

	Item
	{
		id: topBorderLine

		width: borderedItemsWidth
		height: borderWidth

		anchors.right: parent.right
		anchors.top: parent.top

		Rectangle
		{
			height: borderWidth

			color: "white"
			opacity: borderOpacity

			anchors.fill: parent
			// Hide behind profile avatar
			anchors.leftMargin: profileButton.width
		}
	}

	ProfileAvatar
	{
		id: profileButton

		anchors.verticalCenter: parent.verticalCenter
		anchors.right: giftButton.left
	}

	RightNavBorderedItem
	{
		id: giftButton
		stateVisible: !loginController.isOffline && inventoryController.inventoryEnabled && (inventoryController.unviewedInventoryCount > 0 || inventoryController.totalInventoryCount > 0)

		anchors.right: voiceButton.left

		loader.component: GiftButton { fadeOutDuration: borderHoverAnimationDuration }
	}

	RightNavBorderedItem
	{
		id: voiceButton
		stateVisible: socialController.voiceButton.isVisible;

		anchors.right: notificationButton.left

		loader.component: VoiceButton { fadeOutDuration: borderHoverAnimationDuration }
	}

	RightNavBorderedItem
	{
		id: notificationButton
		itemWidth: loader.item ? loader.item.width : 0 // Other bordered items / buttons are currently hardcoded to 44
		stateVisible: !loginController.isOffline && notificationController.notificationCenterEnabled
		loader.component: NotificationButton
		{
			parentWidth: notificationButton.navItemWidth
			fadeOutDuration: borderHoverAnimationDuration
		}
		anchors.right: friendsButton.left
	}

	RightNavBorderedItem
	{
		id: friendsButton
		stateVisible: !loginController.isOffline

		anchors.right: rightBorderLine.left

		// friendsButton needs a dynamic width for the friend count text
		itemWidth: loader.item ? loader.item.width : 0

		loader.component: FriendButton { fadeOutDuration: borderHoverAnimationDuration }
	}

	Rectangle
	{
		id: rightBorderLine

		width: borderWidth

		color: "white"
		opacity: borderOpacity

		anchors.right: parent.right
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		// Keep off top border
		anchors.topMargin: borderWidth
		anchors.bottomMargin: borderWidth
	}

	Item
	{
		id: bottomBorderLine

		width: borderedItemsWidth
		height: borderWidth

		anchors.right: parent.right
		anchors.bottom: parent.bottom

		Rectangle
		{
			height: borderWidth

			color: "white"
			opacity: borderOpacity

			anchors.fill: parent
			anchors.leftMargin: profileButton.width
		}
	}
}
