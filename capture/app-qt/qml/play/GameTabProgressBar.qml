import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

Rectangle
{
	id: progressBar

	property double minimum: 0
	property double maximum: 1

	property double value
	property color emptyAreaColor: "#00ffffff"

	property string barColor: ""

	property variant currentTheme
	property int borderRadius: 1

	// Empty background
	color: emptyAreaColor
	radius: borderRadius

	Rectangle
	{
		id: borderArea
		anchors.fill: parent
		color: "transparent"
		border.color: "#30ffffff"
	}

	// Filled part
	Rectangle
	{
		id: filledArea
		anchors
		{
			top: parent.top
			left: parent.left
			bottom: parent.bottom
		}

		function progressBarColor(theme)
		{
			if (progressBar.barColor)
				return progressBar.barColor;

			if (theme < Phoenix.Progress.Blue || theme > Phoenix.Progress.Grey || theme === undefined)
				return "#ff0069e1";
			if (theme == Phoenix.Progress.Blue)
				return "#0069e1";
			if (theme == Phoenix.Progress.Red)
				return "#ff0000";
			if (theme == Phoenix.Progress.Yellow)
				return "#ffff00";
			if (theme == Phoenix.Progress.Green)
				return "#00ff00";

			return "grey";
		}

		width: parent.width * Math.max(Math.min(value,1.0), 0.0) / (maximum - minimum)
		radius: borderRadius
		color: progressBarColor(currentTheme)
	}
}
