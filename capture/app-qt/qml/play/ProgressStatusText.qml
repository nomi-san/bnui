import QtQuick 2.2

Text
{
	id: container

	//==========================================================================
	// Properties
	//==========================================================================
	property string statusText
	property alias running: dotCountAnimation.running

	font.family: fonts.regularFont.name
	font.pixelSize: 13;

	elide: Text.ElideRight

	color: "#ffffff"
	opacity: 1.0

	layer.enabled: true
	layer.effect: DropShadowEffect {}

	//==========================================================================
	// Animated Dots
	//==========================================================================
	property int _dotCount: 0

	text: {
		var text = statusText;
		
		if (!running)
			return text;

		for (var i = 0; i < _dotCount; ++i)
			text += ".";

		return text;
	}

	SequentialAnimation
	{
		id: dotCountAnimation

		loops: Animation.Infinite
		running: container.visible

		property int _stepDuration: 1000

		/*
		 * PropertyAction allows to reduce the number of the animated
		 * property updates as we only need integers here.  NumberAnimation
		 * would use floating point values.
		 */
		PropertyAction { target: container; property: "_dotCount"; value: 1 }
		PauseAnimation { duration: dotCountAnimation._stepDuration }
		PropertyAction { target: container; property: "_dotCount"; value: 2 }
		PauseAnimation { duration: dotCountAnimation._stepDuration }
		PropertyAction { target: container; property: "_dotCount"; value: 3 }
		PauseAnimation { duration: dotCountAnimation._stepDuration }
		PropertyAction { target: container; property: "_dotCount"; value: 0 }
		PauseAnimation { duration: dotCountAnimation._stepDuration }

		// FIXME_QML2 - Is this required???
		//onStop: _dotCount = 0
	}
}
