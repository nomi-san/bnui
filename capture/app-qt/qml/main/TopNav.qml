import QtQuick 2.2
import Phoenix 1.0
import "../common"

TopNavBase
{
	id: topNavArea

	LeftNav
	{
		id: leftNav

		anchors
		{
			left: parent.left
			leftMargin: 11
			top: topPadding.bottom
			topMargin: -4 + topAreaOffset;
			right: rightNavContainer.left
			rightMargin: 20
			bottom: parent.bottom
		}

		SimpleLoader
		{
			id: diagLoaderLeft
			visible: topNavArea.debugLayout

			anchors.fill: parent

			component: Rectangle {
				color: "#EDD682"
				opacity: .3
			}
		}
	}

	Item
	{
		id: rightNavContainer

		anchors
		{
			right: parent.right

			top: parent.top
			bottom: parent.bottom
		}

		width: rightNav.width + rightNav.anchors.rightMargin

		SimpleLoader
		{
			id: diagLoaderRightContainer
			visible: topNavArea.debugLayout

			anchors.fill: parent

			component: Rectangle {
				color: "#ff7A97"
				opacity: .3
			}
		}

		RightNav
		{
			id: rightNav

			anchors
			{
				right: parent.right
				rightMargin: 13
				verticalCenter: parent.verticalCenter
				verticalCenterOffset: (util.isMac() ? 0 : topNavArea.topPaddingSize / 2) + 1
			}

			SimpleLoader
			{
				id: diagLoaderRight
				visible: topNavArea.debugLayout

				anchors.fill: parent

				component: Rectangle {
					color: "#977AFF"
					opacity: .3
				}
			}
		}
	}
}
