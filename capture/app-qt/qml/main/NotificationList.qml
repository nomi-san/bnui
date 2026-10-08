import QtQuick 2.2
import QtQuick.Layouts 1.1
import Phoenix 1.0 as Phoenix
import "../common"

ColumnLayout
{
	id: listLayout

	property alias headingText: listHeading.headingText
	property alias dismissText: listHeading.dismissText
	property alias model: listView.model
	property alias delegate: listView.delegate
	property alias contentWidth: listView.contentWidth
	property real contentHeight: listView.contentHeight + listHeading.height

	signal dismissAllClicked

	property bool hasNotifications: listView.count > 0
		// Allow remove animations to finish before hiding list
		|| listView.animatingHeight > 0

	visible: hasNotifications

	spacing: 0
	Layout.fillWidth: true

	height: hasNotifications
		? listHeading.height + listView.preferredHeight
		: 0

	// These are done for animations caused by user actions, like dismissing a Notification
	property int primaryAnimationDuration: 300
	// These are done for animations that correct after primary ones, like resizing to
	// reclaim space after a primary animation
	property int secondardAnimationDuration: 200

	NotificationHeading
	{
		id: listHeading
		padding: 14
		color: "#232a36"

		Layout.fillWidth: true

		onDismissAllClicked: listLayout.dismissAllClicked()
	}

	ListView
	{
		id: listView

		property real animatingHeight: contentHeight
		property real oldHeight: 0

		Layout.preferredWidth: contentWidth
		Layout.preferredHeight: animatingHeight

		onContentHeightChanged:
		{
			// At this point, the animatingHeight behavior will already be running
			// so we need to disable it if we detect the growing case.
			shrinkBehavior.enabled = oldHeight > contentHeight
			oldHeight = contentHeight
		}

		Behavior on animatingHeight
		{
			id: shrinkBehavior
			SequentialAnimation
			{
				// Wait for remove to finish
				PauseAnimation { duration: primaryAnimationDuration }
				// Animate list shrink
				PropertyAnimation
				{
					duration: secondardAnimationDuration
					easing.type: Easing.InQuart
				}
			}
		}

		Layout.fillHeight: true
		Layout.fillWidth: true

		boundsBehavior: Flickable.StopAtBounds
		// ListViews derive from Flickables, but the lists are all contained in one big
		// Flickable. We have to mark the sub-lists as non-interactive so the top
		// Notification Center Flickable can handle the flick events
		interactive: false
		clip: true


		add: Transition
		{
			id: addTransition
			property real addWidth: ViewTransition.item ? ViewTransition.item.width : 0
			NumberAnimation
			{
				property: "x"
				from: addTransition.addWidth
				to: 0
				duration: primaryAnimationDuration
				easing.type: Easing.InQuart
			}
		}

		remove: Transition
		{
			id: removeTransition
			property real removeWidth: ViewTransition.item ? ViewTransition.item.width : 0

			NumberAnimation
			{
				property: "x"
				from: 0
				to: removeTransition.removeWidth
				duration: primaryAnimationDuration
				easing.type: Easing.OutQuart
			}
		}

		removeDisplaced: Transition
		{
			SequentialAnimation
			{
				// Wait for remove
				PauseAnimation { duration: primaryAnimationDuration }
				// Animate to final position
				NumberAnimation
				{
					properties: "y"
					duration: secondardAnimationDuration
					easing.type: Easing.OutQuart
				}
			}
		}
	}
}
