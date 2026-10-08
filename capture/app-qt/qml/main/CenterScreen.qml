import QtQuick 2.2
import Phoenix 1.0
import "../common"

FocusScope
{
	id: centerScreen
	focus: true

	width: 1280
	height: 780

	property Item activeScreen: null;
	property NotificationBar notificationBar: notificationBar;
	property int topNavHeight: 0

	ScreenLoader
	{
		id: playScreen

		source: screenController.playScreen.qmlSource
	}

	ScreenLoader
	{
		id: socialScreen

		source: screenController.socialScreen.qmlSource
	}

	ScreenLoader
	{
		id: shopScreen

		source: screenController.shopScreen.qmlSource
	}

	ScreenLoader
	{
		id: newsScreen

		source: screenController.newsScreen.qmlSource
	}

	ScreenLoader
	{
		id: owlScreen

		source: screenController.owlScreen.qmlSource
	}

	ScreenLoader
	{
		id: blizzConScreen

		source: screenController.blizzConScreen.qmlSource
	}

	//======================================================================
	// NotificationBar
	//======================================================================
	NotificationBar
	{
		id: notificationBar

		anchors
		{
			bottom: parent.bottom
			left: parent.left
			right: parent.right
		}
	}

	onStateChanged:
	{
		centerScreen.forceActiveFocus();
	}

	states:
	[
		State
		{
			name: "play"
			when: screenController.currentScreen == ScreenController.PlayScreen

			PropertyChanges {
				target: centerScreen
				explicit: true
				activeScreen: playScreen.item
			}
			PropertyChanges {
				target: playScreen
				visible: true
				focus: true
				explicit: true
			}
			PropertyChanges {
				target: window.background;
				backgroundColor: screenController.playScreen.backgroundColor;
				backgroundImage: util.fromCatalog(screenController.playScreen.backgroundUrl);
				showVignette: true;
			}
		},

		State
		{
			name: "social"
			when: screenController.currentScreen == ScreenController.SocialScreen

			PropertyChanges {
				target: centerScreen
				explicit: true
				activeScreen: socialScreen.item
			}
			PropertyChanges {
				target: socialScreen
				visible: true
				focus: true
				explicit: true
			}
			PropertyChanges {
				target: window.background;
				backgroundColor: screenController.socialScreen.backgroundColor;
				backgroundImage: util.fromCatalog(screenController.socialScreen.backgroundUrl);
				centerImage: true;
				showVignette: false;
			}
		},

		State
		{
			name: "shop"
			when: screenController.currentScreen === ScreenController.ShopScreen

			PropertyChanges {
				target: centerScreen
				explicit: true
				activeScreen: shopScreen.item
			}
			PropertyChanges {
				target: shopScreen
				visible: true
				focus: true
				explicit: true
			}
			PropertyChanges {
				target: window.background;
				backgroundColor: screenController.shopScreen.backgroundColor;
				backgroundImage: util.fromCatalog(screenController.shopScreen.backgroundUrl);
				showVignette: false;
			}
		},

		State
		{
			name: "news"
			when: screenController.currentScreen == ScreenController.NewsScreen

			PropertyChanges {
				target: centerScreen
				explicit: true
				activeScreen: newsScreen.item
			}
			PropertyChanges {
				target: newsScreen
				visible: true
				focus: true
				explicit: true
			}
			PropertyChanges {
				target: window.background;
				backgroundColor: screenController.newsScreen.backgroundColor;
				backgroundImage: util.fromCatalog(screenController.newsScreen.backgroundUrl);
				centerImage: true;
				showVignette: true;
			}
		},

		State
		{
			name: "owl"
			when: screenController.currentScreen == ScreenController.OwlScreen

			PropertyChanges {
				target: centerScreen
				explicit: true
				activeScreen: owlScreen.item
			}
			PropertyChanges {
				target: owlScreen
				visible: true
				focus: true
				explicit: true
			}
			PropertyChanges {
				target: window.background;
				backgroundColor: screenController.owlScreen.backgroundColor;
				backgroundImage: util.fromCatalog(screenController.owlScreen.backgroundUrl);
				centerImage: true;
				showVignette: false;
			}
		},

		State
		{
			name: "blizzcon"
			when: screenController.currentScreen == ScreenController.BlizzConScreen

			PropertyChanges {
				target: centerScreen
				explicit: true
				activeScreen: blizzConScreen.item
			}
			PropertyChanges {
				target: blizzConScreen
				visible: true
				focus: true
				explicit: true
			}
			PropertyChanges {
				target: window.background;
				backgroundColor: screenController.blizzConScreen.backgroundColor;
				backgroundImage: util.fromCatalog(screenController.blizzConScreen.backgroundUrl);
				centerImage: true;
				showVignette: false;
			}
		}
	]
}
