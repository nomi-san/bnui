import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

//==============================================================================
// This file should only contain layout definitions of PlayScreen
//==============================================================================
FocusScope
{
	id: playScreen
	property bool initialized: gameController.initialized

	property string defaultBackgroundColor: "#0a0d14";
	property string defaultBackgroundUrl: util.fromCatalog("resources/images/background_default.jpg", 0);
	property string backgroundColor: getBackgroundColor();
	property string backgroundUrl: getBackgroundUrl();

	focus: true

	function getBackgroundColor() {
		if (contentLoader.status != Loader.Ready || contentLoader.item.backgroundColor == "") {
			return playScreen.defaultBackgroundColor;
		}
		return contentLoader.item.backgroundColor;
	}
	function getBackgroundUrl() {
		if (contentLoader.status != Loader.Ready || contentLoader.item.backgroundUrl == "") {
			return playScreen.defaultBackgroundUrl;
		}
		return contentLoader.item.backgroundUrl;
	}

	function reload()
	{
		// If the current content page has a reload function, call it
		if (contentLoader.status == Loader.Ready
			&& contentLoader.item.reload !== undefined
			&& typeof(contentLoader.item.reload) === "function")
		{
			contentLoader.item.reload();
		}

		playView.browserDelegate.ResetBrowserUrl();
	}

	Loader
	{
		id: contentLoader
		anchors.fill: parent

		focus: true
	}

	Component
	{
		id: playScreenComponent
		PlayScreenContent
		{
			anchors.fill: parent
		}
	}

	Component
	{
		id: loadingScreenComponent
		LoadingScreenContent
		{
			anchors.fill: parent
		}
	}

	Component
	{
		id: emptyScreenComponent
		EmptyScreenContent
		{
			anchors.fill: parent
		}
	}

	Component
	{
		id: errorScreenComponent
		ErrorScreenContent
		{
			anchors.fill: parent
		}
	}

	Loader
	{
		id: debugLoader
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.topMargin: 8

		source: appController.debugComponent

		z: 100
	}

	//
	states:
	[
		State
		{
			name: "Error Screen"
			when: gameController.errorCode !== 0
			PropertyChanges {
				target: contentLoader
				sourceComponent: errorScreenComponent;
				explicit: true;
			}
		},
		State
		{
			name: "Play Screen"
			when: gameController.initialized && gameController.accountCount > 0
			PropertyChanges { 
				target: contentLoader;
				sourceComponent: playScreenComponent;
				explicit: true;
			}
		},

		State
		{
			name: "Empty Screen"
			when: gameController.initialized
			PropertyChanges {
				target: contentLoader;
				sourceComponent: emptyScreenComponent
				explicit: true;
			}
		},

		State
		{
			name: "Loading Screen"
			when: 1 == 1
			PropertyChanges {
				target: contentLoader;
				sourceComponent: loadingScreenComponent
				explicit: true;
			}
		}
	]
}

