import QtQuick 2.2
import Phoenix 1.0

Text
{
	id: elidingTextComponent

	font.pixelSize: 13
	font.family: fonts.regularFont.name
	lineHeightMode: Text.FixedHeight
	lineHeight: 18

	elide: Text.ElideRight
	wrapMode: maximumLineCount > 1 ? Text.WordWrap : Text.NoWrap
	maximumLineCount: 1

	ToolTipMouseArea
	{
		id: tooltipMouseArea
		noDelay: false
		enabled: elidingTextComponent.truncated
		anchors.fill: parent
		hoverEnabled: true
		toolTip: elidingTextComponent.text

		// This MouseArea is only for hovers; ignore all buttons so they can
		// fall through to other MouseAreas
		acceptedButtons: Qt.NoButton
	}
}
