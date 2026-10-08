import QtQuick 2.2
import "../common"

ElidingText
{
	id: hoverText

	property alias acceptedButtons: hoverArea.acceptedButtons
	signal clicked()

	color: hoverArea.containsMouse ? "#ffffff" : "#00aeff"

	MouseArea
	{
		id: hoverArea

		anchors.fill: hoverText
		hoverEnabled: true
		acceptedButtons: Qt.LeftButton
		onEntered:
		{
			cursorShape = Qt.PointingHandCursor
		}

		onExited:
		{
			cursorShape = Qt.ArrowCursor
		}

		onClicked: hoverText.clicked()
	}
}
