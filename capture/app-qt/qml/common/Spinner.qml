import QtQuick 2.2
import QtGraphicalEffects 1.0 as Effects

Item
{
	id: container

	property bool small: false
	property bool overrideColor: false
	property color updateColor: "white"
	property bool initializing: false
	property bool paused: false

	width: small ? 14 : 30
	height: small ? 14 : 30

	property string _baseImage: getImageName("spinner_base", small, overrideColor)
	property string _centerImage: getImageName("spinner_dot", small, overrideColor)

	function getImageName(baseName, small, override)
	{
		var name = "../images/" + baseName;
		if (small)
			name  = name + "_small";
		if (override)
			name  = name + "_override";
		return name + ".png";
	}

	Loader
	{
		anchors.fill: parent
		sourceComponent: container.paused
			? pausedComponent
			: (container.initializing ? initializingComponent : runningComponent)
	}

	Component
	{
		id: initializingComponent
		Item
		{

			Image
			{
				source: container._baseImage
				anchors.fill: parent
				smooth: true
				RotationAnimation on rotation
				{
					running: container.visible
					loops: Animation.Infinite; duration: 1500; from: 0; to: 360;
				}

				layer.enabled: true
				layer.effect: Effects.ColorOverlay { color: "#909090"; }
			}

			//==================================================================
			// Animated Dots
			//==================================================================
			Row
			{
				id: animatedDots

				property int stepDuration: 750
				property int opacityDuration: 1500
				property real opacityFrom: 0.1 // This shouldn't be 0 since it is treated as hidden.
				property real opacityTo: 1.0
				property int dotRadius: 2

				anchors.centerIn: parent
				spacing: 2

				Rectangle
				{
					opacity: animatedDots.index == 1 ? animatedDots.opacityTo : animatedDots.opacityFrom;
					smooth: true; width: animatedDots.dotRadius * 2; height: animatedDots.dotRadius * 2; radius: width * 0.5;
					Behavior on opacity { NumberAnimation { duration: animatedDots.opacityDuration; easing.type: Easing.InOutQuad; } }
				}

				Rectangle
				{
					opacity: animatedDots.index == 2 ? animatedDots.opacityTo : animatedDots.opacityFrom;
					smooth: true; width: animatedDots.dotRadius * 2; height: animatedDots.dotRadius * 2; radius: width * 0.5;
					Behavior on opacity { NumberAnimation { duration: animatedDots.opacityDuration; easing.type: Easing.InOutQuad; } }
				}

				Rectangle
				{
					opacity: animatedDots.index == 3 ? animatedDots.opacityTo : animatedDots.opacityFrom;
					smooth: true; width: animatedDots.dotRadius * 2; height: animatedDots.dotRadius * 2; radius: width * 0.5;
					Behavior on opacity { NumberAnimation { duration: animatedDots.opacityDuration; easing.type: Easing.InOutQuad; } }
				}

				property int index: 0
				property bool initialized: false

				SequentialAnimation
				{
					loops: Animation.Infinite
					running: container.visible

					ScriptAction
					{
						script:
						{
							// This is to fix first dot is shown as bright dot (opacity 1.0)
							// at the start of animation.
							if (!animatedDots.initialized)
							{
								animatedDots.index = 0;
								animatedDots.initialized = true;
							}
							else
							{
								var newIndex = animatedDots.index + 1;
								if (newIndex > 3 || newIndex < 0)
									newIndex = 1;
								animatedDots.index = newIndex;
							}
						}
					}
					PauseAnimation { duration: animatedDots.stepDuration }
				}

			}
		}
	}

	Component
	{
		id: pausedComponent
		Image
		{
			source: "../images/spinner_paused.png"
			anchors.fill: parent
			fillMode: Image.Stretch
		}
	}

	Component
	{
		id: runningComponent
		Item
		{
			layer.enabled: overrideColor
			layer.effect: Effects.ColorOverlay { id: effect; color: updateColor; }

			Image
			{
				source: container._baseImage
				anchors.fill: parent
				smooth: true
				RotationAnimation on rotation
				{
					running: container.visible
					loops: Animation.Infinite; duration: 1500; from: 0; to: 360;
				}
			}
			Image
			{
				source: container._centerImage
				anchors.fill: parent
				smooth: true
				SequentialAnimation on opacity
				{
					loops: Animation.Infinite;
					running: container.visible
					NumberAnimation { from: 1.0; to: 0.2; duration: 1000; easing.type: Easing.InOutQuad; }
					NumberAnimation { from: 0.2; to: 1.0; duration: 1000; easing.type: Easing.InOutQuad; }
				}
			}
		}
	}
}
