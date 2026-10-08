import QtQuick 2.2
import QtQuick.Layouts 1.1
import Phoenix 1.0 as Phoenix

import "../common/util.js" as Util
import "../common"

Item
{
	id: container
	property variant view

	property variant productPlayButton: view.playButton
	property variant productStatus: view.statusIcon
	property variant productFamily: view.family
	property variant productSelector: view.productSelector
	property variant productSecondarySelector: view.productSelector.secondarySelector;

	// This is z value for the most top layer. e.g. RegionSwitchWarning
	property int _TopLayerZ: 10

	property int minHeight: !container.visible ? 0 : playButtonLayout.height + playButtonLayout.anchors.bottomMargin
		+ typeSelector.height + typeSelector.anchors.bottomMargin;
	property int maxHeight: !container.visible ? 0 : playButtonLayout.height + playButtonLayout.anchors.bottomMargin
		+ typeSelector.height + typeSelector.anchors.bottomMargin
		+ typeSelectorLabel.height + typeSelectorLabel.anchors.bottomMargin;

	property bool _shrink: height < maxHeight;
	property bool _showWarningIcon: view.progress.networkWarningType !== Phoenix.Progress.NoWarning

	property bool _showRegionVersion: view.product && (view.product.statusTextType === Phoenix.GameProduct.StatusText_Version ||
		view.product.statusTextType === Phoenix.GameProduct.StatusText_VersionPatchNotes);

	//==========================================================================
	// Progress Bar
	//==========================================================================
	Loader
	{
		id: progressAreaLoader

		property int _maxWidth: container.width - statusArea.x - statusArea.width

		// This loader will be anchored to statusArea.Right. Width will be determined
		// statically or dynamically by child component based on _maxWidth property.
		anchors
		{
			left: statusArea.right
			verticalCenter: playButtonLayout.verticalCenter
		}
		height: parent.height

		// This should be the second top layer next to RegionSwitchWarning, so that
		// Rebase persistent tooltip stays on top.
		z: _TopLayerZ - 6

		Component
		{
			id: progressAreaComponent
			RowLayout
			{
				// Height is controlled by parent loader anchors.
				width: progressAreaLoader._maxWidth

				spacing: 10

				// Adjust padding on the left side based on the window size
				Spacer { implicitWidth: window.shiftWhenWidthIsSmall(40, 28) }

				ProgressArea
				{
					Layout.alignment: Qt.AlignVCenter
					Layout.fillWidth: true

					progressObject: view.progress

					WarningIcon
					{
						id: warningIcon
						progressObject: view.progress

						anchors.right: parent.left
						anchors.rightMargin: 10
						anchors.verticalCenter: parent.verticalCenter

						on: container._showWarningIcon
					}
				}

				ProgressButtonGroup
				{
					view: container.view
					Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

					onPauseClicked: view.product.Pause();
					onResumeClicked: view.product.Update(false);
					onUpdateNowClicked: view.product.Update(true);
				}

				// Adjust padding on the right side based on the window size
				Spacer { implicitWidth: window.shiftWhenWidthIsSmall(50, 10) }
			}
		}

		Component
		{
			id: repairProgressComponent
			RowLayout
			{
				// Height is controlled by parent loader anchors.
				width: progressAreaLoader._maxWidth
				spacing: 10

				Spacer { implicitWidth: window.shiftWhenWidthIsSmall(40, 20) }

				ProgressArea
				{
					Layout.alignment: Qt.AlignVCenter
					Layout.fillWidth: true

					progressObject: view.progress

					WarningIcon
					{
						progressObject: view.progress
						anchors.right: parent.left
						anchors.rightMargin: 5
						anchors.verticalCenter: parent.verticalCenter

						on: container._showWarningIcon
					}
				}

				CancelButton
				{
					Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

					showToolTipWhenDisabled: true
					//: Tooltip for the repair cancel button.
					toolTip: qsTr("Cancel Scan and Repair")
					onClicked: view.product.CancelRepair();
				}

				Spacer { implicitWidth: window.shiftWhenWidthIsSmall(50, 10) }
			}
		}

		Component
		{
			id: progressSpinnerAreaComponent
			RowLayout
			{
				width: progressAreaLoader._maxWidth

				// this holds a spinner and text
				Spinner
				{
					id: spinner
					anchors
					{
						left: parent.left
						leftMargin: 10
						verticalCenter: statusTextContainer.verticalCenter
					}
					small: true
				}

				Item
				{
					id: statusTextContainer

					anchors
					{
						left: spinner.right
						leftMargin: 10
						verticalCenter: parent.verticalCenter
					}

					width: statusText.stableWidth

					TextBusyArea
					{
						id: statusText

						// Replace all '|' characters with \u009C as this is a multi-length string.
						// This property caches progress object provided status text.
						statusText: view.progress.statusText.replace(/\|/g, "\u009C");
						running: true // view.progress.statusTextHasDots || true
						maxWidth: progressAreaLoader._maxWidth - (10 + spinner.width + 10 + buttonGroup.width + 20)

						anchors.left: parent.left
						anchors.verticalCenter: parent.verticalCenter
						anchors.verticalCenterOffset: -1

						layer.enabled: true
						layer.effect: DropShadowEffect {}
					}
				}

				ProgressButtonGroup
				{
					id: buttonGroup
					view: container.view
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: spinner.right
					anchors.leftMargin: 20 + statusText.width
					tooltipDirection: Phoenix.ToolTip.ArrowAtLeft

					onPauseClicked: view.product.Pause();
					onResumeClicked: view.product.Update(false);
				}
			}
		}

		Component
		{
			id: progressNextPatchIcon
			Row
			{
				Spacer { width: 10 }

				PlayScreenButton
				{
					id: nextPatchIcon

					anchors.verticalCenter: parent.verticalCenter

					onClicked: view.product.StartNextPatch();

					iconSource: "../images/statusicon_nextpatch.png"
					//: Default tooltip for the next patch button.
					toolTip: qsTr("Data for the next patch is available for download. Click to start.")

					tipType: Phoenix.ToolTip.ArrowDown | Phoenix.ToolTip.ArrowAtLeft
					noDelay: true
					onShowToolTip:
					{
						util.showToolTip(nextPatchIcon, nextPatchIcon, nextPatchIcon.toolTip, nextPatchIcon.tipType, noDelay);
					}
				}
			}
		}

		Component
		{
			id: progressNextPatchComponent

			Row
			{
				id: nextPatchRow
				Spacer { width: 38 } /* aligns with the progressNextPatchIcon */

				NextPatchIcon
				{
					id: nextPatchIcon
					progressObject: view.progress

					anchors.verticalCenter: parent.verticalCenter

					WarningIcon
					{
						progressObject: view.progress
						anchors.right: parent.left
						anchors.rightMargin: 10
						anchors.verticalCenter: parent.verticalCenter

						on: container._showWarningIcon
					}
				}

				Spacer { width: 14 }

				ProgressButtonGroup
				{
					id: buttonGroup
					view: container.view
					anchors.verticalCenter: parent.verticalCenter
					tooltipDirection: Phoenix.ToolTip.ArrowAtLeft
					onPauseClicked: view.product.PauseNextPatch();
					onResumeClicked: view.product.StartNextPatch();
				}
			}
		}

		Component
		{
			id: uninstallingAreaComponent
			UninstallingArea
			{
				width: progressAreaLoader._maxWidth
				progressObject: view.progress
			}
		}

		Component
		{
			id: uninstallingProgressAreaComponent
			RowLayout
			{
				// Height is controlled by parent loader anchors.
				width: progressAreaLoader._maxWidth

				spacing: 10

				// Adjust padding on the left side based on the window size
				Spacer { implicitWidth: window.shiftWhenWidthIsSmall(40, 28) }

				ProgressArea
				{
					Layout.alignment: Qt.AlignVCenter
					Layout.fillWidth: true

					progressObject: view.progress
				}

				// Adjust padding on the right side based on the window size
				Spacer { implicitWidth: window.shiftWhenWidthIsSmall(50, 10) }
			}
		}

		sourceComponent:
		{
			if (view.progress.displayMode === Phoenix.Progress.ShowProgressBar)
				return progressAreaComponent;
			else if (view.progress.displayMode === Phoenix.Progress.ShowRepairProgressBar)
				return repairProgressComponent;
			else if (view.progress.displayMode === Phoenix.Progress.ShowProgressSpinner)
				return progressSpinnerAreaComponent;
			else if (view.progress.displayMode === Phoenix.Progress.ShowNextPatchIcon)
				return progressNextPatchIcon;
			else if (view.progress.displayMode === Phoenix.Progress.ShowNextPatchSpinner)
				return progressNextPatchComponent;
			else if (view.progress.displayMode === Phoenix.Progress.ShowUninstallingSpinner)
				return uninstallingAreaComponent;
			else if (view.progress.displayMode === Phoenix.Progress.ShowUninstallingProgressBar)
				return uninstallingProgressAreaComponent;

			return undefined;
		}

	}

	//==========================================================================
	// Status Area
	//==========================================================================
	Row
	{
		id: statusArea

		anchors
		{
			top: playButtonLayout.top
			bottom: playButtonLayout.bottom
			left: playButtonLayout.right
			leftMargin: 10
		}

		// row will be resizing based on the number of visible items inside.
		// When that happens, if layoutDirection is set to LeftToRight, you'll see
		// items overlap play button area for very short time. Setting direction
		// to start from Right fixes this issue.
		layoutDirection: Qt.LeftToRight
		spacing: 10

		//----------------------------------------------------------------------
		// Status Icon
		//----------------------------------------------------------------------
		SimpleLoader
		{
			id: statusIcon
			anchors.verticalCenter: parent.verticalCenter
			visible: productStatus.visible

			component: StatusIcon {
				productStatus: container.productStatus
			}
		}
	}

	//==========================================================================
	// Type/Region/Account selection
	//==========================================================================

	// Label for the type selector
	TextNormal
	{
		id: typeSelectorLabel

		visible: typeSelector.visible && !container._shrink

		anchors.left: typeSelector.left
		anchors.bottom: typeSelector.top
		anchors.leftMargin: 1
		anchors.bottomMargin: 7

		font.pixelSize: 12;

		color: "#8c8680"

		//: Version Selector label
		text: regionSelector.visible ? qsTr("VERSION / REGION") : qsTr("VERSION")
	}

	// The main game type selector
	ComboBox
	{
		id: typeSelector
		anchors
		{
			bottom: playButtonLayout.top
			bottomMargin: 10
			left: playButtonLayout.left
			leftMargin: 1
		}

		width: regionSelector.visible ?
			playButton.width - regionSelector.width - regionSelector.anchors.leftMargin - 2 :
			playButton.width

		visible: container.productSelector.visible || true
		model: container.productSelector.model
		maxVisibleItems: 999

		//: Tooltip for the version selector combobox
		toolTip: qsTr("Select game version")
		tipType: Phoenix.ToolTip.ArrowLeft
		noDelay: true

		onShowToolTip:
		{
			util.showToolTip(typeSelector, typeSelector, typeSelector.toolTip, typeSelector.tipType, typeSelector.noDelay)
		}

		selectedIndex: container.productSelector.selectedIndex;
		onSelectedIndexChanged:
		{
			if (!gameController.initialized || typeSelector.selectedIndex === -1)
				return;

			container.productSelector.selectedIndex = typeSelector.selectedIndex;
		}
	}

	// The mini region selector button
	ComboBox
	{
		id: regionSelector

		anchors
		{
			bottom: playButtonLayout.top
			bottomMargin: 10
			left: typeSelector.right
			leftMargin: 4
		}

		width: typeSelector.height
		height: typeSelector.height

		visible: container.productSecondarySelector.visible && container.productSecondarySelector.isMini
		model: container.productSecondarySelector.model
		maxVisibleItems: 999

		//: Tooltip for the account/region selector combobox
		toolTip: qsTr("Select your region")
		tipType: Phoenix.ToolTip.ArrowLeft
		noDelay: true

		onShowToolTip:
		{
			util.showToolTip(regionSelector, regionSelector, regionSelector.toolTip, regionSelector.tipType, regionSelector.noDelay)
		}

		selectedIndex: container.productSecondarySelector.selectedIndex;
		onSelectedIndexChanged:
		{
			if (!gameController.initialized || regionSelector.selectedIndex === -1)
				return;

			container.productSecondarySelector.selectedIndex = regionSelector.selectedIndex;
		}

		contentsHeight: height
		contentsAnchors
		{
			rightMargin: 6
		}

		dropDownImage.buttonProperties: ButtonStateProperies
		{
			normal    { value: "../images/icon_languages_settings.png"; opacity: 1.0 }
			pressed   { value: "../images/icon_languages_settings.png"; opacity: 1.0 }
			hovered   { value: "../images/icon_languages_settings.png"; opacity: 1.0 }
			disabled  { value: "../images/icon_languages_settings.png"; opacity: 1.0 }
		}
	}

	// Label for the 2nd combo box (account selector)
	TextNormal
	{
		id: accountSelectorLabel

		// this shows when the account selector shows
		visible: accountSelector.visible && !container._shrink

		anchors.left: accountSelector.left
		anchors.bottom: accountSelector.top
		anchors.leftMargin: 1
		anchors.bottomMargin: 7

		font.pixelSize: 12;

		color: "#8c8680"

		//: Account Selector label
		text: qsTr("ACCOUNT")
	}

	ComboBox
	{
		id: accountSelector
		anchors
		{
			bottom: playButtonLayout.top
			bottomMargin: 10
			left: typeSelector.right
			leftMargin: 10
		}

		width: playButton.width

		visible: container.productSecondarySelector.visible && !container.productSecondarySelector.isMini
		model: container.productSecondarySelector.model
		maxVisibleItems: 999

		//: Tooltip for the account/region selector combobox
		toolTip: qsTr("Select your account")
		tipType: Phoenix.ToolTip.ArrowLeft
		noDelay: true

		onShowToolTip:
		{
			util.showToolTip(accountSelector, accountSelector, accountSelector.toolTip, accountSelector.tipType, accountSelector.noDelay)
		}

		selectedIndex: container.productSecondarySelector.selectedIndex;
		onSelectedIndexChanged:
		{
			if (!gameController.initialized || accountSelector.selectedIndex === -1)
				return;

			container.productSecondarySelector.selectedIndex = accountSelector.selectedIndex;
		}
	}

	//==========================================================================
	// Progress Spinner for Type Selector
	//==========================================================================

	Spinner
	{
		small: true
		anchors
		{
			left: typeSelectorLabel.right
			leftMargin: 10
			verticalCenter: typeSelectorLabel.verticalCenter
		}

		visible: container.productSelector.activity
	}

	//==========================================================================
	// Region Switch Warning
	//==========================================================================

	RegionSwitchBalloon
	{
		anchorTarget: regionSelector
		productFamily: view.family

		anchors
		{
			left: regionSelector.left
			leftMargin: 1
			bottom: regionSelector.top
			bottomMargin: 5
		}

		// This should be on top of everything
		z: _TopLayerZ

		visible: regionSelector.visible && view.family.regionWarningType !== Phoenix.GameFamily.NoWarning
	}

	//==========================================================================
	// Spinner for finding game
	//==========================================================================

	SpinnerLogo
	{
		id: findingSpinner
		small: true
		anchors
		{
			left: statusArea.right
			bottom: playButtonLayout.bottom
			bottomMargin: 3
			leftMargin: 10
		}

		visible: {
			if (!view.product) {
				return false;
			}
			return view.product.isRegistering || view.product.isVersioning
		}
	}

	//==========================================================================
	// Status text for up-to-date game
	// Contains the Version and Region text in addition to the normal status text
	//==========================================================================

	ColumnLayout
	{
		id: statusTextContainer

		anchors
		{
			left: statusArea.right
			bottom: playButtonLayout.bottom
			bottomMargin: 3
			leftMargin: findingSpinner.visible ? findingSpinner.width + 12 : 15
		}

		RowLayout
		{
			id: versionRegionContainer
			spacing: 7

			Text
			{
				id: regionText
				visible: {
					if (!_showRegionVersion || !view.account) {
						return false;
					}

					if (view.account.regionName == '') {
						return false;
					}

					if (gameController.environmentExtensionsEnabled) {
						return true;
					}

					return view.account.regions.length > 1;
				}

				text: {
					var name = view.account && view.account.regionName;
					if (gameController.environmentExtensionsEnabled) {
						//: Label for displaying currently selected game environment
						return qsTr("Environment: %1".arg(name))
					}
					//: Label for displaying currently selected game region
					return qsTr("Region: %1".arg(name));
				}

				font.family: fonts.regularFont.name
				font.pixelSize: 13;
				color: Qt.rgba(255, 255, 255, 0.5)
				textFormat: Text.RichText

				layer.enabled: true
				layer.effect: DropShadowEffect {
					verticalOffset: 1
					color: "#000"
					radius: 1
					samples: 3
				}
			}
		}

		RowLayout
		{
			spacing: 7
			Text
			{
				id: versionText

				visible: _showRegionVersion && view.product && view.product.localVersion != '';

				//: Label for displaying current game version
				text: qsTr("Version: %1").arg(view.product && view.product.localVersion)

				font.family: fonts.regularFont.name
				font.pixelSize: 13;
				color: Qt.rgba(255, 255, 255, 0.5)
				textFormat: Text.RichText

				layer.enabled: true
				layer.effect: DropShadowEffect {
					verticalOffset: 1
					color: "#000"
					radius: 1
					samples: 3
				}
			}

			Rectangle
			{
				width: 1
				height: parent.height

				opacity: .12;

				visible: uptodateMessage.visible && versionText.visible
			}

			Text
			{
				id: uptodateMessage

				visible: {
					if (!view.product) {
						return false;
					}

					// If the text is "find game" and the install button is disabled,
					// don't show the message.
					if (view.product.statusTextType === Phoenix.GameProduct.StatusText_FindGame
						&& !view.playButton.enabled)
					{
						return false;
					}

					// We will show version text separately.
					if (view.product.statusTextType === Phoenix.GameProduct.StatusText_Version)
					{
						return false;
					}

					return (view.progress.displayMode === Phoenix.Progress.Invisible
						&& view.product.showStatusText);
				}

				text: {
					if (!view.product) {
						return "";
					}

					var message = view.product.statusText;

					// alter style on hover to create mouse over effect.
					if (this.hoveredLink) {
						message = message.replace("style='text-decoration: none; color: #00aeff;'",
							"style='text-decoration: underline; color: #00aeff;'");
					}

					return message;
				}

				onLinkActivated:
				{
					if (link == "patchnotes")
						view.ShowPatchNotes()
					else if (link == "findgame")
						view.FindGame()
					else
						console.log("Undefined link clicked.")
				}

				font.family: fonts.regularFont.name
				font.pixelSize: 13;

				wrapMode: Text.WordWrap
				color: Qt.rgba(255, 255, 255, 0.5)
				textFormat: Text.RichText

				layer.enabled: true
				layer.effect: DropShadowEffect {
					verticalOffset: 1
					color: "#000"
					radius: 1
					samples: 3
				}

				MouseArea {
					anchors.fill: parent
					acceptedButtons: Qt.NoButton
					cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
				}
			}
		}
	}

	//==========================================================================
	// Status text for a game that has been purchased but has not been released
	//==========================================================================
	Text
	{
		id: prereleaseMessage

		anchors
		{
			left: statusArea.right
			top: playButtonLayout.top
			leftMargin: 15
		}

		function shouldShow() {
			if (!view.account) {
				return false;
			}
			return view.account.hasPrepurchased &&
				view.progress.displayMode === Phoenix.Progress.Invisible;
		}

		visible: prereleaseMessage.shouldShow();
		text: {
			if (!view.product) {
				return "";
			}
			return view.product.prereleaseMessage;
		}
		color: "#8c8680"

		font.family: fonts.regularFont.name
		font.pixelSize: 13;

		wrapMode: Text.WordWrap
		textFormat: Text.RichText

		layer.enabled: true
		layer.effect: DropShadowEffect { horizontalOffset: 0 }
	}

	//==========================================================================
	// "Up to date" text flash when "Check for Updates" is executed
	//==========================================================================
	RowLayout
	{
		id: checkForUpdatesRow
		anchors
		{
			left: statusTextContainer.left
			bottom: statusTextContainer.top
			bottomMargin: statusTextContainer.bottomMargin
			leftMargin: statusTextContainer.leftMargin
		}
		visible: {
			if (!view.product) {
				return false;
			}
			return view.progress.displayMode === Phoenix.Progress.Invisible
				&& view.product.showStatusText
		}

		opacity: 0
		spacing: 0

		Text
		{
			id: checkForUpdatesMessage
			text: view.uptodateMessage

			font.family: fonts.regularFont.name
			font.pixelSize: 13;
			wrapMode: Text.WordWrap
			color: "#18a006"
			textFormat: Text.RichText

			layer.enabled: true
			layer.effect: DropShadowEffect { horizontalOffset: 0 }
		}

		Spacer { width: 5 }

		Image
		{
			Layout.alignment: Qt.AlignBottom
			Layout.bottomMargin: 4

			id: checkForUpdatesImage
			source: "../images/checkMark_green.png"
		}

		SequentialAnimation
		{
			id: flashAnim
			running: false

			PropertyAnimation {
				target: checkForUpdatesRow; property: "opacity";
				from: 0; to: 1.0; duration: 500
			}
			PauseAnimation { duration: 1000 }
			PropertyAnimation {
				target: checkForUpdatesRow; property: "opacity";
				from: 1.0; to: 0; duration: 500
			}
		}

		Connections
		{
			target: view

			function onUptodateMessageChanged() {
				flashAnim.running = true;
			}
		}
	}

	//==========================================================================
	// Company Logo
	//==========================================================================
	Image
	{
		id: logoImage

		anchors
		{
			right: parent.right
			bottom: playButtonLayout.bottom
			rightMargin: 30
		}

		source: {
			if (!view.product) {
				return "";
			}
			return util.fromCatalog(view.product.companyLogoUrl);
		}

		// progressAreaLoader's width doesn't reset when changing between components.
		// Do not check if progressAreaLoader overlapping logo when displayMode is Invisible.
		visible: {
			return (view.progress.displayMode === Phoenix.Progress.Invisible
				|| progressAreaLoader.x + progressAreaLoader.width < logoImage.x - 5)
				&& statusTextContainer.x + statusTextContainer.width < logoImage.x - 5 // Hide logo when it's about to overlap with up-to-date text
		}
	}

	Row
	{
		id: playButtonLayout
		spacing: 10

		height: playButton.height
		z: _TopLayerZ - 5

		anchors.bottom: parent.bottom
		anchors.bottomMargin: window.shiftWhenHeightIsSmall(30, 25)
		anchors.left: parent.left
		anchors.leftMargin: 50

		//==========================================================================
		// Play Button
		//==========================================================================
		PlayButton
		{
			id: playButton

			width: 275
			height: 72

			text.text: productPlayButton ? productPlayButton.text : ""
			enabled: productPlayButton ? productPlayButton.enabled : false
			toolTip: productPlayButton ? productPlayButton.toolTip : ""
			noDelay: true
			showToolTipWhenDisabled: true

			onClicked: productPlayButton.clicked()
			visible: productPlayButton !== undefined
		}
	}
}
