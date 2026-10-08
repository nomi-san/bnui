import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

Item
{
	id: container
	property variant progressObject

	property variant thresholds
	property Item firstThreshold

	function activeColor(stage)
	{
		if (stage ===  Phoenix.GameProductState.Setup)
			return "#e60000";
		else if (stage ===  Phoenix.GameProductState.Playable)
			return "#d8ac15";
		else if (stage ===  Phoenix.GameProductState.Optimal)
			return "#18a006";
		else
			return "pink";
	}

	function opacity(status)
	{
		if (status ===  Phoenix.Threshold.CurrentStage)
			return 1.0
		else
			return 0.7;
	}

	onWidthChanged: repeater.calculateVisible();

	onThresholdsChanged: {
		repeater.model = thresholds;
		repeater.calculateVisible();
	}

	Repeater
	{
		id: repeater

		function calculateVisible() {
			// Check the threshold before to see if its the same position as us.
			for (var i = 0; i < repeater.count; ++i) {

				// Don't check behind first stage.
				if (i < 1) {
					continue;
				}

				var item = repeater.itemAt(i);
				var previous = repeater.itemAt(i - 1);
				if (item && previous) {
					var previousMarker = previous.marker;
					var marker = item.marker;
					var bufferSize = 3;

					// Hide the current progress if its within the
					// buffer zone of the previous progress label.
					item.isVisible = item.itemModelData.showMarker &&
						(Math.abs(marker.x - previousMarker.x) > bufferSize);
				}
			}
		}

		Item
		{
			property alias marker: progressBarMarker
			property variant itemModelData: modelData
			property variant isVisible: modelData.showMarker
			ProgressBarMarker
			{
				id: progressBarMarker
				parent: container
				visible: isVisible
				anchors.top: parent.top;
				anchors.bottom: parent.bottom
				anchors.topMargin: 1
				anchors.bottomMargin: 1

				// This make sure the marker for earlier stage shows on top of the marker for later stage.
				z: -index

				x: container.width * modelData.position - 1
				onXChanged: repeater.calculateVisible();

				// Display marker for next stage
				color: container.activeColor(modelData.stage)

				states: State {
					name: "Completed"
					when: modelData.status ===  Phoenix.Threshold.CompletedStage ||
						  modelData.status ===  Phoenix.Threshold.CurrentStage
					PropertyChanges
					{
						target: progressBarMarker;
						color: "#ffffff"
						opacity: 0.2
					}
				}
			}

			ProgressStageLabel
			{
				id: stageLabel

				parent: container
				visible: isVisible && !progressObject.showAsPaused

				// This make sure the marker for earlier stage shows on top of the marker for later stage.
				z: -index

				// Display marker for next stage
				activeColor: container.activeColor(modelData.stage)
				text: modelData.text
				opacity: container.opacity(modelData.status)
				stage: modelData.stage

				Binding
				{
					target: container
					property: "firstThreshold"
					value: stageLabel
					when: index == 1 // index 0 is for setup and never be displayed
				}

				// Set horizontal position
				x:
				{
					var localX = container.width * modelData.position;

					// Flip the label horizontally only if left edge of stage label did't exceed
					// boundary of the parent container.
					if (localX - stageLabel.width > 0 && localX + stageLabel.width > container.width)
						localX -= stageLabel.width;
					return localX;
				}

				// Set vertical position
				y:
				{
					var newY = 0;
					// If this is the first threshold, always show at the bottom
					// index 0 is for setup and never be displayed
					if (index == 1 || firstThreshold == undefined || !firstThreshold.visible)
						newY = parent.height + 4;
					else if (firstThreshold.x + firstThreshold.width + 10 > stageLabel.x)
						newY = - stageLabel.height - 4;
					else
						newY = parent.height + 4

					return newY;
				}

				tipPosition:
				{
					var tipType = stageLabel.y > 0 ? "top" : "bottom";
					tipType += container.width * modelData.position == stageLabel.x ? "Left" : "Right";
					return tipType;
				}

				// Tooltip
				// Set the tooltip value so that showToolTip signal fires, however we'll
				// get and use the tooltip from the progressObject when we actually need to show it.
				//: Tooltip for the progress bar marker area.
				toolTip: qsTr("Unused")
				tipType: Phoenix.ToolTip.ArrowDown
				noDelay: true

				function showTooltip(popupMode)
				{
					var centeredRect = util.globalGeometry(progressBarMarker);
					centeredRect.width = 1;
					var labelRect = util.globalGeometry(stageLabel);

					var anchorRect = Qt.rect(labelRect.x,
											  Math.min(labelRect.y, centeredRect.y),
											  labelRect.width, 0);
					if (labelRect.y < centeredRect.y)
						anchorRect.height = centeredRect.y + centeredRect.height - labelRect.y
					else
						anchorRect.height = labelRect.y + labelRect.height - centeredRect.y

					var adjustedTipType = stageLabel.tipType;
					if (container.width * modelData.position == stageLabel.x)
						adjustedTipType |= Phoenix.ToolTip.ArrowAtLeft
					else
						adjustedTipType |= Phoenix.ToolTip.ArrowAtRight

					appController.ShowToolTipExplicit(centeredRect,
						progressObject.GetProgressStageTooltip(modelData.stage),
						adjustedTipType, self, anchorRect, noDelay, popupMode, true);
				}

				onShowToolTip:
				{
					showTooltip(popupMode);
				}
			}
		}
	}
}
