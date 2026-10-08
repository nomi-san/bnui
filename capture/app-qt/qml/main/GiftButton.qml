import QtQuick 2.2
import Phoenix 1.0
import "../common"

Button
{
	id: giftButton

	width: 44
	height: 32
	bSpacer: -1
	backgroundImages: ButtonThemeImages {}

	// If we have new unviewed inventory we use a different image and opacities
	property bool hasUnviewedInventory: inventoryController.unviewedInventoryCount > 0;

	rotation: hasUnviewedInventory ? rotationValue : 0
	y: hasUnviewedInventory ? yValue : 0

	property real rotationValue: 0
	property real yValue: 0

	property string normalImage: hasUnviewedInventory ? "../images/menu-gift-new-normal.png" : 
		"../images/menu-gift-normal.png";
	property string hoverImage: hasUnviewedInventory ? "../images/menu-gift-new-hover.png" :
		"../images/menu-gift-normal.png";
	property string pressedImage: hasUnviewedInventory ? "../images/menu-gift-new-pressed.png" :
		"../images/menu-gift-normal.png";

	property int rotationDuration: 55
	property int angle: 6
	property variant easingType: Easing.OutQuad;

	SequentialAnimation on rotationValue {
		running: hasUnviewedInventory
		loops: Animation.Infinite

		SequentialAnimation {
			loops: 3
			// Clockwise from center to angle.
			NumberAnimation {
				easing.type: Easing.OutQuad
				from: 0
				to: angle
				duration: rotationDuration
			}

			// Counter clockwise back to center.
			NumberAnimation {
				easing.type: Easing.InQuad
				from: angle
				to: 0
				duration: rotationDuration
			}

			// Counter clockwise from center to -angle.
			NumberAnimation {
				easing.type: Easing.OutQuad
				from: 0
				to: -angle
				duration: rotationDuration
			}

			// Clockwise back to center from -angle.
			NumberAnimation {
				easing.type: Easing.InQuad
				from: -angle
				to: 0
				duration: rotationDuration
			}
		}
		PauseAnimation { duration: 750 }
	}

	property int verticalDistance: 2;
	property int bounceDuration: 200;

	SequentialAnimation on yValue {
		loops: Animation.Infinite
		running: hasUnviewedInventory

		// Move up from starting position to verticalDistance.
		NumberAnimation {
			from: 0
			to: verticalDistance
			duration: bounceDuration
		}

		// Move back down to starting position from verticalDistance.
		NumberAnimation {
			from: verticalDistance
			to: 0
			duration: bounceDuration
		}
	}

	iconSource:
	{
		if (giftButton.pressed)
			return pressedImage;
		else if (giftButton.hovered)
			return hoverImage;
		return normalImage;
	}

	onClicked: inventoryController.GiftButtonClicked("GiftIcon");

	// With unviewed inventory the icon contains a "dot" which we do not want opacity applied to.
	// So the opacity is baked into unviewed inventory images
	// Our gift icon without the "dot" does not need this treatment
	iconOpacity: ButtonThemeOpacities
	{
		normal: hasUnviewedInventory ? 1.0 : 0.6
		hovered: hasUnviewedInventory ? 1.0 : 0.8
		pressed: hasUnviewedInventory ? 1.0 : 0.4
		disabled: 0.2
	}

	toolTip: qsTr("You have unclaimed gifts");
	tipType: ToolTip.ArrowUp;
	onShowToolTip:
	{
		var centeredRect = util.globalGeometry(giftButton.icon);
		var anchorRect = util.globalGeometry(giftButton);
		anchorRect.y -= 5;
		appController.ShowToolTipExplicit(centeredRect, giftButton.toolTip, giftButton.tipType, self, anchorRect, giftButton.noDelay, false, true);
	}
}
