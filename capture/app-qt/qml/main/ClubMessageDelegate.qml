import QtQuick 2.2
import Phoenix 1.0
import QtQuick.Controls 1.4
import "../common"

NotificationBaseDelegate
{
	id: chatDelegate

	property color groupAndStreamTextColor: "#82c5ff"

	headingText: clubName
	headingTextColor: groupAndStreamTextColor
	secondaryText: streamName
	secondaryTextColor: groupAndStreamTextColor
	mainText: contextString
	avatarCategory: AvatarStore.Group
	avatarId: clubAvatarId
	timeString: ageString
	iconSource: "../images/notifications/12x10_group-chat.png"

	function showClubMessageContextMenu(centeredRect, anchorRect)
	{
		notificationController.ShowClubMessageContextMenu(centeredRect, anchorRect, dataId)
	}

	onShowContextMenu: showClubMessageContextMenu(centeredRect, anchorRect)
	onMainHitBoxClicked: notificationController.OpenStreamInSocialTab(dataId)
}
