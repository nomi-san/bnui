import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2
import Phoenix 1.0 as Phoenix
// Common imports some types that will override existing QML types
// such as ScrollBar so we need to scope this
import "../common" as PhoenixCommon

Dropdown
{
	id: topDropdown

	// This is the base sizing we animate from to full size
	width: 400
	height: mainHeading.height
	property int maxHeight: 480

	property bool hasAnyNotifications: mentionList.hasNotifications
		|| requestList.hasNotifications
		|| chatList.hasNotifications

	ColumnLayout
	{
		id: notificationCenterLayout
		spacing: 0
		anchors.fill: parent

		NotificationHeading
		{
			id: mainHeading
			padding: 14

			Layout.alignment: Qt.AlignTop
			Layout.fillWidth: true

			headingText: qsTr("Notifications")
			dismissText: hasAnyNotifications ? qsTr("Clear All") : ""
			color: "#1d222c"

			onDismissAllClicked:
			{
				notificationController.ClearAllNotifications()
			}
		}

		Rectangle
		{
			id: noNotificationBorder
			color: "#272e3b"
			visible: !hasAnyNotifications
			clip: true

			Layout.fillHeight: true
			Layout.fillWidth: true

			PhoenixCommon.ElidingText
			{
				id: headingText
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter
				anchors.margins: 8
				text: qsTr("No Notifications")
				color: "#cfd2d7"
			}
		}

		// ScrollView is currently being used as it seems to add transparent usage of
		// things like the MouseWheel
		ScrollView
		{
			id: contentWrapper

			Layout.fillHeight: true
			Layout.fillWidth: true

			clip: true

			ScrollBar.vertical
			{
				id: verticalScrollbar
				policy: ScrollBar.AsNeeded

				contentItem: Rectangle
				{
					implicitWidth: 3
					radius: 1.5
					color: "#ffffff"
					opacity: verticalScrollbar.hovered || verticalScrollbar.pressed ? 0.2 : 0.1
				}

				active: true
				visible: contentWrapper.contentHeight > contentWrapper.height
			}

			ScrollBar.horizontal
			{
				policy: ScrollBar.AlwaysOff
			}

			// Flickable provides actual scrollable area
			Flickable
			{
				id: theFlickable
				// Disable mobile overshoot
				boundsBehavior: Flickable.StopAtBounds

				ColumnLayout
				{
					id: scrollingLayout
					width: contentWrapper.width
					spacing: 0

					// Prevent small, few pixel scrolls by locking the scrollingLayout
					// implicitHeight to the viewHeight when they are less than scrollBuffer
					property real contentHeight: childrenRect.height
					property real viewportHeight: contentWrapper.height
					property real scrollBuffer: 10

					implicitHeight: contentHeight > viewportHeight
						&& contentHeight < viewportHeight + scrollBuffer
						? viewportHeight
						: contentHeight

					NotificationList
					{
						id: requestList
						headingText: qsTr("Requests")
						dismissText: qsTr("Clear All")
						model: notificationController.inviteModel
						delegate: InviteDelegate {}
						visible: requestList.hasNotifications

						onDismissAllClicked:
						{
							notificationController.ClearAllRequests()
						}
					}

					NotificationList
					{
						id: mentionList
						headingText: qsTr("@mentions")
						dismissText: qsTr("Mark All as Read")
						model: notificationController.mentionModel
						delegate: MentionDelegate {}
						visible: mentionList.hasNotifications

						onDismissAllClicked:
						{
							notificationController.DismissAllMentions()
						}
					}

					NotificationList
					{
						id: chatList
						headingText: qsTr("Chats")
						dismissText: qsTr("Mark All As Read")
						model: notificationController.messageModel
						delegate: ChatDelegate {}
						visible: chatList.hasNotifications

						onDismissAllClicked:
						{
							notificationController.MarkAllChatsAsRead()
						}
					}
				}
			}
		}

		states:
		[
			State
			{
				name: "open"
				when: topDropdown.visible
				PropertyChanges
				{
					target: topDropdown
					height: 480
					width: 400
				}
			}
		]
		transitions:
		[
			Transition
			{
				from: "*"
				to: "open"
				NumberAnimation
				{
					target: topDropdown
					properties: "height,width"
					easing.type: Easing.OutCubic
					duration: 100
				}
			}
		]
	}

	Rectangle
	{
		id: backgroundRect
		anchors.fill: notificationCenterLayout
		z: -1000
		color: "#272e3b"	// Same as Notification background
	}
}
