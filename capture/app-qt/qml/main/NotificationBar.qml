import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

Item
{
	id: notificationBar
	height: 30

	visible: _breakingNewsBarVisible || _feedbackBarVisible || _readyForRestartBarVisible

	property bool _toggled: false
	property bool _breakingNewsBarVisible: appController.serviceAlertMonitor.hasBreakingNews
	property bool _readyForRestartBarVisible: !_breakingNewsBarVisible && appController.showReadyForRestartBar
	property bool _feedbackBarVisible: !_breakingNewsBarVisible && !_readyForRestartBarVisible && appController.showFeedbackBar
	onVisibleChanged: notifyVisibilityChanged();

	Component.onCompleted:
	{
		_toggled = true;
		if (notificationBar.visible)
			notifyVisibilityChanged();
	}

	function notifyVisibilityChanged()
	{
		if (_toggled)
		{
			var adjust = notificationBar.visible ? notificationBar.height : -notificationBar.height;
			self.ResizeForNotificationBar(adjust);
		}
	}

	BreakingNewsBar
	{
		id: breakingNewsBar

		visible: _breakingNewsBarVisible

		anchors
		{
			left: notificationBar.left
			top: notificationBar.top
			bottom: notificationBar.bottom
		}

		width: notificationBar.width
	}

	ReadyForRestartBar
	{
		id: readyForRestartBar

		visible: _readyForRestartBarVisible

		anchors
		{
			left: notificationBar.left
			top: notificationBar.top
			bottom: notificationBar.bottom
		}

		width: notificationBar.width
	}

	FeedbackBar
	{
		id: feedbackBar

		visible: _feedbackBarVisible

		anchors
		{
			left: notificationBar.left
			top: notificationBar.top
			bottom: notificationBar.bottom
		}

		width: notificationBar.width
	}
}
