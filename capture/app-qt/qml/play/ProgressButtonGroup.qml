import QtQuick 2.2
import Phoenix 1.0 as Phoenix

//==========================================================================
// Cancel / Pause Button
//==========================================================================
Row
{
	id: buttonGroup
	property variant view

	signal pauseClicked();
	signal resumeClicked();
	signal updateNowClicked();

	property variant tooltipDirection: Phoenix.ToolTip.ArrowAtRight

	layoutDirection: Qt.RightToLeft
	spacing: 7

	SettingsButton
	{
		id: settingsButton

		tooltipDirection: buttonGroup.tooltipDirection

		onPressed:
		{
			var rect = util.globalGeometry(settingsButton);
			view.OpenDownloadOptionsMenu(rect, rect, settingsButton.tipType);
		}
	}

	PauseButton
	{
		id: pauseButton
		progressObject: view.progress

		showToolTipWhenDisabled: true
		tooltipDirection: buttonGroup.tooltipDirection
		onPauseClicked: buttonGroup.pauseClicked();
		onResumeClicked: buttonGroup.resumeClicked();
	}

	StartUpdateButton
	{
		id: startUpdateButton
		progressObject: view.progress

		tooltipDirection: buttonGroup.tooltipDirection
		onStartUpdateClicked: buttonGroup.updateNowClicked();
	}
}
