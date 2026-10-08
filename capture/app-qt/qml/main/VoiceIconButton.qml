import QtQuick 2.2
import QtGraphicalEffects 1.0 as Effects
import Phoenix 1.0 as Phoenix

import "../common"

ButtonBase
{
	id: container

	width: 32
	height: 32

	anchors.verticalCenter: parent.verticalCenter
	anchors.horizontalCenter: parent.horizontalCenter
	anchors.leftMargin: 10

	property ButtonThemeOpacities iconOpacity: ButtonThemeOpacities
	{
		normal: 0.8
		hovered: 1
		pressed: 0.6
		disabled: 0.1
	}

	backgroundImages: ButtonThemeImages {}

	ButtonThemeImages
	{
		id: iconTheme

		normal: "../images/voice/VoiceOn_Green_32x32.png"
		hovered: "../images/voice/VoiceOn_Green_32x32.png"
		pressed: "../images/voice/VoiceOn_Green_32x32.png"
		disabled: "../images/voice/VoiceOn_Green_32x32.png"
	}

	property real effectiveIconOpacity: iconOpacity.normal
	property string effectiveIconImage: iconTheme.normal

	Image
	{
		id: icon

		width: 32
		height: 32
		anchors.verticalCenter: parent.verticalCenter
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenterOffset: 0
		anchors.horizontalCenterOffset: 0

		opacity: effectiveIconOpacity
		source: effectiveIconImage

		layer.enabled: false
		layer.effect: Effects.Desaturate { desaturation: 1.0 }
	}

	StateGroup
	{
		states:
		[
			State
			{
				name: "disabled"
				when: !enabled
				PropertyChanges { target: icon; layer.enabled: true;}
				PropertyChanges { target: container; effectiveIconOpacity: iconOpacity.disabled; effectiveIconImage: iconTheme.disabled }
			},
			State
			{
				name: "down"
				when: pressed
				PropertyChanges { target: icon; anchors.verticalCenterOffset: 1; anchors.horizontalCenterOffset: 1 }
				PropertyChanges { target: container; effectiveIconOpacity: iconOpacity.pressed; effectiveIconImage: iconTheme.pressed }
			},
			State
			{
				name: "hovered"
				when: hovered
				PropertyChanges { target: container; effectiveIconOpacity: iconOpacity.hovered; effectiveIconImage: iconTheme.hovered }
			}
		]
	}
}
