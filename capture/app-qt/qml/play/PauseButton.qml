import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

PlayScreenButton
{
	id: pauseButton
	property variant progressObject

	signal pauseClicked();
	signal resumeClicked();

	onClicked:
	{
		if (progressObject.pauseButtonState === Phoenix.Progress.PausedResumable)
			pauseButton.resumeClicked();
		else
			pauseButton.pauseClicked();
	}

	enabled: false

	width: 26; height: 26;
	iconSource: "../images/progressbar_button_pause.png"
	//: Default tooltip for the pause button.
	toolTip: qsTr("You can't pause yet. Please Wait.")

	tipType: Phoenix.ToolTip.ArrowDown | pauseButton.tooltipDirection
	noDelay: true

	onShowToolTip:
	{
		util.showToolTip(pauseButton, pauseButton, pauseButton.toolTip, pauseButton.tipType, noDelay);
	}

	states: [
		State
		{
			name: "Pausable"
			when: progressObject.pauseButtonState === Phoenix.Progress.Pausable

			PropertyChanges
			{
				target: pauseButton;
				enabled: true
				iconSource: "../images/progressbar_button_pause.png"
				//: Tooltip for the pause button (when pausable).
				toolTip: qsTr("Pause")
			}
		},
		State
		{
			name: "PausedResumable"
			when: progressObject.pauseButtonState === Phoenix.Progress.PausedResumable

			PropertyChanges
			{
				target: pauseButton;
				enabled: true
				iconSource: "../images/progressbar_button_resume.png"
				//: Tooltip for the pause button (when paused and can resume).
				toolTip: qsTr("Resume")
			}
		},
		State
		{
			name: "PausedUnresumable"
			when: progressObject.pauseButtonState === Phoenix.Progress.PausedUnresumable

			PropertyChanges
			{
				target: pauseButton;
				enabled: false
				iconSource: "../images/progressbar_button_resume.png"
				//: Tooltip for the pause button (when paused and can't resume yet).
				toolTip: qsTr("You can't resume because the game is currently running.")
			}
		}
	]
}
