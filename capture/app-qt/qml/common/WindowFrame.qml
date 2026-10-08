import QtQuick 2.2

Item
{
	id: frame

	anchors.fill: parent

	property alias detailBar: detailBar
	property alias windowBorder: borderLoader.item

	Loader
	{
		id: borderLoader

		source: util.isMac() ? "" : "WindowBorder_Win.qml"

		onStatusChanged: updateParent()
	}

	// Below items will be displayed on top of everything else.
	DetailBar { z: 9999; id: detailBar }

	function updateParent()
	{
		if (borderLoader.status !== Loader.Ready)
			return;

		var windowRoot = frame.parent;
		while (windowRoot.parent) {
			windowRoot = windowRoot.parent;
		}

		windowBorder.parent = windowRoot;
		windowBorder.z = 9999
	}
}
