import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

Item
{
	id: container
	property variant progressObject

	width: 70
	height: 71

	Item
	{
		id: content
		width: spinner.width
		height: spinner.height
		anchors.centerIn: parent

		//==========================================================================
		// ToolTip
		//==========================================================================
		Phoenix.ToolTipMouseArea
		{
			id: spinnerTooltip
			anchors.fill: parent

			// Set the tooltip value so that showToolTip signal fires, however we'll
			// get and use the tooltip from the progressObject when we actually need to show it.
			toolTip: "Unused"
			tipType: Phoenix.ToolTip.ArrowDown
			noDelay: true
			onShowToolTip:
			{
				var centeredRect = util.globalGeometry(content);
				var adjustedTipType = spinnerTooltip.tipType;
				adjustedTipType |= Phoenix.ToolTip.ArrowAtLeft;
				var displayedText = progressObject.toolTip;
				appController.ShowToolTipExplicit(centeredRect, displayedText,
					adjustedTipType, self, centeredRect, noDelay, popupMode, true);
			}
		}

		//==========================================================================
		// Spinner Icon
		//==========================================================================
		Spinner
		{
			id: spinner

			anchors.centerIn: parent

			// If theme is default, it means the stage hasn't been determined yet.
			// It's either queued or initializing.
			initializing: progressObject.theme === Phoenix.Progress.Grey
			paused: progressObject.showAsPaused

			updateColor:
			{
				switch (progressObject.theme) {
				case Phoenix.Progress.Blue:
					return "#0692d2";
				case Phoenix.Progress.Red:
					return "#e60000";
				case Phoenix.Progress.Yellow:
					return "#d8ac15";
				case Phoenix.Progress.Green:
					return "#18a006";
				}
				return "#0692d2";
			}

			states: [
				State
				{
					name: "Setup"
					when: progressObject.displayMode === Phoenix.Progress.ShowProgressSpinner
					PropertyChanges
					{
						target: spinner;
						overrideColor: true
						updateColor:
						{
							switch (progressObject.theme) {
							case Phoenix.Progress.Blue:
								return "#0692d2";
							case Phoenix.Progress.Red:
								return "#e60000";
							case Phoenix.Progress.Yellow:
								return "#d8ac15";
							case Phoenix.Progress.Green:
								return "#18a006";
							}
							return "#0692d2";
						}
					}
				}
			]
		}
	}
}
