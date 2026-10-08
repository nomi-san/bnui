import QtQuick 2.2
import Phoenix 1.0
import "../common"

Button
{
	id: voiceButton

	width: 44
	height: 32
	bSpacer: -1
	backgroundImages: ButtonThemeImages {}

	iconSource: "../images/menu-voice-active.png";

	acceptedButtons: Qt.LeftButton | Qt.RightButton
	onClicked:
	{
		if (mouse.button === Qt.LeftButton)
		{
			socialController.voiceButton.ActivateVoiceWindow();
		}
		else if (mouse.button === Qt.RightButton)
		{
			socialController.voiceButton.ShowContextMenu();
		}
	}

	iconOpacity: ButtonThemeOpacities
	{
		normal: 0.8
		hovered: 1.0
		pressed: 0.7
		disabled: 0.2
	}

	//: Tooltip for the voice button.
	toolTip: qsTr("Open voice channel");
	tipType: ToolTip.ArrowUp;
	onShowToolTip:
	{
		var centeredRect = util.globalGeometry(voiceButton.icon);
		var anchorRect = util.globalGeometry(voiceButton);
		anchorRect.y -= 5;
		appController.ShowToolTipExplicit(centeredRect, voiceButton.toolTip, voiceButton.tipType, self, anchorRect, voiceButton.noDelay, false, true);
	}
}
