import QtQuick 2.2
import Phoenix 1.0 as Phoenix

Phoenix.ToolTipMouseArea
{
	id: container
	property variant progressObject

	property bool on: false
	enabled: on
	visible: progressObject.displayMode !== Phoenix.Progress.ShowNextPatchIcon
		&& progressObject.displayMode !== Phoenix.Progress.ShowNextPatchSpinner;

	onOnChanged:
	{
		if (!container.on && appController.IsToolTipVisible())
		{
			if (util.mouseHoverOver(container))
			{
				util.hideToolTip();
			}
		}
	}

	//==========================================================================
	// Pulsing Icon
	//==========================================================================
	implicitWidth: pulsingIcon.implicitWidth; height: pulsingIcon.implicitHeight
	PulsingIcon
	{
		id: pulsingIcon
		source: progressObject.networkWarningType === Phoenix.Progress.Critical
			? "../images/icon_warning_red.png" : "../images/icon_warning_hover.png"
		pulsing: container.on
	}

	//==========================================================================
	// Transition for showing/hiding the icon
	//==========================================================================
	opacity: container.on ? 1.0 : 0.0
	Behavior on opacity { NumberAnimation { properties: "opacity"; duration: 200;  } }

	//==========================================================================
	// ToolTip
	//==========================================================================
	toolTip: progressObject.networkWarningToolTip
	noDelay: true
	tipType: Phoenix.ToolTip.ArrowDown | Phoenix.ToolTip.ArrowAtLeft
	onShowToolTip:
	{
		util.showToolTip(container, container, container.toolTip, container.tipType, container.noDelay, popupMode)
	}
}
