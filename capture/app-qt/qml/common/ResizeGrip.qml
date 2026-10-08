import QtQuick 2.2
import Phoenix 1.0


Item
{
	id: container

	anchors.fill: parent
	property alias bottomRightGrip: resizeGrip

	signal resized(variant point)

	// TopLevelWindow::PerformHitTest(...) uses ResizeGripMarker as a "magic"
	// marker to figure out where the resize grip is.  On Windows resizing
	// mechanic and cursor shape is controlled by C++ code in
	// CustomWindowSupport::PerformHitTest(...) while on Mac it is done here by
	// JavaScript.  On both platform the resige grip image is still provided by
	// QML and on Windows C++ code with use the item position and size.
	ResizeGripMarker
	{
		id: resizeGrip
		opacity: 0.7

		signal resized(variant point)
		onResized: container.resized(point);

		width: 20
		height: 20

		visible: !self.maximized

		anchors.bottom: parent.bottom
		anchors.bottomMargin: -2
		anchors.right: parent.right
		anchors.rightMargin: -2

		Image
		{
			id: icon

			source: "../images/img_resizing.png"
			anchors.bottom: parent.bottom
			anchors.right: parent.right
			anchors.rightMargin: 5
			anchors.bottomMargin: 5
		}
	}
}
