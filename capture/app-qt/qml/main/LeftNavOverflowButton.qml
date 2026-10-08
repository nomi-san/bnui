import QtQuick 2.2
import Phoenix 1.0
import "../common"

Row
{
	id: overflowMenu

	property int lMargin: 30
	property int bMargin: 17 + 3

	anchors
	{
		bottomMargin: bMargin
		leftMargin: lMargin
	}

	Text
	{
		id: overflowMenuButton

		text: "..."

		property ButtonThemeOpacities textOpacity: ButtonThemeOpacities
		{
			normal: 0.7
			hovered: 1.0
			pressed: 0.5
			disabled: 0.1
		}

		font.pixelSize: 30
		font.family: _pageSelector_fontFamily
		font.capitalization: _pageSelector_fontCapitalization
		opacity: textOpacity.normal
		color: "#ffffff"
		smooth: true
		style: Text.Normal
		styleColor: "#00adef"

		Behavior on opacity { NumberAnimation { duration: 200 }}

		ButtonBehavior
		{
			id: buttonBehavior
			anchors.fill: parent
			onClicked:
			{
				var anchorRect = util.globalGeometry(overflowMenuButton);
				var centeredRect = util.globalGeometry(overflowMenuButton);
				centeredRect.y += 2
				screenController.ShowScreenMenu(anchorRect, centeredRect, shouldCollapse);
			}
		}

		StateGroup
		{
			states:
			[
				State
				{
					name: "down"
					when: buttonBehavior.pressed
					PropertyChanges {
						target: overflowMenu;
						anchors.bottomMargin: bMargin - 1;
						anchors.leftMargin: lMargin + 1;
					}
					PropertyChanges {
						target: overflowMenuButton
						opacity: textOpacity.pressed;
					}
				},
				State
				{
					name: "hovered"
					when: buttonBehavior.containsMouse

					PropertyChanges {
						target: overflowMenuButton;
						opacity: textOpacity.hovered;
					}
				}
			]
		}
	}
}