import QtQuick 2.2
import Phoenix 1.0
import "../common"
import "../play"

Item
{
	id: battleNetButton
	width: bnetLogo.implicitWidth + bnetDropdown.width + 17
	height: bnetLogo.implicitHeight

	property string _bnetLogoImage_normal: "../images/img_blizzButton_normal_release.png"
	property string _bnetLogoImage_hovered:  "../images/img_blizzButton_hovered_release.png"

	property bool selfUpdateActive: appController.selfUpdateActive
	property double selfUpdateProgress: appController.selfUpdateProgress
	property int selfUpdateState: appController.selfUpdateState

	property int vOffsetMargin: 3

	anchors
	{
		left: parent.left
		leftMargin: 7
		top: parent.top
		topMargin: battleNetButton.vOffsetMargin + battleNetButton.vOffset
	}

	onSelfUpdateProgressChanged:
	{
		if (buttonBehavior.containsMouse && appController.IsToolTipVisible())
		{
			buttonBehavior.refreshTooltip();
		}
	}
	onSelfUpdateStateChanged:
	{
		if (buttonBehavior.containsMouse && appController.IsToolTipVisible())
		{
			buttonBehavior.refreshTooltip();
		}
	}


	Image
	{
		id: bnetLogo
		source: _bnetLogoImage_normal
		opacity: 1

		width: (util.isMac() && selfUpdateActive) ? bnetLogo.implicitWidth - 4 : bnetLogo.implicitWidth
		height: (util.isMac() && selfUpdateActive) ? bnetLogo.implicitHeight - 4 : bnetLogo.implicitHeight

		states:
		[

			State
			{
				name: "bnetButton_hovered"
				when: buttonBehavior.containsMouse
				PropertyChanges { target: bnetLogo; source: _bnetLogoImage_hovered }
				PropertyChanges { target: bnetDropdown; opacity: 1 }
			}
		]
	}

	Image
	{
		id: bnetDropdown

		anchors
		{
			left: bnetLogo.right
			leftMargin: -4
			top: bnetLogo.top
			topMargin: 21
		}

		source: "../images/arrow_down_blue.png"
		opacity: 0.8
	}

	GameTabProgressBar
	{
		id: selfUpdateProgressBar

		anchors.top: battleNetButton.top
		anchors.topMargin: -5 + bnetLogo.height
		height: 4
		width: 96

		anchors.horizontalCenter: battleNetButton.horizontalCenter
		anchors.horizontalCenterOffset: -15

		barColor: "#007cb3"

		opacity: selfUpdateActive ? 0.8 : 0
		visible: opacity > 0
		Behavior on opacity { NumberAnimation { duration: 200 }}

		value: selfUpdateProgress
	}

	ButtonBehavior
	{
		id: buttonBehavior
		onPressed:
		{
			var anchorRect = util.globalGeometry(buttonBehavior);
			var centeredRect = util.globalGeometry(bnetDropdown);
			anchorRect.height -= 13;
			anchorRect.x -= 13;
			anchorRect.y += 4;
			appController.ShowBNetMenu(centeredRect, anchorRect);
		}

		//: Tooltip for Battle.net button.
		toolTip: selfUpdateActive ? (selfUpdateState == 1003 ? qsTr("Applying Update...")
				: qsTr("Updating Battle.net... ")  + Math.round(selfUpdateProgress * 100).toString() + "%")
				: qsTr("Access Battle.net menu");

		tipType: ToolTip.ArrowUp
		onShowToolTip: refreshTooltip(popupMode);

		function refreshTooltip(popupMode)
		{
			if (selfUpdateActive)
			{
				var centeredRect = util.globalGeometry(selfUpdateProgressBar);
				var anchorRect = util.globalGeometry(selfUpdateProgressBar);
				anchorRect.y -= 2;
				appController.ShowToolTipExplicit(centeredRect, buttonBehavior.toolTip, buttonBehavior.tipType, self, anchorRect, buttonBehavior.noDelay, popupMode, true);
			}
			else
			{
				var centeredRect = util.globalGeometry(bnetDropdown);
				var anchorRect = util.globalGeometry(buttonBehavior);
				anchorRect.height -= 25;
				anchorRect.x -= 20;
				// Shift the tooltip down below the button so it doesn't overlap the button area.
				// If this isn't done, the tooltip can blink in and out rapidly.
				anchorRect.y += 16;
				appController.ShowToolTipExplicit(centeredRect, buttonBehavior.toolTip, buttonBehavior.tipType, self, anchorRect, buttonBehavior.noDelay, popupMode, true);
			}
		}
	}
}
