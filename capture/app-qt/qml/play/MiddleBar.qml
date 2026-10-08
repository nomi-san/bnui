import QtQuick 2.2
import browser 1.0

import "../common"

Item
{
	id: container

	property alias webview: webview
	property variant view

	property int minHeight: 0
	property var delegate: playView.browserDelegate;

	BrowserItem
	{
		id: webview
		name: "PlayScreen"
		focus: true
		width: parent.width
		height: parent.height
		delegate: container.delegate
		visible: !delegate.hidden
	}
}
