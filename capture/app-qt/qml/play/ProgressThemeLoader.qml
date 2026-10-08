import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

Loader
{
	id: progressThemeLoader

	property variant currentTheme

	Component
	{
		id: blueTheme
		ProgressBarTheme { backgroundWidth: progressBar.width; }
	}

	Component
	{
		id: redTheme
		ProgressBarTallRedTheme { backgroundWidth: progressBar.width; }
	}

	Component
	{
		id: yellowTheme
		ProgressBarTallYellowTheme { backgroundWidth: progressBar.width; }
	}

	Component
	{
		id: greenTheme
		ProgressBarTallGreenTheme { backgroundWidth: progressBar.width; }
	}

	Component
	{
		id: greyTheme
		ProgressBarTallGrayTheme { backgroundWidth: progressBar.width; }
	}

	sourceComponent:
	{
		switch(currentTheme) {
		case Phoenix.Progress.Blue:
			return blueTheme;
		case Phoenix.Progress.Red:
			return redTheme;
		case Phoenix.Progress.Yellow:
			return yellowTheme;
		case Phoenix.Progress.Green:
			return greenTheme;
		case Phoenix.Progress.Grey:
			return greyTheme;
		}
		return blueTheme;
	}
}
