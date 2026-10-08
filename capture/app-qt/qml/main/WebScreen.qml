import QtQuick 2.2
import Phoenix 1.0
import browser 1.0
import "../common"

FocusScope
{
	id: webScreen

	// Fixes warning
	anchors.top: parent != undefined ? parent.top : undefined
	focus: true

	property variant screen
	property string name: "WebScreen"
	property bool showDevButtons: true
	property bool createCefBrowser: true

	Item
	{
		id: contentHolder
		anchors
		{
			top: parent.top
			left: parent.left
			right: parent.right
			bottom: parent.bottom
		}

		BrowserItem
		{
			id: browserView

			focus: true
			width: parent.width + 1
			height: parent.height

			name: webScreen.name + "Browser"

			loadingIcon.visible: false
			loadingIcon.playing: false

			visible: true
			navigationEnabled: true
			delegate: screen

			createCefBrowser: webScreen.createCefBrowser

			onVisibleChanged:
			{
				if (visible)
				{
					browserView.forceActiveFocus();
				}
			}
		}

		SpinnerLogo
		{
			id: loadingIcon
			small: false
			playing: browserView.showLoadingIcon ? browserView.showLoadingIcon : false

			// To redefine default loading icon position, we need to
			// set anchors.centerIn to undefined
			anchors.centerIn: undefined
			anchors.right: browserView.right
			anchors.bottom: browserView.bottom
			anchors.rightMargin: 20
			anchors.bottomMargin: 20
			opacity: browserView.showLoadingIcon ? 0.8 : 0
			visible: loadingIcon.opacity > 0

			Behavior on opacity { NumberAnimation { duration: 200 }}
		}
	}
}
