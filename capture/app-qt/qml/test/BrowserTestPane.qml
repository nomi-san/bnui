import QtQuick 2.2
import QtQuick.Controls 1.4 as Controls
import QtQuick.Layouts 1.2

import Phoenix 1.0
import browser 1.0

import "../common"
import "../main"
import "../common/util.js" as Util

ColumnLayout
{
	focus: true
	id: rootLayout

	RowLayout
	{
		Controls.TextField
		{
			id: urlText
			Layout.fillWidth: true

			onAccepted: browserView.url = urlText.text
			text: browserView.url

			KeyNavigation.tab: focusIndicator
			KeyNavigation.backtab: browserView
		}

		Rectangle
		{
			id: focusIndicator

			KeyNavigation.tab: browserView
			KeyNavigation.backtab: urlText

			width: 75
			height: urlText.height

			color: {
				if (browserView.activeFocus)
					return "green";
				if (focusIndicator.activeFocus)
					return "blue";
				return "red";
			}

			focus: true

			MouseArea
			{
				anchors.fill: parent

				onClicked: browserView.showDevTools(true);
			}

			Text
			{
				id: focusText

				anchors.centerIn: parent
				text: {
					if (browserView.activeFocus)
						return "Focus";
					if (focusIndicator.activeFocus)
						return "<No Focus>";
					return "No Focus";
				}
				color: "white"
			}
		}

		Rectangle
		{
			id: popupTrigger

			width: 50
			height: urlText.height

			color: showPopup ? "light blue" : "light gray"

			Text
			{
				id: debugText

				anchors.centerIn: parent
				text: "Debug"
			}

			property bool showPopup: false
			MouseArea
			{
				anchors.fill: parent
				onClicked: popupTrigger.showPopup = !popupTrigger.showPopup
			}
		}
	}

	Item
	{
		Layout.fillWidth: true
		Layout.fillHeight: true

		BrowserItem
		{
			id: browserView

			KeyNavigation.tab: urlText
			KeyNavigation.backtab: focusIndicator

			anchors.fill: parent
			name: "SharedBrowser"

			loadingIcon.visible: false
			loadingIcon.playing: false

			visible: true
			navigationEnabled: true

			url: "http://google.com"

			opacity: 1.0

			acceptsNavigationFocus: true
		}

		BrowserDebugPane
		{
			anchors.top: browserView.top
			anchors.right: browserView.right

			visible: popupTrigger.showPopup
			browserView: rootLayout.browserView
		}
	}
}
