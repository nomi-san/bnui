import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"
import "../common/util.js" as Util


FocusScope
{
	id: playScreenContent

	property variant view: playView

	property string backgroundColor: view.backgroundColor
	property string backgroundUrl: view.backgroundUrl

	property int _screen_mode_normal: 0
	property int _screen_mode_starter: 1
	property int _screen_mode_announcement: 2
	property variant screenMode: view.screenMode

	onHeightChanged: updateLayout()
	onVisibleChanged: updateLayout()
	Component.onCompleted: updateLayout()

	function updateLayout()
	{
		var availableSpace = height - middleBar.minHeight;

		// Determine BottomBar Height
		// Show region/account label if possible, only hide it when phoenix is in its smallest size.
		var shrinkBottomBar = availableSpace < (bottomBar.maxHeight + topBar.minHeight)
		bottomBar.height = shrinkBottomBar ? bottomBar.minHeight : bottomBar.maxHeight;
		availableSpace -= bottomBar.height;

		// Determine TopBar Height
		var shrinkTopBar = availableSpace < topBar.maxHeight;
		topBar.height = shrinkTopBar ? topBar.minHeight : topBar.maxHeight;
	}

	//==========================================================================
	// layout properties
	//==========================================================================

	focus: true

	Rectangle
	{
		id: backgroundFill

		color: "black"
		opacity: 0.8
		anchors.fill: parent
		visible: false

		z: -2
	}

	//==========================================================================
	// TabNavigation
	//==========================================================================
	GameTabList
	{
		id: tabNavigation
		property int maxWidth: 220
		property int minWidth: 70

		width: gameController.isGameTabBarCollapsed ? minWidth : maxWidth;
		property bool internalIsCollapsed
		property bool isAnimating: false

		Component.onCompleted: {
			internalIsCollapsed = gameController.isGameTabBarCollapsed;
		}
		Behavior on width
		{
			NumberAnimation {
				id: slideAnimation
				duration: 175;
				onRunningChanged:
				{
					if(!slideAnimation.running)
					{
						// If we should change our state
						if (gameController.isGameTabBarCollapsed != tabNavigation.internalIsCollapsed) {
							tabNavigation.internalIsCollapsed = !tabNavigation.internalIsCollapsed;
						}
						tabNavigation.isAnimating = false
					} else {
						tabNavigation.isAnimating = true;
					}
				}
			}

		}
		// layout properties
		anchors
		{
			top: parent.top
			bottom: parent.bottom
			left: parent.left
			leftMargin: 0
			bottomMargin: util.isMac() ? 0 : 1
		}

		backgroundOpacity: 0.15

		z: 3
	}

	//==========================================================================
	// GameScreen
	//==========================================================================
	Item
	{
		id: gameScreen
		visible: view.valid

		z: 1

		// layout properties
		anchors
		{
			left: tabNavigation.right
			top: parent.top
			bottom: parent.bottom
			right: parent.right
		}

		//======================================================================
		// TopBar
		//======================================================================
		TopBar
		{
			id: topBar

			view: playScreenContent.view
			visible: true

			/*Rectangle
			{
				color: "yellow"
				opacity: 0.2

				anchors.fill: parent
			}/**/

			Behavior on height { NumberAnimation { duration: 150; } }
			anchors
			{
				top: parent.top
				left: parent.left
				right: parent.right
			}
		}

		//======================================================================
		// MiddleBar
		//======================================================================
		MiddleBar
		{
			id: middleBar
			view: playScreenContent.view

			/*Rectangle
			{
				color: "green"
				opacity: 0.2

				anchors.fill: parent
			}/**/

			// layout properties
			anchors
			{
				top: topBar.bottom
				bottom: bottomBar.top
				left: parent.left
				right: parent.right
			}

			// Represent Region Selector Rect in PlayScreen web page
			Item
			{
				id: anchorItem

				property variant anchorRect: playView.browserDelegate.anchorRect;

				// Hide anchorItem when the rect isn't valid
				visible: anchorRect.width > 0 && anchorRect.height > 0
					&& playScreenContent.screenMode === _screen_mode_starter
					&& view.family.regionWarningType !== Phoenix.GameFamily.NoWarning

				property int desiredX: visible ? anchorRect.x : 0;

				x: middleBar.mapToItem(window, desiredX, 0).x < window.width ? desiredX : middleBar.mapFromItem(window, window.width, 0).x;
				y: anchorRect.y
				width: anchorRect.width
				height: anchorRect.height
			}

			RegionSwitchBalloon
			{
				anchorTarget: anchorItem
				productFamily: view.family

				tipType: Phoenix.ToolTip.ArrowRight

				// When this is about to be clipped, push it inside
				property int padding: 15

				x: anchorItem.x - width - padding

				// Only show this for starter mode. Separate RegionSwitchWarning loader exists inside of bottombar
				visible: anchorItem.visible
			}

			// Should be behind of top and bottom bar
			// TopLayer has dismissable tooltip for "Redeem a game code" and BottomLayer has RegionSwitchBalloon
			z: -1
		}

		//======================================================================
		// BottomBar
		//======================================================================
		BottomBar
		{
			id: bottomBar
			view: playScreenContent.view

			/*Rectangle
			{
				color: "blue"
				opacity: 0.2

				anchors.fill: parent
			}/**/

			// layout properties
			// Height is defined in the bottom bar
			anchors
			{
				bottom: parent.bottom
				left: parent.left
				right: parent.right
			}
		}

		states:
		[
			State
			{
				name: "Starter Edition"
				when: playScreenContent.screenMode === _screen_mode_starter

				PropertyChanges { target: topBar; visible: true; }
				PropertyChanges { target: bottomBar; visible: false; }
				// Minimum height of starter page to ensure ESRB logo is visible.
				PropertyChanges { target: middleBar; visible: true; minHeight: 435; }

				// Switching state changes height of bottomBar. Call updateLayout after
				// the minHeight, maxHeight property is updated.
				StateChangeScript { script: playScreenContent.updateLayout() }
			},
			State
			{
				name: "Announcement"
				when: playScreenContent.screenMode === _screen_mode_announcement

				// top and bottom bar are not visible in this state
				PropertyChanges { target: bottomBar; visible: false; }
				PropertyChanges { target: topBar; visible: false; }
				PropertyChanges { target: middleBar; visible: true; }

				// add background fill
				PropertyChanges { target: backgroundFill; visible: true; }
				PropertyChanges { target: tabNavigation; backgroundOpacity: 0.0; }

				AnchorChanges
				{
					target: middleBar
					anchors.top: gameScreen.top
					anchors.bottom: gameScreen.bottom
				}

				// Switching state changes height of bottomBar. Call updateLayout after
				// the minHeight, maxHeight property is updated.
				StateChangeScript { script: playScreenContent.updateLayout() }
			},
			State
			{
				name: "Normal"
				when: 1 === 1

				PropertyChanges { target: topBar; visible: true; }
				PropertyChanges { target: bottomBar; visible: true; }
				// This is essentially a height of a single line webview ribbon. */
				PropertyChanges { target: middleBar; visible: true; minHeight: 285; }

				// Switching state changes height of bottomBar. Call updateLayout after
				// the minHeight, maxHeight property is updated.
				StateChangeScript { script: playScreenContent.updateLayout() }
			}
		]
	}
}
