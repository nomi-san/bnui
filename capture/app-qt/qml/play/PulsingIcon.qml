import QtQuick 2.2

Image
{
	id: image

	property bool pulsing: false

	SequentialAnimation on opacity
	{
		running: image.pulsing
		loops: Animation.Infinite
		NumberAnimation { duration: 1000; from: 0.2; to: 1; easing.type: Easing.OutQuad; }
		NumberAnimation { duration: 1000; from: 1; to: 0.2; easing.type: Easing.InQuad; }
	}
}
