import QtQuick 2.2

Balloon
{
	property alias textItem: textItem

	// Adjust paddings to match the layout of Qt ToolTip
	leftPadding: 12
	rightPadding: 5
	topPadding: 8
	bottomPadding: 9
	closeButton.anchors.topMargin: 4

	target: balloonTarget
	Text
	{
		id: textItem
		wrapMode: Text.Wrap
		width: 339 // Matches with maximum width of Qt ToolTip.
		color: "#bfc1c5"
		onLinkActivated: Qt.openUrlExternally(link)
		textFormat: Text.RichText
	}
}
