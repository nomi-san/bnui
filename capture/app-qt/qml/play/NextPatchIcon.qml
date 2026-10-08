import QtQuick 2.0
import QtGraphicalEffects 1.0
import Phoenix 1.0 as Phoenix
import "../common"

Loader
{
	id: container
	property variant progressObject

	property bool hovered: mouseArea.containsMouse
	property alias containsMouse: mouseArea.containsMouse
	property bool on: true
	property string _baseImage: "../images/icon_next_patch.png"
	property string _maskImage: "../images/icon_next_patch_mask.png"
	property string _pulseImage: "../images/icon_next_patch_gradient.png"

	property variant networkWarningType: {
		if (!progressObject)
			return Phoenix.Progress.NoWarning;

		return progressObject.networkWarningType;
	}
	property bool networkimpedimentActive: networkWarningType === Phoenix.Progress.Critical
		|| networkWarningType === Phoenix.Progress.Warning

	width: 24
	height: 24

	sourceComponent:
	{
		if (networkimpedimentActive)
			return networkimpedimentComponent
		if (progressObject.runningState === Phoenix.Progress.PausedRunningState)
			return pausedNextPatchComponent;
		if (progressObject.runningState === Phoenix.Progress.QueuedRunningState)
			return queuedNextPatchComponent;

		return activeNextPatchComponent;
	}

	MouseArea
	{
		id: mouseArea;
		anchors.fill: parent;
		hoverEnabled: true;
	}

	Component
	{
		id: pausedNextPatchComponent
		Image
		{
			id: pausedImage
			source: container._baseImage
			visible: true
			layer.enabled: true
			layer.effect: Desaturate { desaturation: 1.0 }
		}
	}

	Component
	{
		id: networkimpedimentComponent
		Item
		{
			width:24
			height:24

			PulsingIcon
			{
				id: pulsingIcon
				source: networkWarningType === Phoenix.Progress.Critical
					? "../images/icon_next_patch_red.png" : "../images/icon_next_patch_yellow.png";
				pulsing: container.on
			}

			opacity: container.on ? 1.0 : 0.0
			Behavior on opacity { NumberAnimation { properties: "opacity"; duration: 200; } }
		}
	}

	Component
	{
		id: queuedNextPatchComponent

		Item
		{
			width: 24
			height: 24

			Image
			{
				id: queuedArrow
				source: "../images/icon_next_patch_queued.png"
				visible: true
			}

			Image
			{
				id: queuedImage1
				source: "../images/icon_next_patch_queued_1.png"
				visible: true
				opacity: 1.0
			}

			Image
			{
				id: queuedImage2
				source: "../images/icon_next_patch_queued_2.png"
				visible: true
				opacity: 0.0
			}

			Image
			{
				id: queuedImage3
				source: "../images/icon_next_patch_queued_3.png"
				visible: true
				opacity: 0.0
			}

			property int fadeDelay: 300
			property int stopDelay: 500

			SequentialAnimation
			{
				running: true
				loops: Animation.Infinite


				ParallelAnimation
				{
					NumberAnimation { target: queuedImage1; property: "opacity"; to: 0.0; duration: fadeDelay }
					NumberAnimation { target: queuedImage2; property: "opacity"; to: 1.0; duration: fadeDelay }
				}

				PauseAnimation { duration: stopDelay; }

				ParallelAnimation
				{
					NumberAnimation { target: queuedImage2; property: "opacity"; to: 0.0; duration: fadeDelay }
					NumberAnimation { target: queuedImage3; property: "opacity"; to: 1.0; duration: fadeDelay }
				}

				PauseAnimation { duration: stopDelay; }

				ParallelAnimation
				{
					NumberAnimation { target: queuedImage3; property: "opacity"; to: 0.0; duration: fadeDelay }
					NumberAnimation { target: queuedImage1; property: "opacity"; to: 1.0; duration: fadeDelay }
				}

				PauseAnimation { duration: stopDelay; }
			}
		}
	}

	Component
	{
		id: activeNextPatchComponent

		Item
		{
			width: icon.width
			height: icon.height
			opacity: container.hovered ? 1.0 : 0.8

			Image
			{
				id: icon
				source: _baseImage
				visible: true
			}

			Image
			{
				id: pulse
				source: _pulseImage
				visible: false
			}

			Image
			{
				id: mask
				source: _maskImage
				visible: false
			}

			ExtendedOpacityMask
			{
				id: opacityMask
				anchors.fill: parent
				source: pulse
				maskSource: mask

				SequentialAnimation on sourceTextureOffsetY
				{
					loops: Animation.Infinite

					NumberAnimation
					{
						from: 1.0
						to: -1.0
						duration: 2000
					}

					PauseAnimation { duration: 300 }
				}
			}
		}
	}

	SimpleLoader
	{
		id: nextPatchToolTip

		property variant anchorTarget
		property variant tipType: Phoenix.ToolTip.ArrowDown
		property variant progressObject
		property int balloonXPosition
		property int padding: 15
		property int desiredX: -5
		anchorTarget: container
		visible: container.containsMouse;
		progressObject: container.progressObject
		anchors.bottom: parent.top
		anchors.bottomMargin: 21

		component: ProgressNextPatchBalloonContent
		{
			id: progressNextPatchInfo
			progressObject: nextPatchToolTip.progressObject
			tipType: nextPatchToolTip.tipType
			target: nextPatchToolTip.anchorTarget
			x: nextPatchToolTip.balloonXPosition
		}

		balloonXPosition:
		{
			if (item === null)
				return 0;

			if (container.visible)
			{
				if (container.mapToItem(window, desiredX + width, 0).x < window.width)
				{
					return desiredX - padding
				}
				else
				{
					return container.mapFromItem(window, window.width - item.width, 0).x - padding;
				}
			}
			else
			{
				return 0;
			}
		}
	}
}
