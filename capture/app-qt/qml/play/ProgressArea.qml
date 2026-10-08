import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

Item
{
	id: progressArea
	property variant progressObject

	height: progressBar.height + 8 // progressTooltip margin * 2 to match

	//==========================================================================
	// Progress Bar
	//==========================================================================
	ProgressBarLoader
	{
		id: progressBar

		anchors
		{
			left: parent.left
			right: parent.right
			verticalCenter: parent.verticalCenter
		}

		ProgressThemeLoader
		{
			id: progressThemeLoader
			currentTheme: progressObject.theme
		}

		theme: progressThemeLoader.item
		value: progressObject.progress
		showAsPaused: progressObject.showAsPaused
		visible: true;
	}

	//==========================================================================
	// Persistent ToolTip
	//==========================================================================
	Spacer
	{
		id: balloonTarget
		anchors
		{
			left: progressBar.left
			bottom: progressBar.top
		}
	}

	SimpleLoader
	{
		id: persistentToolTip

		property int _clipPadding: 15
		property int _desiredX: balloonTarget.x - 20
		property int _desiredY: item ? balloonTarget.y - item.height - _bottomPadding : 0
		property int _bottomPadding: 21

		// When this is about to be clipped, push it inside
		x:
		{
			if (!persistentToolTip.visible)
				return 0;

			if (parent.mapToItem(window, _desiredX + width, 0).x < window.width)
				return _desiredX - _clipPadding;
			else
				parent.mapFromItem(window, window.width - item.width, 0).x - _clipPadding
		}

		y: _desiredY

		component: BalloonMessage
		{
			target: balloonTarget
			textItem.text: progressObject.toolTip
			onCloseButtonClicked: progressObject.PersistentToolTipClosed();
		}

		visible: progressObject.toolTipType === Phoenix.Progress.PersistentToolTip
	}

	//==========================================================================
	// Progress Markers
	//==========================================================================
	ProgressBarMarkerArea
	{
		id: progressMarkers

		progressObject: progressArea.progressObject
		thresholds: progressArea.progressObject.thresholds
		anchors.fill: progressBar
		anchors.leftMargin: progressThemeLoader.item.maskLeftBorderWidth
		visible: progressArea.progressObject.markerVisible
	}

	//==========================================================================
	// Progress Tooltip
	//==========================================================================
	Phoenix.ToolTipMouseArea
	{
		id: progressTooltip

		anchors
		{
			left: parent.left
			right: progressBar.right
			top: parent.top
			bottom: parent.bottom
		}

		// Set the tooltip value so that showToolTip signal fires, however we'll
		// get and use the tooltip from the progressObject when we actually need to show it.
		//: Tooltip for the progress area.
		toolTip: qsTr("Unused")
		tipType: Phoenix.ToolTip.ArrowDown | Phoenix.ToolTip.BorderBlue
		noDelay: true
		// Don't show mouse hover tooltip when persistent toolTip is visible
		visible: progressObject.toolTipType === Phoenix.Progress.NormalToolTip
		enabled: progressTooltip.visible
		hoverEnabled: true

		function displayToolTip(popupMode)
		{
			var centeredRect = util.globalGeometry(progressBar);
			centeredRect.x += progressBar.width * progressBar.value;
			centeredRect.width = 1;
			var anchorRect = util.globalGeometry(progressBar);

			var adjustedTipType = progressTooltip.tipType;
			if (progressBar.value > 0.5)
				adjustedTipType |= Phoenix.ToolTip.ArrowAtRight
			else
				adjustedTipType |= Phoenix.ToolTip.ArrowAtLeft

			appController.ShowToolTipExplicit(centeredRect, progressObject.toolTip, adjustedTipType, self,
									  anchorRect, noDelay, popupMode, true);
		}

		onShowToolTip: displayToolTip(popupMode)

		// When tooltip is visible and mouse is inside of Progress Area
		// Update tooltip whenever actual text changes.

		Connections
		{
			target: progressObject
			function onTooltipChanged() {
				if (progressTooltip.containsMouse && appController.IsToolTipVisible()
					&& (progressObject.displayMode === Phoenix.Progress.ShowProgressBar
						|| progressObject.displayMode === Phoenix.Progress.ShowRepairProgressBar))
						progressTooltip.displayToolTip(false);
			}
		}
	}

	//==========================================================================
	// Status Text
	//==========================================================================
	TextBusyArea
	{
		id: statusText

		// Replace all '|' characters with \u009C as this is a multi-length string.
		// This property caches progress object provided status text.
		statusText: progressObject.statusText.replace(/\|/g, "\u009C");
		running: progressObject.statusTextHasDots

		anchors
		{
			left: progressBar.left
			leftMargin: 10
			right: parent.right
			rightMargin: 5
			verticalCenter: progressBar.verticalCenter
			verticalCenterOffset: -1
		}

		visible: true

		layer.enabled: true
		layer.effect: DropShadowEffect {}
	}

	Component.onDestruction:
	{
		if (progressTooltip.containsMouse && appController.IsToolTipVisible())
			util.hideToolTip();
	}
}
