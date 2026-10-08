import QtQuick 2.2

Item
{
	//==========================================================================
	// Input Parameters
	//==========================================================================
	property bool hasFocus: self.isActive;
	property variant controlMouseArea
	property variant closeMouseArea
	property variant maxMouseArea
	property variant minMouseArea

	//==========================================================================
	// Internal properties
	//==========================================================================
	property real _normalOpacity: 1.0;
	property real _fadedOpacity: 1.0;
	property real _hoveredOpacity: 1.0;
	property real _pressedOpacity: 1.0;
	property string _disabledImage: "../images/btn_mac_disabled.png";

	//==========================================================================
	// Output Parameters
	//==========================================================================
	property ButtonStateProperies closeButtonProperties: ButtonStateProperies
	{
		normal		{ value: "../controls/btn_win_close_normal.png"; opacity: _normalOpacity }
		pressed		{ value: "../controls/btn_win_close_pressed.png"; opacity: _pressedOpacity; offsetX: 0; offsetY: 0; }
		hovered		{ value: "../controls/btn_win_close_hover.png"; opacity: _hoveredOpacity }
		disabled	{ value: "../controls/btn_win_close_disabled.png"; opacity: _fadedOpacity }
	}

	property ButtonStateProperies maxButtonProperties: ButtonStateProperies
	{
		normal		{ value: self.maximized ? "../controls/btn_win_restore_normal.png"	: "../controls/btn_win_maximize_normal.png"; opacity: _normalOpacity }
		pressed		{ value: self.maximized ? "../controls/btn_win_restore_pressed.png"	: "../controls/btn_win_maximize_pressed.png"; opacity: _pressedOpacity; offsetX: 0; offsetY: 0; }
		hovered		{ value: self.maximized ? "../controls/btn_win_restore_hover.png"	: "../controls/btn_win_maximize_hover.png"; opacity: _hoveredOpacity }
		disabled	{ value: self.maximized ? "../controls/btn_win_restore_disabled.png": "../controls/btn_win_maximize_disabled.png"; opacity: _fadedOpacity }
	}

	property ButtonStateProperies minButtonProperties: ButtonStateProperies
	{
		normal		{ value: "../controls/btn_win_minimize_normal.png"; opacity: _normalOpacity }
		pressed		{ value: "../controls/btn_win_minimize_pressed.png"; opacity: _pressedOpacity; offsetX: 0; offsetY: 0; }
		hovered		{ value: "../controls/btn_win_minimize_hover.png"; opacity: _hoveredOpacity }
		disabled	{ value: "../controls/btn_win_minimize_disabled.png"; opacity: _fadedOpacity }
	}

	property int outerMargin: 0
	property int innerMargin: 0
	property int topMargin: 0

	property int layoutDirection: Qt.LeftToRight

	property string closeButtonState
	property string minButtonState
	property string maxButtonState

	//==========================================================================
	// Button States
	//==========================================================================
	closeButtonState:
	{
		if (closeMouseArea.pressed)
			return "pressed";
		else if (closeMouseArea.containsMouse)
			return "hovered";
		else
			return "normal";
	}

	minButtonState:
	{
		if (minMouseArea.pressed)
			return "pressed";
		else if (minMouseArea.containsMouse)
			return "hovered";
		else
			return "normal";
	}

	maxButtonState:
	{
		if (maxMouseArea.pressed)
			return "pressed";
		else if (maxMouseArea.containsMouse)
			return "hovered";
		else
			return "normal";
	}
}
