import QtQuick 2.2
import Phoenix 1.0
import QtQuick.Controls 1.4
import "../common"

Loader
{
	id: inviteLoader
	source:
	{
		var delegateString = ""
		if (notificationType == Notification.FriendRequest)
		{
			delegateString = "FriendRequestDelegate.qml";
		}
		else if (notificationType == Notification.ClubInvite)
		{
			delegateString = "ClubInviteDelegate.qml";
		}
		else if(notificationType == Notification.ClubSuggestion)
		{
			delegateString = "ClubSuggestionDelegate.qml";
		}
		else if(notificationType == Notification.WhisperVoice)
		{
			delegateString = "WhisperVoiceDelegate.qml";
		}

		return delegateString;
	}

	width: parent.width
}
