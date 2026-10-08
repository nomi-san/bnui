import QtQuick 2.2
import Phoenix 1.0
import QtQuick.Controls 2.2
import "../common"

NotificationBaseDelegate
{
	id: friendRequestDelegate

	property bool isRealIdRequest: realIdRequest
	property string senderNameText: getColoredNameText(senderName)
	property string battleTagColored: getColoredNameText(battlenet.battleTag)

	property string battleTagWithColorPrefix: "<font color=\""
		+ nameFontColor + "\">" + battlenet.battleTag

	headingText: isRealIdRequest
			//: Notification center real ID request; %1 is the BattleTag (Real ID) of the sender
			? qsTr("%1 wants to be Real ID friends").arg(senderNameText)
			//: Notification Center battle tag friend request; %1 is the BattleTag of the sender
			: qsTr("%1 wants to be friends").arg(senderNameText)

	mainText: contextString ? contextString : ""

	//: Used in Notification inline confirmation state after accepting a friend request.
	//: %1 is the friend name, potentially BattleTag or BattleTag (Real ID)
	stateText: qsTr("You are now friends with %1").arg(senderNameText)

	errorText: notificationErrorString

	//: Used in Friend Request notifications on error to decline the friend request
	errorConfirmText: qsTr("Dismiss Friend Request")

	avatarId: senderAvatarId ? senderAvatarId : 0
	timeString: ageString
	iconSource: "../images/notifications/12x10_friend-request.png"

	Rectangle
	{
		id: container
		height: container.visible
			? radioButtons.height + inviteButtons.height
			: inviteButtons.height
		anchors.left: parent.left
		anchors.right: parent.right
		color: "transparent"
		visible: !isConfirmed

		Rectangle
		{
			id: radioButtons
			visible: isRealIdRequest
			height: isRealIdRequest ? battleTagButton.height + realIdButton.height + 14: 0
			color: "transparent"

			anchors.top: container.top
			anchors.topMargin: 10
			anchors.left: parent.left
			anchors.leftMargin: 8
			anchors.right: parent.right

			InviteDelegateRadioButton
			{
				id: battleTagButton
				anchors.left: parent.left
				anchors.right: parent.right
				//: Real ID friend request notification for accepting as BattleTag: 1 will be current user's BattleTag
				text: qsTr("Accept as %1").arg(battleTagColored)
			}

			InviteDelegateRadioButton
			{
				id: realIdButton
				checked: true
				anchors.top: battleTagButton.bottom
				anchors.topMargin: 8
				anchors.left: parent.left
				anchors.right: parent.right

				// This is a wonky way of doing this, but it's to work with translation and have both the
				// BattleTag and Real ID colored appropriately
				//: Real ID friend request notification for accepting as BattleTag: 1 will be current user's BattleTag, 2 is current user's real name
				text: qsTr("Accept as %1 (%2)").arg(battleTagWithColorPrefix).arg(battlenet.accountName)
					+ "</font>"
			}
		}

		InviteAcceptButtons
		{
			id: inviteButtons
			anchors.top: radioButtons.bottom
			anchors.left: parent.left
			anchors.leftMargin: 8
			anchors.right: parent.right

			onAcceptButtonClicked: friendRequestDelegate.acceptButtonClicked()
			onDeclineButtonClicked: notificationController.DeclineFriendRequest(dataId)
		}
	}

	Behavior on height
	{
		id: shrinkAnimation
		enabled: false
		PropertyAnimation
		{
			duration: 200
			easing.type: Easing.InQuart
		}
	}

	onMainHitBoxClicked:
	{
		notificationController.FriendRequestClicked(dataId)
	}

	onShowContextMenu:
	{
		notificationController.ShowFriendRequestMenu(centeredRect, anchorRect, dataId)
	}

	onConfirmTextClicked:
	{
		notificationController.DismissNotification(notificationKey)
	}

	onErrorTextClicked:
	{
		notificationController.DismissNotification(notificationKey)
	}

	function acceptButtonClicked()
	{
		var acceptAsRealId = false;
		if (realIdRequest)
		{
			shrinkAnimation.enabled = true
			acceptAsRealId = realIdButton.checked
		}
		notificationController.AcceptFriendRequest(dataId, acceptAsRealId)
	}

}
