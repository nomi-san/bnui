import QtQuick 2.2
import Phoenix 1.0
import QtQuick.Controls 1.4
import "../common"

NotificationBaseDelegate
{
	id: chatDelegate

	headingText: senderName
	headingTextColor: "#82c5ff"
	mainText: contextString
	avatarId: senderAvatarId
	timeString: ageString
	iconSource: "../images/notifications/12x10_chat.png"

	function showChatContextMenu(centeredRect, anchorRect)
	{
		notificationController.ShowWhisperContextMenu(centeredRect, anchorRect, dataId)
	}

	onShowContextMenu: showChatContextMenu(centeredRect, anchorRect)
	onMainHitBoxClicked: notificationController.WhisperClicked(senderId)
}
