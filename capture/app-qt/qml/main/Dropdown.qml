import QtQuick 2.9
import Phoenix 1.0
import QtQuick.Controls 2.2
//import "../common" as PhoenixCommon // common already contains a ScrollBar so be careful!

Popup
{
	id: topMenu

	// Dropdowns should be positioned in the main window since
	// they cannot extend outside of it
	parent: window

	property point targetPoint: Qt.point(0,0)

	property int targetHorizontalSpacing: 0
	x: parent.width - topMenu.width - targetHorizontalSpacing
	y: targetPoint.y + Math.round(arrow.height / 2)

	background: Rectangle
	{
		id: borderRect
		anchors.fill: parent

		// "Inner stroke" color
		color: "#424854"

		// Black outline
		border
		{
			color: "black"
			width: 1
		}
	}

	// Currently only up arrow
	Image
	{
		id: arrow
		source: "../images/dropdown_darkgrey_arrow_up.png"
		x: targetPoint.x - topMenu.x - Math.round(arrow.width / 2)
		y: -Math.round(arrow.height / 2)
	}

	padding: 2
}
