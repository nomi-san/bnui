import QtQuick 2.2
import Phoenix 1.0

Item
{
	id: toggleButton

	width: background.width
	height: background.height

	property bool on: false
	property alias hoverEnabled: mouseArea.hoverEnabled
	property alias containsMouse: mouseArea.containsMouse
	property alias backgroundImage: background
	property Image checkedOff
	property Image checkedOver
	property Image checkedDown
	property Image uncheckedOff
	property Image uncheckedOver
	property Image uncheckedDown
	property alias toolTip: mouseArea.toolTip

	signal clicked()
	signal entered()
	signal hoveredChanged()
	signal showToolTip();

	Image
	{
		id: background
		opacity: 0.8

		states:
		[
			State
			{
				name: "checkeddown"
				when: mouseArea.pressed && on
				PropertyChanges { target: background; opacity: 1 }
				PropertyChanges { target: background; source: checkedDown.source }
			},
			State
			{
				name: "uncheckeddown"
				when: mouseArea.pressed && !on
				PropertyChanges { target: background; opacity: 1 }
				PropertyChanges { target: background; source: uncheckedDown.source }
			},

			State
			{
				name: "checkedhovered"
				when: mouseArea.containsMouse && on
				PropertyChanges { target: background; opacity: 1 }
				PropertyChanges { target: background; source: checkedOver.source }
			},
			State
			{
				name: "uncheckedhovered"
				when: mouseArea.containsMouse && !on
				PropertyChanges { target: background; opacity: 1 }
				PropertyChanges { target: background; source: uncheckedOver.source }
			},
			State
			{
				name: "checkedoff"
				when: on
				PropertyChanges { target: background; opacity: 0.8 }
				PropertyChanges { target: background; source: checkedOff.source }
			},
			State
			{
				name: "uncheckedoff"
				when: !on
				PropertyChanges { target: background; opacity: 0.5 }
				PropertyChanges { target: background; source: uncheckedOff.source }
			}
		]
	}

	ButtonBehavior
	{
		id: mouseArea
		anchors.fill: background;
		onClicked: toggleButton.clicked()
		onHoveredChanged: toggleButton.hoveredChanged()
		onEntered: toggleButton.entered()
		onShowToolTip: toggleButton.showToolTip()
	}
}
