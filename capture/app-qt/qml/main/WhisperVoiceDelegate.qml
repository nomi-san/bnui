import QtQuick 2.2
import Phoenix 1.0
import QtQuick.Controls 1.4
import "../common"

NotificationBaseDelegate
{
	id: whisperVoiceDelegate

	property string senderNameText: getColoredNameText(senderName)
	property string senderNameCanceledText: getColoredNameText(senderName + ":")
	property bool isCanceled: notificationState == Notification.Canceled


	headingText: isCanceled
		? senderNameCanceledText
		//: Header for 1-1 Voice Notification in the NotificationCenter
		: qsTr("Incoming Voice Chat")

	mainText: isCanceled
		//: 1-1 Voice Notification context string; indicates the voice chat was missed
		//: n is the number of missed calls
		? qsTr("%n Missed voice chat(s)", "", rollupCount)
		//: 1-1 Voice Notification context string; 1 will be the name of the person requesting the voice chat
		: qsTr("%1 wants to voice chat with you").arg(senderNameText)

	avatarId: senderAvatarId
	timeString: ageString
	iconSource: "../images/notifications/12x10_voice.png"

	Rectangle
	{
		id: container
		height: visible ? inviteButtons.height : 0
		anchors.left: parent.left
		anchors.right: parent.right
		color: "transparent"
		visible: notificationState == Notification.Default

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

			//: Used for joining a 1 to 1 voice call from a Notification
			acceptText: qsTr("Join")

			//: Used for ignoring a 1 to 1 voice call from a Notification
			declineText: qsTr("Ignore")

			onAcceptButtonClicked: notificationController.JoinWhisperVoice(dataId)
			onDeclineButtonClicked: notificationController.IgnoreWhisperVoice(dataId)
		}
	}

	onMainHitBoxClicked: notificationController.OpenChatForWhisperVoice(senderId)
	onShowContextMenu: notificationController.ShowWhisperVoiceContextMenu(centeredRect, anchorRect, dataId)
}
