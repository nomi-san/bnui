import QtQuick 2.2

Item
{
    //==========================================================================
    // Background BorderImage properties
    //==========================================================================
	property string backgroundSource: "../images/progressbar_tall_empty.png"
	property int	backgroundBorderLeft: 2
	property int	backgroundBorderRight: 2

    // Designated background width
    // If you want to use fixed size image for Progress Image,
    // you have to calculate background width from it. Refer to particle theme.
	property int backgroundWidth: 100

	//==========================================================================
	// Progress Bar Body Image properties
	//==========================================================================
	property string bodySource: "../images/progressbar_tall_bar_blue.png"
	property int bodyBorderSize: 14
	property int bodyHMargin: -6
	property int bodyVMargin: -6

	//==========================================================================
	// Progress Bar Completed Flash Effect
	//==========================================================================
	property string flashSource: "../images/progressbar_tall_complete.png"
	property int flashBorderSize: 12
	property int flashHMargin: -6

    //==========================================================================
    // Images for Progress Bar Effects
    //==========================================================================
	property string pulseSource:  "../images/progressbar_tall_pulse_blue.png"
	property string pulseLineSource: "../images/progressbar_pulse_line.png"
	property string leadSource: "../images/progressbar_tall_lead_blue.png"
	property int leadImageHeight: 50
	property int leadImageOffsetX: 8

    //==========================================================================
	// Progress Bar Mask properties
    //==========================================================================
	property int effectMargin: 1

	// Width of closer image on the left side.
	property int maskLeftBorderWidth: 2
}
