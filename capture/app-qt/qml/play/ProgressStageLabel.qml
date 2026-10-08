import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

Item
{
	id: container

	//==========================================================================
	// Properties
	//==========================================================================
	property string tipPosition: "topLeft"
	property variant stage
	property variant status
	property color activeColor
	property alias text: labelText.text
	property alias toolTip: tooltipItem.toolTip
	property alias tipType: tooltipItem.tipType
	property alias noDelay: tooltipItem.noDelay
	property string imagePrefix
	signal showToolTip(bool popupMode)
	imagePrefix:
	{
		if (stage ===  Phoenix.GameProductState.Playable)
			return "yellow";
		else
			return "green";
	}


	//==========================================================================
	// Layout properties
	//==========================================================================
	width: labelText.width - tooltipItem.anchors.leftMargin - tooltipItem.anchors.rightMargin// padding
	height: tip.tipSize + labelText.height - tooltipItem.anchors.topMargin - tooltipItem.anchors.bottomMargin// padding

	//==========================================================================
	// ToolTipItem
	//==========================================================================
	Phoenix.ToolTipMouseArea
	{
		id: tooltipItem

		anchors.fill: labelText
		anchors.topMargin: -8
		anchors.bottomMargin: -8
		anchors.leftMargin: -15
		anchors.rightMargin: -15

		onShowToolTip: container.showToolTip(popupMode)
	}

	//==========================================================================
	// Background
	//==========================================================================
	BorderImage
	{
		id: tip

		property int topAdjust: tipSize
		property int bottomAdjust: 0

		property int tipSize: 8

		source: "../images/stageLabel_border_" + imagePrefix + "_up.png"

		anchors.fill: parent

		border.left: tipSize;
		border.top: topAdjust + 1
		border.right: 1;
		border.bottom: bottomAdjust + 1

		horizontalTileMode: BorderImage.Repeat
		verticalTileMode: BorderImage.Repeat
	}

	//==========================================================================
	// Contents
	//==========================================================================
	ProgressStageLabelText
	{
		id: labelText
		anchors.centerIn: tip
		anchors.verticalCenterOffset: tip.tipSize / 2
		color: activeColor
	}

	//==========================================================================
	// States
	//==========================================================================
	states: [
		State
		{
			name: "topLeft"
			when: tipPosition === "topLeft"
			PropertyChanges
			{
				target: tip
				source: "../images/stageLabel_border_" + imagePrefix + "_up.png"

				topAdjust: tipSize
				bottomAdjust: 0
			}
			PropertyChanges
			{
				target: labelText
				anchors.verticalCenterOffset: tip.tipSize / 2
			}
		},
		State
		{
			name: "topRight"
			when: tipPosition === "topRight"
			PropertyChanges
			{
				target: tip
				source: "../images/stageLabel_border_" + imagePrefix + "_up.png"

				topAdjust: tipSize
				bottomAdjust: 0
				mirror: true
			}
			PropertyChanges
			{
				target: labelText
				anchors.verticalCenterOffset: tip.tipSize / 2
			}
		},
		State
		{
			name: "bottomLeft"
			when: tipPosition === "bottomLeft"
			PropertyChanges
			{
				target: tip
				source: "../images/stageLabel_border_" + imagePrefix + "_down.png"

				topAdjust: 0
				bottomAdjust: tipSize
			}
			PropertyChanges
			{
				target: labelText
				anchors.verticalCenterOffset: -tip.tipSize / 2
			}
		},
		State
		{
			name: "bottomRight"
			when: tipPosition === "bottomRight"
			PropertyChanges
			{
				target: tip
				source: "../images/stageLabel_border_" + imagePrefix + "_down.png"

				topAdjust: 0
				bottomAdjust: tipSize
				mirror: true
			}
			PropertyChanges
			{
				target: labelText
				anchors.verticalCenterOffset: -tip.tipSize / 2
			}
		}
	]
}
