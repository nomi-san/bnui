import QtQuick 2.2
import Phoenix 1.0 as Phoenix

Item
{
	id: container

	property alias text: text
	property alias model: popup.model
	property alias selectedIndex: popup.selectedIndex
	property alias maxVisibleItems: popup.maxVisibleItems

	property alias tipType: buttonBehavior.tipType
	property alias toolTip: buttonBehavior.toolTip
	property alias noDelay: buttonBehavior.noDelay

	property int horizontalPadding: 10
	property int verticalPadding: 9

	property alias dropDownImage: dropDownImage
	property alias contentsHeight: contents.height
	property alias contentsAnchors: contents.anchors

	height: contents.height
	width: 150

	//==========================================================================
	// Signals
	//==========================================================================
	signal showToolTip()

	//==========================================================================
	// Background Border
	//==========================================================================
	ButtonStateBorder
	{
		anchors.fill: parent

		border { top: 2; right: 2; bottom: 2; left: 2; }

		// Button State
		buttonState: buttonBehavior.buttonState
		buttonProperties: ButtonStateProperies
		{
			activated
			{
				value: popup.showPopupOnTop
					? "../controls/input_active_popup_flip.png"
					: "../controls/input_active_popup.png";
				opacity: 1.0
			}
			normal    { value: "../controls/input_normal.png";   opacity: 1.0 }
			pressed   { value: "../controls/input_normal.png";   opacity: 1.0 }
			hovered   { value: "../controls/input_hover.png";    opacity: 1.0 }
			disabled  { value: "../controls/input_disabled.png"; opacity: 1.0 }
		}
	}

	//==========================================================================
	// Contents
	//==========================================================================
	Item
	{
		id: contents

		// horizontal layout
		anchors
		{
			left: parent.left
			right: parent.right
			leftMargin: horizontalPadding
			rightMargin: horizontalPadding
		}
		// vertical layout
		height: text.height + verticalPadding * 2

		ButtonStateText
		{
			id: text

			// anchors left and right so that this text can be elided if necessary
			anchors
			{
				verticalCenter: parent.verticalCenter
				left: parent.left
				right: dropDownImage.left
				rightMargin: 5
			}

			// text properties
			elide: Text.ElideRight
			text: popup.selectedItemText
			font.family: fonts.regularFont.name
			font.pixelSize: 13

			// Button State
			buttonState: buttonBehavior.buttonState
			buttonProperties: ButtonStateProperies
			{
				activated	{ opacity: 1.0; color: "#ffffff" }
				normal		{ opacity: 0.9; color: "#ffffff" }
				pressed		{ opacity: 0.8; color: "#ffffff" }
				hovered		{ opacity: 1.0; color: "#ffffff" }
				disabled	{ opacity: 0.2; color: "#ffffff" }
			}
		}

		ButtonStateImage
		{
			id: dropDownImage

			// Anchor to right and use image height
			anchors
			{
				verticalCenter: parent.verticalCenter
				right: parent.right
			}

			// Button State
			buttonState: buttonBehavior.getButtonState();
			buttonProperties: ButtonStateProperies
			{
				activated { value: "../controls/icon_combo_selector.png"; opacity: 1.0 }
				normal    { value: "../controls/icon_combo_selector.png"; opacity: 0.8 }
				pressed   { value: "../controls/icon_combo_selector.png"; opacity: 0.6 }
				disabled  { value: "../controls/icon_combo_selector.png"; opacity: 0.1 }
				hovered   { value: "../controls/icon_combo_selector.png"; opacity: 1.0 }
			}
		}
	}

	Phoenix.StyledMenu
	{
		id: popup
		anchors.fill: parent
		cycleThroughIndex: false
		showPopupOnTop: true

		function openPopup()
		{
			container.forceActiveFocus();
			var rect = util.globalGeometry(popup);
			var centeredRect = util.globalGeometry(popup);
			var tipType = Phoenix.ToolTip.NoArrow | Phoenix.ToolTip.BorderComboBox;
			popup.showPopup(centeredRect, rect, tipType);
		}
	}

	ButtonBehavior
	{
		id: buttonBehavior
		enabled: container.enabled

		// Overide deafault button state so that pressing combobox doesn't change
		// border image.
		buttonState: buttonBehavior.getButtonState()
		function getButtonState()
		{
			var state = "";

			if (popup.isOpen)
				state = "activated";
			else if (buttonBehavior.containsMouse)
				state = "hovered";
			else if (!buttonBehavior.enabled)
				state = "disabled";

			return state;
		}

		onPressed:
		{
			if (popup.isOpen)
				return;

			popup.openPopup();
		}
		onShowToolTip: container.showToolTip()
	}

	Keys.enabled: container.visible
	Keys.onUpPressed: { popup.decrementCurrentIndex() }
	Keys.onDownPressed: { popup.incrementCurrentIndex() }
	Keys.onSpacePressed: { popup.openPopup() }
}
