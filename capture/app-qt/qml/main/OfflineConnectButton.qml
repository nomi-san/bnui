import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

Item
{
	id: offlineConnectButton
	
	height: connectButton.height
	width: visible ? connectButton.width : 0
	
	property string tooltipTimerText: timerSeconds > 0 ?
		//: Offline mode tooltip indicating time left before manual connect available
		qsTr("You may try again in %n second(s).", "", timerSeconds) : ""

	property int timerSeconds: 0

	property bool reconnecting: loginController.reconnectInProgress || loginController.fastReconnecting

	Button
	{
		id: connectButton

		//: Offline button text while attempting to connect
		property string connectionInProgress: qsTr("Connecting...");
		//: Offline button text while in login queue
		property string connectionWaiting: qsTr("In Queue");
		property string connectionInProgressText: connectionInProgress;
		property string buttonTimerText: timerSeconds > 0 ? (" (" + timerSeconds + ")") : ""

		height: 22
		horizontalPadding: 10
		enabled: loginController.manualConnectAvailable && !reconnecting

		text
		{
			//: Offline button text when manual connect is available
			text: reconnecting ? connectionInProgressText : qsTr("Go Online") + buttonTimerText
			font.family: fonts.regularFont.name
			font.pixelSize: 12
		}

		backgroundImages: ButtonThemeImages
		{
			normal: "../controls/btn_primary_normal.png"
			hovered: "../controls/btn_primary_hover.png"
			pressed: "../controls/btn_primary_pressed.png"
			disabled: "../controls/btn_primary_disabled_offline_connect.png"
		}

		textOpacity: ButtonThemeOpacities
		{
			normal: 0.9
			hovered: 1
			pressed: 0.8
			disabled: 0.4
		}

		onClicked:
		{
			loginController.ManualReconnect()
		}

		property string tooltipConnectionWaiting: ""
		property string tooltipConnectionInProgressText: "";

		showToolTipWhenDisabled: true
		tipType: Phoenix.ToolTip.ArrowUp
		noDelay: true

		toolTip: (connectButton.enabled || offlineBalloon.visible) ? "" :
					(reconnecting ? tooltipConnectionInProgressText :
					//: Offline button tooltip after a failed connection attempt
					qsTr("Couldn't log you in to Battle.net.") + "<br><br><b><font color=\"#ffffff\">" + tooltipTimerText + "</font></b>")
		onShowToolTip: connectButton.triggerToolTip(popupMode)

		Connections
		{
			target: loginController

			function onLoginQueueWaitTimeUpdated() {
				//: Offline button tooltip indicating amount of time left in login queue
				connectButton.tooltipConnectionWaiting = qsTr("You are in the login queue. Estimated wait is %1.").arg(loginController.loginQueueWaitTime);
			}
		}

		Connections
		{
			target: loginController

			function onIsInLoginQueueChanged() {
				connectButton.connectionInProgressText = loginController.inLoginQueue ? connectButton.connectionWaiting : connectButton.connectionInProgress;
				connectButton.tooltipConnectionInProgressText = loginController.inLoginQueue ? connectButton.tooltipConnectionWaiting : "";
			}
		}
	}

	OfflineBalloon
	{
		id: offlineBalloon

		anchors.right: connectButton.right
		anchors.top: connectButton.bottom
		anchorTarget: connectButton

		timerText: offlineConnectButton.tooltipTimerText
		//: Offline tooltip text
		text: qsTr("We couldn't log you in to Battle.net. While you are offline, friends & chat will be unavailable, and you will have to log in when playing games or accessing account management.");
		errorText: loginController.lastAuthenticationError.length > 0 ?
			//: Error code shown in offline mode tooltip
			qsTr("More Help: %1").arg(loginController.lastAuthenticationError) : ""
		errorUrl: loginController.lastAuthenticationErrorUrl
	}

	Connections
	{
		target: loginController

		function onAuthReconnectTimerTick() {
			timerSeconds = loginController.secondsTillAuthReconnectReady;
		}
	}
}
