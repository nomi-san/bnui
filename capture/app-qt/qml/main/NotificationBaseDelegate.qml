import QtQuick 2.2
import Phoenix 1.0
import QtQuick.Controls 2.2
import "../common"

MouseArea
{
	id: topRect

	height: headingText.height
		+ subText.height
		+ messageText.height
		+ placeHolder.height
		+ 20 // Padding minus text line heights

	hoverEnabled: true

	Rectangle
	{
		id: background
		color: topRect.containsMouse ? "#313845" : "#272e3b"

		anchors.fill: parent
	}

	width: parent.width

	// Primary interface
	property alias headingText: headingText.text
	property string secondaryText: ""
	property alias mainText: messageText.text
	property string timeString: ""
	property int avatarCategory: AvatarStore.Personal
	property int avatarId: 0
	property int secondAvatarId: 0
	property alias iconSource: notificationIcon.source
	property bool autoCloseNotificationCenter: true

	property bool isConfirmed: false
	property bool isError: notificationState == Notification.Error

	property string stateText: ""
	property string errorText: ""

	//: Used for inline Notification confirmations; clicking OK will dismiss the Notification
	property string confirmText: qsTr("OK")
	property string errorConfirmText: qsTr("OK")

	// Styling related properties
	property int fontPixelSize: 13
	property color nameFontColor: "#82c5ff"
	property color headingTextColor: "#cfd2d7"
	property color mainTextColor: "#cfd2d7"
	property color secondaryTextColor: "#82c5ff"
	property color timeLabelTextColor: "#818997"

	default property alias contents: placeHolder.data

	signal showContextMenu(rect centeredRect, rect anchorRect)
	signal mainHitBoxClicked()
	signal confirmTextClicked()
	signal errorTextClicked()

	function sendShowContextMenuSignal()
	{
		var centeredRect = util.globalGeometry(contextMenuButton);
		var anchorRect = util.globalGeometry(contextMenuButton);
		// Fudge the anchor rect position because its not being accurately calculated for some reason
		anchorRect.y -= 7
		centeredRect.x -= 1
		showContextMenu(centeredRect, anchorRect)
	}

	function getColoredNameText(name)
	{
		return "<font color=\"" + nameFontColor + "\">"
			+ name + "</font>";
	}

	Loader
	{
		id: imageLoader
		sourceComponent: isError ? errorComponent : avatarComponent

		anchors
		{
			left: topRect.left
			leftMargin: 14
			top: topRect.top
			topMargin: 14
		}

		Component
		{
			id: avatarComponent
			Avatar
			{
				id: messageAvatar
				avatarId: topRect.avatarId
				secondAvatarId: topRect.secondAvatarId
				avatarCategory: topRect.avatarCategory
				avatarSize: 32
			}
		}

		Component
		{
			id: errorComponent
			Image
			{
				source: "../images/alert-32-blue.png"
			}
		}
	}

	Item
	{
		id: contentRect

		anchors
		{
			top: topRect.top
			topMargin: 10

			left: imageLoader.right
			leftMargin: 16

			bottom: topRect.bottom
			bottomMargin: 14

			right: topRect.right
			rightMargin: 14
		}

		ElidingText
		{
			id: headingText

			maximumLineCount: 1

			anchors
			{
				top: contentRect.top
				left: contentRect.left
				right: contentRect.right
				rightMargin: 36	// 50 pixels from right edge
			}

			color: headingTextColor
		}

		ElidingText
		{
			id: subText
			anchors
			{
				top: headingText.bottom
				left: contentRect.left
				right: contentRect.right
				rightMargin: 36	// 50 pixels from right edge
			}

			color: secondaryTextColor
			text: secondaryText
			height: secondaryText ? subText.implicitHeight : 0
		}

		Image
		{
			id: notificationIcon
			source: iconSource
			anchors
			{
				verticalCenter: messageText.verticalCenter
			}
		}

		ElidingText
		{
			id: messageText
			anchors
			{
				top: subText.bottom
				left: notificationIcon.right
				leftMargin: 4
				right: contentRect.right
				rightMargin: 36	// 50 pixels from right edge
			}

			color: mainTextColor
		}

		ElidingText
		{
			id: timeLabel
			anchors
			{
				right: contentRect.right
				bottom: contentRect.bottom
				bottomMargin: -6
			}

			text: topRect.timeString
			color: timeLabelTextColor
			font.pixelSize: 11
		}

		Item
		{
			id: placeHolder
			anchors
			{
				left: parent.left
				leftMargin: -8
				right: parent.right
				top: notificationIcon.bottom
			}
			height: childrenRect.height
		}
	}

	VertButton
	{
		id: dismissButton

		anchors
		{
			top: contentRect.top
			topMargin: -4
			right: contentRect.right
			rightMargin: -8
		}

		width: 16
		height: 16

		backgroundImages: ButtonThemeImages {}
		iconSource: "../images/clear.png"

		iconOpacity: ButtonThemeOpacities
		{
			normal: 0.4
			hovered: 0.7
			pressed: 0.3
			disabled: 0.1
		}

		onClicked: notificationController.DismissNotification(notificationKey);
	}

	VertButton
	{
		id: contextMenuButton

		anchors
		{
			top: contentRect.top
			topMargin: -4
			right: dismissButton.left
			rightMargin: 6
		}

		width: 16
		height: 16

		backgroundImages: ButtonThemeImages {}
		iconSource: "../images/notifications/11x9_ellipsis.png"

		onClicked:
		{
			topRect.sendShowContextMenuSignal()
		}

		iconOpacity: ButtonThemeOpacities
		{
			normal: 0.4
			hovered: 0.7
			pressed: 0.3
			disabled: 0.1
		}
	}

	SimpleLoader
	{
		id: inlineItemLoader
		visible: false

		anchors
		{
			top: topRect.top
			topMargin: 10

			left: imageLoader.right
			leftMargin: 16

			bottom: topRect.bottom
			bottomMargin: 14

			right: topRect.right
			rightMargin: 14
		}

		component: messageComponent
	}

	Component
	{
		id: messageComponent

		Item
		{
			id: messageRect

			anchors.fill: parent

			ElidingText
			{
				id: stateTextComponent
				maximumLineCount: 3
				color: headingTextColor

				text: isError ? errorText : stateText

				anchors
				{
					top: parent.top
					left: parent.left
					right: parent.right
					rightMargin: 36	// 50 pixels from right edge
				}
			}

			Button
			{
				id: confirmTextButton
				height: 24

				anchors
				{
					left: parent.left
					bottom: parent.bottom
				}

				text.color: "#cfd2d7"
				text.text: isError ? errorConfirmText : confirmText
				text.elide: Text.ElideRight
				text.maximumLineCount: 1
				text.font.pixelSize: 12

				horizontalPadding: 12

				backgroundImages: ButtonThemeImages
				{
					normal: isError ? "../controls/btn_secondary_normal.png" : "../controls/btn_primary_normal.png"
					hovered: isError ? "../controls/btn_secondary_hover.png" : "../controls/btn_primary_hover.png"
					pressed: isError ? "../controls/btn_secondary_pressed.png" : "../controls/btn_primary_pressed.png"
					disabled: isError ? "../controls/btn_secondary_disabled.png" : "../controls/btn_primary_disabled.png"
				}

				onClicked: isError
					? topRect.errorTextClicked()
					: topRect.confirmTextClicked()
			}
		}
	}

	// The bottom "border"
	Rectangle
	{
		color: "#424854"
		height: 1
		width: topRect.width

		anchors.bottom: topRect.bottom
	}

	MouseArea
	{
		id: mainHitBox
		anchors.fill: parent

		// Lower this area's z-order so other mouse areas will be processed
		// before this one
		z: -1

		acceptedButtons: Qt.LeftButton | Qt.RightButton

		onClicked:
		{
			if (notificationState == Notification.Error
				|| notificationState == Notification.Confirmed)
				return;

			if (mouse.button === Qt.LeftButton)
			{
				if (autoCloseNotificationCenter)
				{
					// Hide Notification Center menu
					notificationController.showNotificationMenu = false;
				}

				topRect.mainHitBoxClicked()
			}
			else if (mouse.button === Qt.RightButton)
			{
				topRect.sendShowContextMenuSignal()
			}
		}
	}

	states: [
		State
		{
			name: "showMessage"
			when: notificationState == Notification.Confirmed
				|| notificationState == Notification.Error
			// Hide UI elements when going into Confirmed state. Also, make these values
			// "sticky" by setting restoreEntryValues to false as state will transition
			// to dismissed.
			PropertyChanges { restoreEntryValues: false; target: topRect; isConfirmed: true}
			PropertyChanges { restoreEntryValues: false; target: contentRect; visible: false }
			PropertyChanges { restoreEntryValues: false; target: contextMenuButton; visible: false }
			PropertyChanges { restoreEntryValues: false; target: inlineItemLoader; visible: true }
		}
	]
}
