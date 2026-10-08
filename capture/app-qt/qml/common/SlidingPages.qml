import QtQuick 2.2

Item
{
	default property alias pages: container.data

	property int currentIndex: 0
	property int currentItemHeight: container.children[currentIndex].height
	property alias animation: animation

	function nextPage()
	{
		if (currentIndex < container.children.length - 1)
			currentIndex = currentIndex + 1;

		container.x = -container.children[currentIndex].x;
	}

	function previousPage()
	{
		if (currentIndex > 0)
			currentIndex = currentIndex - 1;

		container.x = -container.children[currentIndex].x;
	}

	Item
	{
		anchors.fill: parent
		clip: true

		Row
		{
			id: container

			Behavior on x
			{
				 NumberAnimation
				 {
					 id: animation
					 duration: 100
					 easing.type: Easing.InOutQuad
				 }
			 }
		}
	}
}
