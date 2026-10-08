import QtQuick 2.2
import Phoenix 1.0

import "../common"
import "../main"
import "../common/util.js" as Util

WindowRoot
{
	id: window

	rootWindow.minWidth: minWidth
	rootWindow.minHeight: minHeight

	property int minWidth: 720
	property int minHeight: 540
	property variant currentGame;
	property string gameBackground: ""
	property alias mainDragRegion: mainDragRegion

	// These specify when we start changing values specified via
	// shiftWhen{Width,Height}IsSamll(...) functions.
	property int reductionBorderForWidth: 860
	property int reductionBorderForHeight: 560

	property int screenIndex_Controls: 1
	property int screenIndex_Browser: 2

	BackgroundImage
	{
		id: backgroundImage
		backgroundColor: "#14121d"
		backgroundImage: "../catalog_images/background_heroes.jpg"

		anchors.fill: parent
		topOffset: topNav.topAreaOffset
	}

	Item
	{
		id: util

		function isMac() { return false; }

		function globalGeometry(item)
		{
			return self.GetGlobalRect(item);
		}

		function showToolTip(mouseArea, centeredItem, tooltipText, arrowDirection, noDelay, popupMode, enableHtml)
		{
			if (typeof arrowDirection === 'undefined')
			{
				arrowDirection = ToolTip.ArrowDown;
			}

			if (typeof popupMode === 'undefined')
			{
				popupMode = false;
			}

			if (typeof noDelay === 'undefined')
			{
				noDelay = false;
			}

			if (typeof enableHtml === 'undefined')
			{
				enableHtml = true;
			}

			var centeredRect = globalGeometry(centeredItem);
			var anchorRect = globalGeometry(mouseArea);

			helpers.ShowToolTipExplicit(centeredRect, tooltipText, arrowDirection, self, anchorRect, noDelay, popupMode, enableHtml);
		}
	}

	Item
	{
		id: fonts

		property alias lightFont: lightFont
		property alias regularFont: regularFont

		FontLoader
		{
			id: lightFont
			name: "Blizzard Light"
		}
		FontLoader
		{
			id: regularFont
			name: "Blizzard"
		}
	}

	width: 1200
	height: 750

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

		Item
		{
			id: topNav

			height: topPaddingSize + contentSize + topAreaOffset - topMarginBackgroundPadding

			property int topPaddingSize: 20
			property int contentSize: 60

			property int topAreaOffset: (util.isMac() ?
					(/* added height of title bar */ 5 -
					 /* inset titlebar into window */ 21) : 1);
			property int topMarginBackgroundPadding: util.isMac() ? 0 : 1

			anchors.left: parent.left
			anchors.right: parent.right
			anchors.top: parent.top

			// Brighten the top area
			Rectangle
			{
				anchors.fill: parent
				color: "white"
				opacity: 0.05
			}

			Rectangle
			{
				// this is the horizontal line across the top nav area
				height: 1
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.bottom: parent.bottom
				color: "#ffffff"
				opacity: 0.07
			}

			Row
			{
				id: menuItems

				anchors
				{
					left: parent.left
					leftMargin: 22
					bottom: parent.bottom
					bottomMargin: 18
				}

				spacing: 36

				NavButton
				{
					screenIndex: screenIndex_Controls
					text.text: "Controls"
				}

				NavButton
				{
					screenIndex: screenIndex_Browser
					text.text: "Browser"
				}
			}
		}

		Loader
		{
			id: contentLoader
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.topMargin: topNav.height + 25
			anchors.bottom: parent.bottom
			anchors.right: parent.right
			anchors.margins: 25
			visible: true
			focus: true

			source: {
				if (self.screenIndex == screenIndex_Controls) {
					return "ControlsTestPane.qml";
				}
				if (self.screenIndex == screenIndex_Browser) {
					return "BrowserTestPane.qml";
				}
				return "";
			}
		}

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
}
