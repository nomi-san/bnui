import QtQuick 2.2

Item
{
	id: progressBar

	property double minimum: 0.0
	property double maximum: 1.0
	property double value
	property bool showAsPaused: false
	property bool updatingComplete: progressBar.value == progressBar.maximum

	property variant theme: ProgressBarTheme {}

	QtObject
	{
		id: internal

		property bool initialized: false

		property int bodyWidth: emptyBar.width - theme.bodyHMargin*2

		// Display at least some pixels of progress bar even when progress value is zero.
		property int widthDest: theme.maskLeftBorderWidth + ((theme.backgroundWidth - theme.maskLeftBorderWidth * 2) * (value - minimum)) / (maximum - minimum)

		property bool showPulseEffect: false
	}

	width: theme.backgroundWidth
	height: emptyBar.height

	//==========================================================================
	// ProgressBar Background
	//==========================================================================
	BorderImage
	{
		id: emptyBar

		width: theme.backgroundWidth

		anchors.left: parent.left
		anchors.right: parent.right

		source: theme.backgroundSource
		border.top: 0; border.bottom: 0;
		border.left: theme.backgroundBorderLeft;
		border.right: theme.backgroundBorderRight
		horizontalTileMode: BorderImage.Repeat
	}

	//==========================================================================
	// ProgressBar Body
	//==========================================================================
	Item
	{
		id: progressBarBody

		anchors.left: parent.left
		anchors.leftMargin: theme.bodyHMargin
		anchors.top: parent.top
		anchors.topMargin: theme.bodyVMargin

		height: progressBarImage.height

		// Image for rest of the ProgressBar body will be clipped by parent 'Item'
		clip: true

		// width of the Item is controlled by internal.widthDest
		width: internal.widthDest - theme.bodyHMargin

		BorderImage
		{
			id: progressBarImage
			source: theme.bodySource
			width: internal.bodyWidth
			border.left: theme.bodyBorderSize
			border.right: theme.bodyBorderSize
			horizontalTileMode: BorderImage.Stretch
		}
	}

	//==========================================================================
	// Progress Effects
	//==========================================================================

	BorderImage
	{
		id: completeFlash

		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: theme.flashHMargin

		source: theme.flashSource
		border.left: theme.flashBorderSize
		border.right: theme.flashBorderSize
		horizontalTileMode: BorderImage.Repeat

		opacity: 0.0
		visible: false
	}


	SimpleLoader
	{
		id: progressEffectsLoader

		anchors.left: parent.left
		anchors.right: parent.right
		anchors.leftMargin: theme.effectMargin
		anchors.rightMargin: theme.effectMargin
		anchors.verticalCenter: parent.verticalCenter

		component: progressEffectsComponent 
		visible: !progressBar.showAsPaused
	}



	Component
	{
		id: progressEffectsComponent

		Rectangle
		{
			id: progressEffects

			height: theme.leadImageHeight
			clip: true

			// Bug 8495: If Item element used instead, the area outside of item boundary are 
			// not cleared properlty and leaves some graphical glitches from lead image.
			color: "transparent"

			Item
			{
				id: pulseEffect

				width: internal.widthDest
				height: progressBar.height

				anchors.left: parent.left
				anchors.leftMargin: -theme.effectMargin
				anchors.verticalCenter: parent.verticalCenter

				clip: true
				visible: internal.showPulseEffect

				function updateAnimation()
				{
					if (pulseEffect.visible)
						progressEffects.startAnimation();
					else
						progressEffects.stopAnimation();
				}

				onVisibleChanged: updateAnimation()
				Component.onCompleted: updateAnimation()

				Image
				{
					id: pulse
					anchors.verticalCenter: parent.verticalCenter
					source: theme.pulseSource
					smooth: true
				}
			}

			Item
			{
				id: pulseLineEffect

				height: progressBar.height
				anchors.left: parent.left
				anchors.leftMargin: -theme.effectMargin
				anchors.right: parent.right
				anchors.verticalCenter: parent.verticalCenter

				visible: internal.showPulseEffect



				BorderImage
				{
					id: pulseLine

					anchors.top: parent.top
					anchors.bottom: parent.bottom

					source: theme.pulseLineSource
					border.top: 1; border.bottom: 1;
					verticalTileMode: BorderImage.Repeat
					horizontalTileMode: BorderImage.Stretch
					smooth: true
				}
			}

			function startAnimation()
			{

				// "to" value is not bound to widthDest property
				// It needs to be manually updated everytime.
				if (internal.initialized)
				{
					pulsePropertyAnimation.to = internal.bodyWidth;
				}
				else
				{
					// When progressBar is not initialized, meaning geometry of
					// progress bar is not property updated, give enough width
					// so that pulse go all the way to the end when it's shown for the first time.
					pulsePropertyAnimation.to = self.width;
				}

				pulseAnimation.restart();
			}

			function stopAnimation()
			{
				pulseAnimation.stop();
			}

			SequentialAnimation
			{
				id: pulseAnimation
				PropertyAnimation
				{
					id: pulsePropertyAnimation
					targets: [pulse, pulseLine] ; property: "x"
					duration: 2000;
					from: -pulse.width;

					to: 0
				}
				PauseAnimation { duration: 300 }
				ScriptAction { script: progressEffects.startAnimation() }
			}

			Image
			{
				id: leadImage
				x: internal.widthDest - leadImage.width + theme.leadImageOffsetX
				anchors.verticalCenter: parent.verticalCenter
				source: theme.leadSource
				visible: internal.showPulseEffect
			}
		}
	}

	Component.onCompleted:
	{
		internal.initialized = true;
	}

	StateGroup
	{
		states: [
			State
			{
				name: "paused"
				when: progressBar.showAsPaused
			},
			State
			{
				name: "empty"
				when: progressBar.value == progressBar.minimum
			 	PropertyChanges { target: internal; showPulseEffect: true }
			},
			State
			{
				name: "complete"
				when: progressBar.updatingComplete && progressBarBody.width >= internal.widthDest
				PropertyChanges { target: progressBarBody; clip: false }
				PropertyChanges { target: completeFlash; visible: true }
			},
			State
			{
				name: "progressing"
				when: progressBar.value > progressBar.minimum
			 	PropertyChanges { target: internal; showPulseEffect: true }
			}
		]

		transitions: [
			Transition {
				from: "progressing"
				to: "complete"
				SequentialAnimation
				{
					NumberAnimation { target: completeFlash; property: "opacity"; from: 0; to: 0.9; alwaysRunToEnd: true; duration: 400 }
					NumberAnimation { target: completeFlash; property: "opacity"; from: 0.9; to: 0; alwaysRunToEnd: true; duration: 400 }
				}
			}
		]

	}
}
