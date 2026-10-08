import QtQuick 2.2

Item
{
	id: container

	property alias buttonState: icon.buttonState;
	property alias buttonProperties: icon.buttonProperties
	property alias mouseArea: mouseArea

	signal clicked()

	width: icon.width
	height: icon.height

	ButtonBehavior
	{
		id: mouseArea
		hoverEnabled: true
		onClicked: container.clicked()
	}

	ButtonStateImage
	{
		id: icon

		anchors
		{
			verticalCenter: parent.verticalCenter
			horizontalCenter: parent.horizontalCenter
		}
	}
}
