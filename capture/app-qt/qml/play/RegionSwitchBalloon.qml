import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import "../common"

SimpleLoader
{
	id: loader
	property variant productFamily

	property variant anchorTarget
	property variant tipType: Phoenix.ToolTip.ArrowDown

	component: Balloon
	{
		id: container

		tipType: loader.tipType
		target: loader.anchorTarget

		onCloseButtonClicked: productFamily.RegionWarningDismissed(false);

		function learnMoreClicked() {
			productFamily.RegionWarningLearnMoreClicked();
		}

		leftPadding: 19
		rightPadding: 5
		topPadding: 16
		bottomPadding: 17
		closeButton.anchors.topMargin: 4

		Column
		{
			// In case, there's not enough space for localized string
			width: Math.max(375, buttonRow.width)

			TextNormal
			{
				id: titleText
				// Wrap text
				anchors.left: parent.left
				anchors.right: parent.right
				wrapMode: Text.WordWrap
				font.pixelSize: 20;
			}

			Spacer { height: 5; }

			TextNormal
			{
				id: bodyText
				// Wrap text
				anchors.left: parent.left
				anchors.right: parent.right
				wrapMode: Text.WordWrap
			}

			Spacer { height: 19; }

			Row
			{
				anchors.horizontalCenter: parent.horizontalCenter

				property int cardWidth: (parent.width - 21 ) / 3
				spacing: 9

				RegionSwitchIconText
				{
					width: parent.cardWidth
					text: qsTr("GAME DATA & PURCHASES")
					iconSource: "../images/region_warning_items.png"
				}

				RegionSwitchIconText
				{
					width: parent.cardWidth
					text: qsTr("FRIENDS")
					iconSource: "../images/region_warning_friends.png"
				}

				RegionSwitchIconText
				{
					width: parent.cardWidth
					text: qsTr("PATCHING")
					iconSource: "../images/region_warning_patch.png"
				}
			}

			Spacer { height: 20; }

			Row
			{
				id: buttonRow

				spacing: 10

				Button
				{
					id: button
					text.text: qsTr("Got it!")
					// Permanently dismiss dialog for current game.
					onClicked: productFamily.RegionWarningDismissed(true);
				}

				WebLinkTextButton
				{
					anchors.verticalCenter: parent.verticalCenter
					text: qsTr("Learn More")
					onClicked: container.learnMoreClicked();
				}
			}
		}

		StateGroup
		{
			states: [
				State
				{
					name: "DefaultRegionWarning"
					when: productFamily.regionWarningType === Phoenix.GameFamily.DefaultRegionWarning
					PropertyChanges { target: titleText; text: qsTr("Hold up a sec!") }
					PropertyChanges { target: bodyText; text: qsTr("Please make sure this is the region you wish to play in. When you switch regions, your game progress won't travel with you, and you may experience higher latency. It will also affect:") }
				},
				State
				{
					name: "RegionSwitchWarning"
					when: 1 === 1
					PropertyChanges { target: titleText; text: qsTr("Not everything travels with you!") }
					PropertyChanges { target: bodyText; text: qsTr("When you switch regions, your game progress (including your characters, cards, and rankings) doesn't go with you. It will also affect:") }
				}
			]
		}
	}
}
