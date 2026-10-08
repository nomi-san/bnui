import QtQuick 2.2
import Phoenix 1.0 as Phoenix

import "../common"

ButtonBehavior
{
	id: gameItem

	height: 44

	// this is an instance of Phoenix::GameTabItem
	property variant game: null

	property bool isCurrentItem: false
	property bool showTooltip: true
	property bool dragEnabled: false

	property bool dragActive: gameTabItem.Drag.active
	property Item dragParent

	// Reset default anchor set inside of ButtonBehavior
	anchors.fill: undefined

	// ToolTip
	toolTip: game ? game.tooltip : ""
	tipType: Phoenix.ToolTip.ArrowLeft
	acceptedButtons: Qt.LeftButton | Qt.RightButton

	onShowToolTip:
	{
		// Do not show tooltip when an item is being dragged
		if (gameTabItem.Drag.active)
			return;

		util.showToolTip(gameItem, gameItem, gameItem.toolTip,
			gameItem.tipType, gameItem.noDelay)
	}

	onClicked:
	{
		if (mouse.button === Qt.RightButton) {
			var rect = util.globalGeometry(gameItem);
			if (game) {
				gameController.OpenGameTabMenu(game.productId, rect);
			}
		}
		else if (mouse.button === Qt.LeftButton) {
			if (game) {
				gameController.SelectGameTab(game.productId);
			}
		}
	}

	drag.target: gameTabItem
	drag.axis: Drag.YAxis

	function stopDrag() {
		if (gameTabItem.Drag.active) {
			gameTabItem.Drag.drop();
			return true;
		}
		return false;
	}

	Item
	{
		id: gameTabItem

		// don't directly reference parent here, since we change parent when dragging
		width: gameItem.width
		height: gameItem.height

		anchors
		{
			horizontalCenter: parent.horizontalCenter;
			verticalCenter: parent.verticalCenter;
		}

		// Drag & Drop Support
		Drag.active: gameItem.drag.active && gameItem.dragEnabled
		Drag.source: gameItem
		Drag.hotSpot.x: width / 2
		Drag.hotSpot.y: height / 2

		opacity: Drag.active ? 0.5 : 1.0

		Item
		{
			id: bkgd

			anchors.fill: parent

			// Game tab highlight rectangle.
			Rectangle
			{
				id: highlightRectangle
				anchors.fill: parent

				// Don't overlap with the border lines.
				anchors.rightMargin: 1
				anchors.leftMargin: 1
				color: "#FFFFFF"
				visible: !gameItem.drag.active && gameItem.containsMouse || gameItem.isCurrentItem
				opacity: gameItem.isCurrentItem ? 0.08 : 0.05
			}

			// Selected tab indicator
			Rectangle
			{
				anchors.left: highlightRectangle.left
				width: 3
				height: highlightRectangle.height
				color: "#00AEFF"
				visible: gameItem.isCurrentItem
			}

			// Game Icon and Text
			GameTabVisual
			{
				id: visual
				width: gameTabItem.width; height: gameTabItem.height

				icon: game ? game.icon : ""
				text: game ? game.name : ""

				highlight: {
					return gameItem.drag.active ||
						gameItem.isCurrentItem ||
						gameItem.containsMouse ||
						(game && game.notification == Phoenix.GameFamily.LegendaryPromo);
				}

				Behavior on opacity { NumberAnimation { duration: 200 }}
				glow: game && (game.notification == Phoenix.GameFamily.LegendaryPromo)
			}

			GameTabProgressBar
			{
				anchors
				{
					bottom: visual.bottom
					left: visual.left
					right: visual.right
					leftMargin: 18
					rightMargin: 18
					bottomMargin: 1
				}

				height: 4
				currentTheme: game ? game.progressTheme : 0

				visible: game && game.progressVisible && !gameItem.drag.active
				value: game ? game.progress : 0

				opacity: (game && game.progressVisible) ? 0.8 : 0
				Behavior on opacity { NumberAnimation { duration: 200 }}
			}
		}

		states:
		[
			State
			{
				when: gameTabItem.Drag.active

				ParentChange { target: gameTabItem; parent: dragParent }
				AnchorChanges
				{
					target: gameTabItem;
					anchors.horizontalCenter: undefined
					anchors.verticalCenter: undefined
				}
			}
		]
	}
}
