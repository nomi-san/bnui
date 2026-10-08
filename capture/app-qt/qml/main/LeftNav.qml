import QtQuick 2.2
import Phoenix 1.0
import QtGraphicalEffects 1.0 as Effects
import "../common"

Item
{
	id: topNavHeader

	property int implicitWidth: menuItems.x + menuItems.width + overflowMenuButton.width + 15

	property int _pageSelector_fontCapitalization: Font.AllUppercase
	property string _pageSelector_fontFamily: fonts.regularFont.name

	property int _pageSelector_fontSize_normal: 22

	property int tabImageRightMargin: 3

	BattleNetButton
	{
		id: battleNetButton
	}

	//DebugBox { anchors.fill: menuItems; color: shouldCollapse ? "red" : "green"; opacity: 0.2 }
	//DebugBox { anchors.fill: collapsedMenu; color: "purple"; opacity: 0.2}

	property bool shouldCollapse: implicitWidth > topNavHeader.width;

	Row
	{
		id: menuItems
		visible: !shouldCollapse

		property variant posRelToTopNav: topNavHeader.mapFromItem(menuItems, 0, 0)

		anchors
		{
			left: battleNetButton.right
			leftMargin: 8
			bottom: parent.bottom
			bottomMargin: 17
		}

		// TODO: Dynamically adjust spacing to contract when the width narrows
		spacing: 30

		Repeater
		{
			model: screenController.screens

			Item
			{
				id: tabItem
				width: buttonElement.width
				height: buttonElement.height

				LeftNavButton
				{
					id: buttonElement

					screenIndex: model.modelData.screenId
					screenDisplayName: model.modelData.displayName
 					screenMainImage: model.modelData.imageUrl
					screenNotificationImage: model.modelData.notificationImage
					screenNotificationText: model.modelData.notificationText
					screenHasNotification: model.modelData.hasNotification

					onClicked:
					{
						if (mouse.button === Qt.LeftButton)
						{
							screenController.SetCurrentScreen(
								buttonElement.screenIndex, "LeftNav" /* location */, true /* reloadIfCurrent */);
						}
						else if (mouse.button === Qt.RightButton)
						{
							screenController.ShowDismissScreenMenu(buttonElement.screenIndex, util.globalGeometry(buttonElement))
						}
					}

					relPosToTopNav: menuItems.posRelToTopNav.x + tabItem.x + tabItem.width - tabImageRightMargin;
				}
			}
		}
	}

	Row
	{
		id: menuItemsCollapsed
		visible: shouldCollapse

		anchors
		{
			left: battleNetButton.right
			leftMargin: 8
			bottom: topNavHeader.bottom
			bottomMargin: 17
		}

		LeftNavButton
		{
			id: navButton

			screenIndex: screenController.currentScreen
			screenDisplayName: screenController.currentScreenName
			screenMainImage: screenController.currentScreenImage
			screenNotificationImage: screenController.currentScreenNotificationImage
			screenNotificationText: screenController.currentScreenNotificationText
			screenHasNotification: screenController.currentScreenHasNotification
			menuMode: true
			relPosToTopNav: menuItems.posRelToTopNav.x + x +
				width - tabImageRightMargin;

			onClicked: { screenController.SetCurrentScreen(
				navButton.screenIndex, "LeftNav" /* location */, true /* reloadIfCurrent */); }
		}
	}

	LeftNavOverflowButton
	{
		id: overflowMenuButton

		anchors.left: shouldCollapse ? menuItemsCollapsed.right : menuItems.right
		anchors.bottom: parent.bottom
	}
}
