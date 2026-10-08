import QtQuick 2.2
import Phoenix 1.0
import QtQuick.Controls 1.4
import "../common"

Loader
{
	id: chatLoader
	source:
	{
		var delegateString = ""
		if (notificationType == Notification.Whisper)
		{
			delegateString = "WhisperDelegate.qml";
		}
		else if (notificationType == Notification.ClubMessage)
		{
			delegateString = "ClubMessageDelegate.qml";
		}
		else if (notificationType == Notification.MultiChatMessage)
		{
			delegateString = "MultiChatMessageDelegate.qml";
		}

		return delegateString
	}

	width: parent.width
}
