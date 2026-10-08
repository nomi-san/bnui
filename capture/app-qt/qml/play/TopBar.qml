import QtQuick 2.2
import "../common"

Item
{
	id: container
	property variant view

	property int minHeight: 43
	property int maxHeight: 180

	property bool _shrink: height < maxHeight

	property string logoUrl: {
		if (!view.product) {
			return "";
		}

		if (view.account && view.account.isTrial && view.product.trialLogoUrl) {
			return view.product.trialLogoUrl;
		}

		return view.product.logoUrl;
	}

	//==========================================================================
	// layout properties
	//==========================================================================
	QtObject
	{
		id: internal

		property int logoRightMargin: 20

		property int titleTopShift: 0
		property int titleLeftMargin: 45
		property int titleRightMargin: 45
		property int titleBottomShift: 50

		property int gameMenuTopMargin: _shrink ? 8 : 145;
		property int gameMenuLeftMargin: 50
	}

	Item
	{
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.bottom: topBarGameMenus.top
		width: 350

		Text
		{
			visible: {
				if (!view.product) {
					return false;
				}
				return !container.logoUrl;
			}
			text: {
				if (!view.product) {
					return "";
				}
				return view.product.productName;
			}
			color: "#ffffff"

			font.pointSize: 24
			layer.smooth: true

			anchors.centerIn: parent
			opacity: _shrink ? 0 : 1
			Behavior on opacity { NumberAnimation { duration: 150; } }
		}
	}

	//==========================================================================
	// Game Logo
	//==========================================================================
	Item
	{
		id: logo

		// layout
		anchors
		{
			left: parent.left
			top: parent.top
			topMargin: -40
			rightMargin: internal.logoRightMargin
		}

		//implicitWidth: 360
		//implicitHeight: 212

		Image
		{
			source: {
				if (!container.logoUrl) {
					return "";
				}
				return util.fromCatalog(container.logoUrl);
			}
			opacity: _shrink ? 0 : 1
			Behavior on opacity { NumberAnimation { duration: 150; } }
		}
	}

	DevelopmentRibbon
	{
		id: badge

		anchors.left: parent.left
		anchors.top: parent.top

		property string colors: {
			if (!view.product) {
				return "";
			}
			return view.product.ribbonColors;
		}
		onColorsChanged: {
			var parts = badge.colors.split(',');
			if (parts.length == 2) {
				badge.color1 = parts[0];
				badge.color2 = parts[1];
			} else {
				badge.color1 = _defaultColor1;
				badge.color2 = _defaultColor2;
			}
		}

		scaleFactor: _shrink ? 0.75 : 1.0
		Behavior on scaleFactor { NumberAnimation { duration: 100; }}

		text: {
			if (!view.product) {
				return "";
			}
			return view.product.ribbonText;
		}
	}

	//==========================================================================
	// Game Title & Menus
	//==========================================================================
	Rectangle
	{
		anchors {
			centerIn: topBarGameMenus
		}

		width: topBarGameMenus.width + 20
		height: topBarGameMenus.height + 10

		color: playView.backgroundColor
		opacity: 0.5
		radius: 2
	}

	TopBarGameMenus
	{
		id: topBarGameMenus
		view: container.view

		anchors
		{
			top: parent.top
			left: parent.left

			topMargin: internal.gameMenuTopMargin + 10
			leftMargin: internal.gameMenuLeftMargin + 10
		}

		Behavior on anchors.topMargin { NumberAnimation { duration: 100; } }
	}
}
