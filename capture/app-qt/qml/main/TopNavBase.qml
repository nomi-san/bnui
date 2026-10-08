import QtQuick 2.2
import Phoenix 1.0
import "../common"

Item
{
	id: topNavArea

	width: 1280
	height: topPaddingSize + contentSize + topAreaOffset - topMarginBackgroundPadding

	property int topPaddingSize: 20
	property int contentSize: 60
	property alias topPadding: topPadding

	property int topAreaOffset: (util.isMac() ?
			(/* added height of title bar */ 5 -
			 /* inset titlebar into window */ 21) : 1);
	property int topMarginBackgroundPadding: util.isMac() ? 0 : 1

	property bool debugLayout: false

	// Brighten the top area
	Rectangle
	{
		anchors.fill: parent
		color: debugLayout ? "black" : "white"
		opacity: debugLayout ? 1.0 : 0.05
	}

	Rectangle
	{
		// this is the horizontal line across the top nav area
		height: 1
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		color: "#ffffff"
		opacity: 0.07
	}

	Rectangle
	{
		// horizontal line across top of topnav area (mac only)
		height: 1
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		color: "#ffffff"
		opacity: 0.07

		visible: util.isMac()
	}

	Item
	{
		id: topPadding

		anchors.top: parent.top
		anchors.topMargin: 5
		anchors.left: parent.left
		anchors.right: parent.right
		height: topPaddingSize
	}

	SimpleLoader
	{
		id: diagLoader
		visible: debugLayout

		// for diag
		anchors.top: topPadding.bottom
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right

		component: Item
		{
			anchors.fill: parent

			Rectangle
			{
				anchors.fill: parent
				color: "#A0EF8B"
				opacity: .3
			}

			Rectangle
			{
				height: 1
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.verticalCenter: parent.verticalCenter
				color: "#ffffff"
				opacity: 0.5

			}
		}
	}

}
