import QtQuick 2.2
import Phoenix 1.0
import QtQuick.Controls 1.4
import "../common"

NotificationBaseDelegate
{
	id: clubSuggestionDelegate

	property string senderNameText: getColoredNameText(senderName)
	property string secondNameText: getColoredNameText(secondName)

	//: Notification Center group suggestion string; 1 is name of the suggester;
	//: 2 is the name of the person being suggested
	headingText: qsTr("%1 suggested %2 to the group:").arg(senderNameText).arg(secondNameText)

	mainText: contextString
	mainTextColor: "#82c5ff"
	avatarId: senderAvatarId
	timeString: ageString
	iconSource: "../images/notifications/12x10_group.png"

	// Don't close the Notification Dropdown when main hitbox is clicked
	autoCloseNotificationCenter: false

	Rectangle
	{
		id: container
		height: inviteButtons.height
		anchors.left: parent.left
		anchors.right: parent.right
		color: "transparent"

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

			// This text is used to invite a suggested member to the group
			acceptText: qsTr("Invite")
			//: This text is used for denying a suggested group member
			declineText: qsTr("Deny")

			onAcceptButtonClicked: notificationController.AcceptClubSuggestion(dataId)
			onDeclineButtonClicked: notificationController.IgnoreClubSuggestion(dataId)
		}
	}

	onMainHitBoxClicked:
	{
		notificationController.ClubSuggestionClicked(dataId)
	}

	onShowContextMenu:
	{
		notificationController.ShowClubSuggestionContextMenu(centeredRect, anchorRect, dataId)
	}
}
