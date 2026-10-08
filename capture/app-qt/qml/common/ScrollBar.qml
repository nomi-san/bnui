
import QtQuick 2.2

Item
{
	id: container

	property variant scrollArea
	property variant orientation: Qt.Vertical
	property bool showAlways: false

	opacity: 0

	function position()
	{
		var ny = 0;
		if (container.orientation == Qt.Vertical)
			ny = scrollArea.visibleArea.yPosition * container.height;
		else
			ny = scrollArea.visibleArea.xPosition * container.width;
		if (ny > 2) return ny; else return 2;
	}

	function size()
	{
		var minHeight = 20;
		var nh, ny;

		if (container.orientation == Qt.Vertical)
			nh = scrollArea.visibleArea.heightRatio * container.height;
		else
			nh = scrollArea.visibleArea.widthRatio * container.width;

		if (container.orientation == Qt.Vertical)
			ny = scrollArea.visibleArea.yPosition * container.height;
		else
			ny = scrollArea.visibleArea.xPosition * container.width;

		if (ny > 1) {
			var t;
			if (container.orientation == Qt.Vertical)
				t = Math.ceil(container.height - 3 - ny);
			else
				t = Math.ceil(container.width - 3 - ny);
			if (nh > t) return t;
			return Math.max(minHeight, nh);
		}

		if (nh + ny > container.height)
                        return Math.max(minHeight, container.height - 4)

		return Math.max(minHeight, nh + ny);
	}

	Rectangle
	{
		radius: 3
		color: "#ffffff"
		opacity: 0.2
		x: container.orientation == Qt.Vertical ? 0 : position()
		width: container.orientation == Qt.Vertical ? container.width - 0 : size()
		y: container.orientation == Qt.Vertical ? position() : 0
		height: container.orientation == Qt.Vertical ? size() : container.height - 0
	}

	states: State
	{
		name: "visible"
		when: (showAlways || (container.orientation == Qt.Vertical ? scrollArea.movingVertically : scrollArea.movingHorizontally))
			&& scrollArea.contentHeight > scrollArea.height
		PropertyChanges { target: container; opacity: 1 }
	}

	transitions: Transition
	{
		from: "visible"; to: ""
		NumberAnimation { properties: "opacity"; duration: 600 }
	}
}
