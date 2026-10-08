import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

Rectangle
{
	id: headingBorder

	property alias headingText: headingText.text
	property alias dismissText: dismissAll.text

	property int padding: 16
	property int fontSize: 13
	property int horizontalPadding: 16

	property int lineHeightOffset: headingText.height - fontSize
	property int adjustedVerticalPadding: padding - lineHeightOffset
	property int adjustedHorizontalPadding: horizontalPadding - 3 // Design padding includes borders

	height: headingText.contentHeight + 2 * adjustedVerticalPadding

	signal dismissAllClicked

	ElidingText
	{
		id: headingText
		anchors
		{
			top: headingBorder.top
			left: parent.left
			topMargin: adjustedVerticalPadding - 1 // For top border
			bottomMargin: adjustedVerticalPadding
			leftMargin: adjustedHorizontalPadding
		}

		color: "#ffffff"
		opacity: 0.4
	}

	HoverText
	{
		id: dismissAll
		anchors
		{
			top: headingBorder.top
			right: headingBorder.right
			topMargin: adjustedVerticalPadding - 1 // For top border
			bottomMargin: adjustedVerticalPadding
			rightMargin: adjustedHorizontalPadding
		}

		horizontalAlignment: Text.AlignRight

		onClicked: headingBorder.dismissAllClicked()
	}

	Rectangle
	{
		color: "#424854"
		height: 1
		anchors
		{
			left: parent.left
			right: parent.right
			bottom: headingBorder.bottom
		}
	}
}
