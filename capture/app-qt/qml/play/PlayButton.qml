import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

Button
{
	id: button

	// Temporary text to calculate painted width for actual text
	Text
	{
		id: invisibleText
		parent: button
		font.pixelSize: button.fontSize
		font.family: button.text.font.family
		text: button.text.text
		visible: false
	}
	
	// Maximum font size for the button
	property int fontSize: 30
	property int textWidth: button.width - button.horizontalPadding
	
	text.font.pixelSize: (invisibleText.paintedWidth > button.textWidth)
						 ? (button.textWidth / invisibleText.paintedWidth) * fontSize
						 : fontSize

	tipType: Phoenix.ToolTip.ArrowLeft
	onShowToolTip: button.triggerToolTip(popupMode)
}
