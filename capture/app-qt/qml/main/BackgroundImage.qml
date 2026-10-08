import QtQuick 2.2
import Phoenix 1.0

import "../common"

Item
{
	id: base;

	property int topOffset: 0;
	property bool centerImage: true;
	property bool showVignette: true;
	property string backgroundImage: "";
	property color backgroundColor: "#00000000";

	Rectangle
	{
		id: solidBackground;

		anchors.fill: parent;
		anchors.margins: 0;

		color: backgroundColor;
	}

	Image
	{
		id: image;

		anchors.top: parent.top;
		anchors.topMargin: base.topOffset;

		source: base.backgroundImage;
	}

	Image
	{
		id: vignette;
		source: "../images/back_vignette.png";
		anchors.fill: parent;

		visible: base.showVignette;
	}

	states:
	[
		State
		{
			name: "normal";
			when: base.centerImage === false;
		},
		State
		{
			name: "centered";
			when: base.centerImage === true;

			AnchorChanges {
				target: image;
				anchors.horizontalCenter: parent.horizontalCenter;
			}
		}
	]
}