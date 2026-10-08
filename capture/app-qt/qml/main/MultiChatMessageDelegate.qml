import QtQuick 2.2
import Phoenix 1.0
import QtQuick.Controls 1.4
import "../common"

NotificationBaseDelegate
{
	id: multiChatDelegate

	property string senderNameColored: getColoredNameText(senderName)

	headingText: senderNameColored

	mainText: contextString
	avatarCategory: AvatarStore.Split
	avatarId: senderAvatarId
	secondAvatarId: otherAvatarId
	timeString: ageString
	iconSource: "../images/notifications/12x10_group-chat.png"

	function showMultiChatContextMenu(centeredRect, anchorRect)
	{
		notificationController.ShowMultichatMessageContextMenu(centeredRect, anchorRect, dataId)
	}

	onShowContextMenu: showMultiChatContextMenu(centeredRect, anchorRect)
	onMainHitBoxClicked: notificationController.OpenStreamInSocialTab(dataId)
}
