import QtQuick 2.2
import Phoenix 1.0

import "../common"


Item
{
	id: topAvatarLevel

	property int avatarSize: 40
	property int avatarId: 0
	property int avatarCategory: 0
	property int secondAvatarId: 0 // Used for split avatars

	width: avatarSize
	height: avatarSize

	Loader
	{
		id: myAvatar
		anchors.fill: parent
		sourceComponent: Component
		{
			id: avatarComponent

			Image
			{
				source: avatarCategory != AvatarStore.Split
					? "image://avatarProvider/" + avatarCategory + "/" + avatarId
					: "image://avatarProvider/" + avatarCategory + "/" + avatarId + "/" + secondAvatarId
				cache: false
			}
		}
	}
}
