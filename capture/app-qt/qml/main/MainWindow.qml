import QtQuick 2.2
import Phoenix 1.0

import "../common"
import "../common/util.js" as Util

WindowRoot
{
	id: window

	property variant currentGame;
	property string gameBackground: ""
	property alias mainDragRegion: mainDragRegion

	// These specify when we start changing values specified via
	// shiftWhen{Width,Height}IsSamll(...) functions.
	property int reductionBorderForWidth: 860
	property int reductionBorderForHeight: 560

	property alias background: backgroundImage
	property alias centerScreen: centerScreenItem

	property bool topNavOnTop: false

	property bool _raiseTopNav: loginController.showOfflineBalloon || topNavOnTop

	function hideNotificationMenu()
	{
		notificationController.showNotificationMenu = false
	}

	BackgroundImage
	{
		id: backgroundImage

		anchors.fill: parent

		topOffset: topNav.topAreaOffset
	}

	WindowFrame
	{
		id: windowFrame

		detailBar.anchors.leftMargin: 105
		detailBar.anchors.rightMargin: 105
		detailBar.visible: !util.isMac();
	}

	Item
	{
		id: mainScreen

		anchors.fill: parent
		anchors.margins: util.isMac() ? 0 : 1

		property int topNavHeight: topNav.height

		Item
		{
			id: mainDragRegion

			anchors.top: parent.top
			anchors.topMargin: -2
			anchors.left: parent.left
			anchors.leftMargin: -2
			anchors.right: parent.right
			anchors.rightMargin: -2
			height: topNav.height

			WindowDragRegion
			{
				anchors.fill: mainDragRegion
				window: self
				enabled: !util.isMac()
			}
		}

		TopNav
		{
			id: topNav
			anchors
			{
				top: parent.top
				left: parent.left
				right: parent.right
			}

			// Related to Bug 9434, 9614
			// Raising TopNav's z-order causes RegionSwitchWarning balloon shows behind top nav menus
			// in the minimum size in deDE or ruRU locale. Thus, raise this z-oder only when it's needed.
			// In offline mode, region switch warning won't be displayed.
			z: _raiseTopNav ? 1 : 0
		}

		Image
		{
			id: betaRibbon

			anchors.left: parent.left
			anchors.top: parent.top

			source: { return appController.isBeta ? "../images/ribbons/" + appController.betaRibbon : ""; }
			visible: appController.isBeta
		}

		CenterScreen
		{
			id: centerScreenItem

			// When TopNav is raised, prevent any content from CenterScreen overlap with TopNav area.
			// i.e. Any Balloon messages. It's better to clip it than being overlapped.
			clip: topNav.z > centerScreen.z

			anchors
			{
				top: topNav.bottom
				bottom: parent.bottom
				left: parent.left
				right: parent.right
			}

			topNavHeight: topNav.height
		}

		DimmingArea { id: dimmingArea }

		ResizeGrip
		{
			id: resizeGrip

			bottomRightGrip.anchors.bottomMargin: -2
			bottomRightGrip.anchors.rightMargin: -2

			visible: !util.isMac();
		}

		WindowControl
		{
			allowMaximize: true
			onCloseClicked: window.rootWindow.close()

			visible: !util.isMac();
		}
	}

	// Global Objects
	Fonts { id: fonts }
	Util { id: util }

	function shiftWhenWidthIsSmall(value, targetValue)
	{
		if (!this.width || this.width >= reductionBorderForWidth)
			return value;

		var maxShift = value - targetValue;
		var maxWidthReduction = reductionBorderForWidth - this.minWidth;
		var currentWidthReduction = reductionBorderForWidth - this.width;

		var shiftCoeff = currentWidthReduction / maxWidthReduction;
		var shift = maxShift * shiftCoeff;

		return Math.floor(value - shift);
	}

	function shiftWhenHeightIsSmall(value, targetValue)
	{
		if (!this.height || this.height >= reductionBorderForHeight)
			return value;

		var maxShift = value - targetValue;
		var maxHeightReduction = reductionBorderForHeight - rootWindow.minHeight;
		var currentHeightReduction = reductionBorderForHeight - this.height;

		var shiftCoeff = currentHeightReduction / maxHeightReduction;
		var shift = maxShift * shiftCoeff;

		return Math.floor(value - shift);
	}


	property bool active: rootWindow.active

	// Handle window losing focus
	onActiveChanged:
	{
		if (!window.active && notificationController.closeOnActiveChanged)
		{
			hideNotificationMenu()
		}
	}

	// Hide menu on Native window clicks
	rootWindow.onNativeWindowClicked:
	{
		hideNotificationMenu()
	}
}
