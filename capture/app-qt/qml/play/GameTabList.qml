import QtQuick 2.3
import Phoenix 1.0 as Phoenix
import QtQml.Models 2.1
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2

// Common imports some types that will override existing QML types
// such as ScrollBar so we need to scope this
import "../common" as PhoenixCommon
import "../common/util.js" as Util

Item
{
	id: gameBar
	property real backgroundOpacity: 0.15
	property bool isCollapsed: gameController.isGameTabBarCollapsed

	// Dim navigation bar background
	Rectangle
	{
		anchors.fill: parent

		// Don't overlap border lines.
		anchors.rightMargin: 1
		anchors.leftMargin: 1
		color: "black"
		opacity: backgroundOpacity
	}

	ScrollView
	{
		id: scrollView
		ScrollBar.vertical
		{
			policy: ScrollBar.AlwaysOff
		}

		clip:true

		anchors
		{
			bottom: collapseButtonItem.top
			left: gameBar.left
			right: gameBar.right
			top: gameBar.top
		}

		Flickable
		{
			id: theFlickable

			// Disable mobile overshoot
			boundsBehavior: Flickable.StopAtBounds
			anchors.fill: parent
			contentWidth: container.width
			contentHeight: container.height

			Item
			{
				id: container

				// height: childrenRect.height
				width: scrollView.width
				height: childrenRect.height + 20

				GameTabListHeader
				{
					id: blizzardHeader
					headerText: qsTr("BLIZZARD")
					visible: activisionList.visible
					anchors
					{
						top: container.top
						left: container.left
						right: container.right
						topMargin: visible ? 25 : 20
					}
				}

				GameTabListView
				{
					id: blizzardList
					listModel: gameController.blizzardProductsModel
					anchors
					{
						top: blizzardHeader.bottom
						left: container.left
						right: container.right
					}
				}

				GameTabListHeader
				{
					id: activisionHeader
					headerText: qsTr("PARTNER GAMES")
					visible: activisionList.visible
					anchors
					{
						top: blizzardList.bottom
						left: container.left
						right: container.right
						topMargin: 20
					}
				}

				GameTabListView
				{
					visible: { return gameController.activisionProductsModel.count > 0; }
					id: activisionList
					listModel: gameController.activisionProductsModel
					anchors {
						top: activisionHeader.bottom
						left: container.left
						right: container.right
					}
				}
			}
		}
	}

	Item
	{
		id: collapseButtonItem
		width: gameBar.width
		height: 52
		anchors
		{
			left: scrollView.left
			right: scrollView.right
			bottom: gameBar.bottom
			bottomMargin: -1
		}

		PhoenixCommon.Button
		{
			id: collapseButton
			height: 34
			width: 34
			anchors
			{
				top: collapseButtonItem.top
				left: collapseButtonItem.left
				leftMargin: 18
			}

			backgroundImages: PhoenixCommon.ButtonThemeImages {}

			states:
			[
				State
				{
					name: "collapsed"
					when: isCollapsed
					PropertyChanges
					{
						target: collapseButton
						iconSource: "../images/expand_normal.png"
					}
				},
				State
				{
					name: "expanded"
					when: !isCollapsed
					PropertyChanges
					{
						target: collapseButton
						iconSource: "../images/collapse_normal.png"
					}
				}
			]

			iconOpacity: PhoenixCommon.ButtonThemeOpacities
			{
				normal: 0.6
				hovered: 0.8
				pressed: 0.4
				disabled: 0.2
			}

			onClicked: toggleState();

			function toggleState() {
				gameController.isGameTabBarCollapsed = !isCollapsed;
			}
		}
	}

	// Right side border starting from the bottom of the listview
	Border
	{
		id: tabBorder

		anchors
		{
			top: parent.top
			right: parent.right
			bottom: parent.bottom
		}
	}
}
