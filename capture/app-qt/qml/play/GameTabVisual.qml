import QtQuick 2.2
import QtQuick.Layouts 1.3
import Phoenix 1.0 as Phoenix

import "../common"

Item
{
	id: container

	property bool glow: false
	property bool highlight: false

	property string text: ""
	property string icon: ""

	property real textOpacity_: highlight ? 1.0 : .5
	property double iconOpacity_: highlight ? 1.0 : .9

	SimpleLoader
	{
		id: glowLoader
		visible: glow

		anchors.fill: parent

		component: Item
		{
			Image
			{
				id: glowImg
				source: "../images/gametab_glow.png"

				property var globalCenter: {
					gameIcon.x; gameIcon.y;
					return container.mapFromItem(gameIcon, gameIcon.width / 2, gameIcon.height / 2);
				}

				opacity: 0.2
				scale: 1.0

				x: {
					gameIcon.x;
					return globalCenter.x - (glowImg.implicitWidth / 2)
				}
				y: {
					gameIcon.y;
					return globalCenter.y - (glowImg.implicitHeight / 2)
				}

				SequentialAnimation on opacity
				{
					loops: Animation.Infinite;
					running: true
					NumberAnimation { from: 0.2; to: 0.6; duration: 1000; easing.type: Easing.OutQuad; }
					NumberAnimation { from: 0.6; to: 0.2; duration: 1000; easing.type: Easing.InQuad; }
				}
			}
		}
	}

	Item
	{
		anchors.fill: parent
		Image
		{
			id: gameIcon

			anchors
			{
				left: parent.left
				verticalCenter: parent.verticalCenter
				leftMargin: 18
			}

			// Mouse hover highlight
			opacity: iconOpacity_;
			width: 34
			height: 34
			fillMode: Image.Pad

			source: util.fromCatalog(container.icon);
		}

		GameTabTitle
		{
			id: gameTitle

			anchors
			{
				top: gameIcon.top
				bottom: gameIcon.bottom
				left: gameIcon.right
				leftMargin: 8
			}

			opacity: textOpacity_;

			visible:
			{
				// We're still animating from collapsed state wait till we're done
				if (tabNavigation.isAnimating && !tabNavigation.internalIsCollapsed) {
					return gameTitle.visible;
				}
				
				return !gameController.isGameTabBarCollapsed || !tabNavigation.internalIsCollapsed
			}

			sourceText: container.text
		}
	}
}
