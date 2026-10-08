import QtQuick 2.2

Item
{
	id: progressBar

	property double minimum: 0.0
	property double maximum: 1.0
	property double value: 0.0
	property double speed: 1.0

	property string backgroundImage: "../images/loader_progressbar_frame.png"
	property string barImage: "../images/loader_progressbar_fullbar.png"

	width: 61
	height: 5

	Image
	{
		id: frame
		source: progressBar.backgroundImage
	}

	Image
	{
		id: bar
		source: progressBar.barImage

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.leftMargin: 1
		anchors.bottom: parent.bottom

		width: progressBar.calculateWidth();

		Behavior on width {
			NumberAnimation { duration: progressBar.speed * 1000 }
		}
	}

	function calculateWidth()
	{
		var percent = Math.min(Math.max(progressBar.value, 0), 1.0)
		return (progressBar.width - 2) * percent
	}
}
