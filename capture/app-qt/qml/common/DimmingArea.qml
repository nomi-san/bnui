import QtQuick 2.2
import Phoenix 1.0

// This component is tied to Common/DialogBase component which will call
// register/unregister function when a dialog is shown/hidden.

Rectangle
{
	id: dimmingArea

	property int dialogCount: 0
	property bool roundedCorners: false

	anchors.fill: parent

	radius: roundedCorners ? 5 : 0
	color: "#80000000"
	opacity: 0.0
	z: 1000

	function register()
	{
		dimmingArea.dialogCount++
		updateState()
	}

	function unregister()
	{
		dimmingArea.dialogCount--
		if (dimmingArea.dialogCount < 0)
			dimmingArea.dialogCount = 0
		updateState()
	}

	function updateState()
	{
		var state = "";
		if (dimmingArea.dialogCount > 0)
			state = "visible"

		dimmingArea.state = state;
	}

	Connections
	{
		target: windowManager

		function onWindowModalWindowShown() {
			register();
		}
		function onWindowModalWindowClosed() {
			unregister();
		}

		function onApplicationModalWindowShown() {
			register();
		}
		function onApplicationModalWindowClosed() {
			unregister();
		}
	}

	states:
	[
		State
		{
			name: "visible"
			PropertyChanges { target: dimmingArea; opacity: 1 }
		}
	]

	transitions:
	[
		Transition
		{
			from: "*"
			to: "visible"
			NumberAnimation { target: dimmingArea; properties: "opacity"; from: 0; to: 1; duration: 200 }
		},
		Transition
		{
			from: "visible"
			to: "*"
			NumberAnimation { target: dimmingArea; properties: "opacity"; duration: 100 }
			ScriptAction { script: self.forceRepaint(); }
		}
	]
}
