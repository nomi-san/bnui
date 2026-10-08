import QtQuick 2.2

// Window Border
Rectangle
{
	property variant dialog: parent

	height: parent.height
	width: parent.width

	color: "#00000000"

	border.width: 1
	border.color: "#000000"

	Rectangle
	{
		anchors.fill: parent
		anchors.margins: 1

		color: "#00000000"
		border.width: 1
		border.color: "#ffffff"
		opacity: 0.10
	}
}
