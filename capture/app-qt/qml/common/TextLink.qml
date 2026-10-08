import QtQuick 2.2
import QtGraphicalEffects 1.0 as Effects
import "../common"

Item
{
	id: menuItem

	property alias textItem: text
	property alias text: text.text
	property alias iconItem: icon
	property alias dropdownItem: dropdown
	property alias iconSource: icon.source
	property alias noDelay: buttonBehavior.noDelay
	property variant textColor: "#ffffff"

	property alias toolTip: buttonBehavior.toolTip
	property alias showToolTipWhenDisabled: buttonBehavior.showToolTipWhenDisabled
	property alias tipType: buttonBehavior.tipType
	property alias enabled: buttonBehavior.enabled

	property bool iconOnRight: false
	property bool dropDownVisible: false

	property int iconDistance: 4

	height: container.height
	width: container.width

	signal pressed()
	signal clicked()
	signal showToolTip(variant popupMode)

	Row
	{
		id: container

		height: Math.max(icon.height, text.height)

		spacing: iconDistance

		layoutDirection: iconOnRight ? Qt.RightToLeft : Qt.LeftToRight

		Image
		{
			id: icon

			opacity: menuItem.enabled ? 0.8 : 0.6

			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: 0

			layer.enabled: !menuItem.enabled
			layer.effect: Effects.Desaturate { desaturation: 1.0; }
		}

		Text
		{
			id: text

			font
			{
				pixelSize: 14
				family: fonts.regularFont.name
			}

			opacity: menuItem.enabled ? 0.9 : 0.6
			color: menuItem.enabled ? menuItem.textColor : "#999999"

			anchors.verticalCenter: parent.verticalCenter

			layer.enabled: true
			layer.effect: DropShadowEffect {}
		}

		Image
		{
			id: dropdown
			source: "../images/arrow_down.png"
			opacity: menuItem.enabled ? 0.8 : 0.35
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: 1
			visible: dropDownVisible
		}
	}

	ButtonBehavior
	{
		id: buttonBehavior

		anchors.fill: parent
		onPressed: menuItem.pressed()
		onClicked: menuItem.clicked()
		onShowToolTip: menuItem.showToolTip(popupMode)
	}

	states:
	[
		State
		{
			name: "hovered"
			when: buttonBehavior.buttonState == "hovered"

			PropertyChanges
			{
				target: icon
				opacity: 1
			}

			PropertyChanges
			{
				target: dropdown
				opacity: 1
			}

			PropertyChanges
			{
				target: text
				opacity: 1
			}
		}
	]
}