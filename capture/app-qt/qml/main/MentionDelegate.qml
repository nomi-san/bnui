import QtQuick 2.2
import Phoenix 1.0
import "../common"

NotificationBaseDelegate
{
	id: mentionDelegate

	property color groupAndStreamTextColor: "#82c5ff"
	property bool isMultiChat: streamName.length === 0

	//: Used for Notification Center message preview;
	//: %1 is the user who sent the message
	//: %2 is the message preview that will truncate if too long
	property string messagePreviewText: qsTr("%1: %2")
		.arg(getColoredNameText(senderName))
		.arg(contextString)

	headingText: clubName
	headingTextColor: groupAndStreamTextColor
	secondaryText: streamName
	secondaryTextColor: groupAndStreamTextColor
	mainText: messagePreviewText

	avatarId: senderAvatarId

	timeString: ageString

	iconSource: "../images/notifications/12x10_group-chat.png"

	function showMentionContextMenu(centeredRect, anchorRect)
	{
		notificationController.ShowMentionContextMenu(centeredRect, anchorRect, dataId)
	}

	onShowContextMenu: showMentionContextMenu(centeredRect, anchorRect)
	onMainHitBoxClicked: notificationController.JumpToMentionInSocialTab(dataId, "NotificationCenter")
}
