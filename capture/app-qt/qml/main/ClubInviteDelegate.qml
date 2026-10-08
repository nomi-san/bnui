import QtQuick 2.2
import Phoenix 1.0
import QtQuick.Controls 1.4
import "../common"

NotificationBaseDelegate
{
	id: clubInviteDelegate

	property string senderNameText: getColoredNameText(senderName)

	//: Notification Center group invite string; 1 is either real name or BattleTag
	headingText: qsTr("%1 invited you to join the group:").arg(senderNameText)

	mainText: contextString
	mainTextColor: "#82c5ff"
	avatarCategory: AvatarStore.Group
	avatarId: clubAvatarId
	timeString: ageString
	iconSource: "../images/notifications/12x10_group.png"

	//: Shown after accepting a group invite
	stateText: qsTr("You are now a member of %1").arg(getColoredNameText(contextString))

	errorText: notificationErrorString

	//: Used to decline ClubInvites on error
	errorConfirmText: qsTr("Dismiss Group Invite")

	Rectangle
	{
		id: container
		height: inviteButtons.height
		anchors.left: parent.left
		anchors.right: parent.right
		color: "transparent"
		visible: !isConfirmed

		InviteAcceptButtons
		{
			id: inviteButtons
			anchors
			{
				top: container.top
				topMargin: 9
				left: parent.left
				leftMargin: 7
				right: parent.right
			}
			color: "transparent"

			onAcceptButtonClicked: notificationController.AcceptClubInvite(dataId)
			onDeclineButtonClicked: notificationController.DeclineClubInvite(dataId)
		}
	}

	onMainHitBoxClicked:
	{
		notificationController.ShowClubInviteInfo(dataId)
	}

	onShowContextMenu:
	{
		notificationController.ShowClubInviteMenu(centeredRect, anchorRect, dataId)
	}

	onConfirmTextClicked:
	{
		notificationController.DismissNotification(notificationKey)
	}

	onErrorTextClicked:
	{
		notificationController.DismissNotification(notificationKey)
	}
}
