import QtQuick 2.2

Loader
{
	id: loader

	property double minimum: 0.0
	property double maximum: 1.0
	property double value
	property variant theme: ProgressBarTheme {}
	property bool showAsPaused: false
	property bool updatingComplete: false

	visible: false
	Component
	{
		id: progressBarComponent
		ProgressBar
		{
			id: progressBar

			minimum: loader.minimum
			maximum: loader.maximum
			value: loader.value
			theme: loader.theme
			width: loader.width
			showAsPaused: loader.showAsPaused
			updatingComplete: loader.updatingComplete
		}
	}

	sourceComponent: visible ? progressBarComponent : undefined
}
