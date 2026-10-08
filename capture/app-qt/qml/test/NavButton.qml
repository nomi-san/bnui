import QtQuick 2.2
import Phoenix 1.0
import QtGraphicalEffects 1.0 as Effects

import "../common"

TextButton
{
	id: textButton

	property int screenIndex: 0
	property bool selected: self.screenIndex == textButton.screenIndex

	fontSize: 22
	smooth: true
	textOpacity: normalOpacities
	anchors.verticalCenter: parent.verticalCenter

	tipType: ToolTip.ArrowUp
	noDelay: true
	onShowToolTip:
	{
		util.showToolTip(textButton, textButton,
						 textButton.toolTip, textButton.tipType, textButton.noDelay);
	}

	onClicked:
	{
		self.screenIndex = textButton.screenIndex
	}

	layer.enabled: false
	layer.effect: Effects.Glow
	{
		radius: 20
		samples: radius * 2
		spread: 0.4
		fast: true
		transparentBorder: true
	}

	ButtonThemeOpacities
	{
		id: selectedOpacities
		normal: 1.0
		hovered: 1.0
		pressed: 0.8
		disabled: 0.1
	}

	ButtonThemeOpacities
	{
		id: normalOpacities
		normal: 0.4
		hovered: 0.8
		pressed: 0.5
		disabled: 0.1
	}

	text
	{
		font.capitalization: Font.AllUppercase
		font.family: fonts.regularFont.name
		smooth: true
	}

	states:
	[
		State
		{
			name: "Selected"
			when: textButton.selected

			PropertyChanges {
				target: textButton;
				textOpacity: selectedOpacities;
				//layer.enabled: true;
			}
		}
	]
}
