import QtQuick 2.2
import Phoenix 1.0

import "../common"

WindowRoot
{
	WebScreen
	{
		id: fullScreenVideo

		screen: screenController.fullScreenVideo
		name: "FullScreenVideo"

		showDevButtons: false
		createCefBrowser: false

		anchors.fill: parent
	}

	Fonts { id: fonts }
	Util { id: util }
}
