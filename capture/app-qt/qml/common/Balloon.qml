import QtQuick 2.2
import Phoenix 1.0 as Phoenix

Item
{
	id: container

	//==========================================================================
	// Properties
	//==========================================================================
	default property alias content: content.data
	property alias background: background.children
	property int leftPadding: 0
	property int rightPadding: 0
	property int topPadding: 0
	property int bottomPadding: 0
	property variant tipType: Phoenix.ToolTip.ArrowDown
	property variant style: BalloonStyle {}
	property variant target: undefined
	property variant targetPoint: undefined
	property alias closeButton: closeButton
	property bool showCloseButton: true
	signal closeButtonClicked()

	width: contentWrapper.width
	height: contentWrapper.height

	onXChanged: arrow.updateArrowHOffset()
	onYChanged: arrow.updateArrowVOffset()

	function updateArrowOffset()
	{
		arrow.updateArrowHOffset()
		arrow.updateArrowVOffset()
	}

	//==========================================================================
	// Block any mouse event
	//==========================================================================
	MouseEventBlocker
	{
		id: mouseEventBlocker
		anchors.fill: contentWrapper
	}

	//==========================================================================
	// Border
	//==========================================================================
	BorderImage
	{
		id: border
		source: style.borderImage
		border
		{
			top: style.borderTop
			right: style.borderRight
			bottom: style.borderBottom
			left: style.borderLeft
		}
		anchors
		{
			fill: contentWrapper
			topMargin: -border.border.top + style.contentPaddingTop
			rightMargin: -border.border.right + style.contentPaddingRight
			bottomMargin: -border.border.bottom + style.contentPaddingBottom
			leftMargin: -border.border.left + style.contentPaddingLeft
		}
	}

	//==========================================================================
	// Arrow
	//==========================================================================
	Image
	{
		id: arrow

		property int arrowHeight: (arrow.height / 2) + 1
		property int arrowWidth: (arrow.width / 2) + 1

		property int arrowVOffset: 0
		property int arrowHOffset: 0

		property int _arrowPadding: 5

		function updateArrowHOffset()
		{
			if (target === undefined && targetPoint === undefined)
				return;

			var centeredPos = target
				? container.mapFromItem(target, target.width / 2, target.height / 2)
				: Qt.point(targetPoint.x - container.x, targetPoint.y - container.y);

			var offset = centeredPos.x - arrow.width / 2
			arrow.arrowHOffset = Math.min(container.width - arrow.width - _arrowPadding, Math.max(offset, _arrowPadding))
		}

		function updateArrowVOffset()
		{
			if (target === undefined && targetPoint === undefined)
				return;

			var centeredPos = target
				? container.mapFromItem(target, target.width / 2, target.height / 2)
				: Qt.point(targetPoint.x - container.x, targetPoint.y - container.y);

			var offset = centeredPos.y - arrow.height / 2
			arrow.arrowVOffset = Math.min(container.height - arrow.height - _arrowPadding / 2, Math.max(offset, _arrowPadding))
		}

		Connections
		{
			target: container.target
			Component.onCompleted:
			{
				// Initialze offsets
				arrow.updateArrowHOffset()
				arrow.updateArrowVOffset()
			}

			function onXChanged() {
				arrow.updateArrowHOffset();
			}
			function onYChanged() {
				arrow.updateArrowVOffset();
			}
			function onWidthChanged() {
				arrow.updateArrowHOffset();
			}
			function onHeightChanged() {
				arrow.updateArrowVOffset();
			}
		}
	}

	Item
	{
		id: background
		anchors.fill: contentWrapper

		anchors.topMargin: -2
		anchors.bottomMargin: -2
		anchors.leftMargin: -2
		anchors.rightMargin: -2
	}

	//==========================================================================
	// Content Wrapper
	//==========================================================================
	Item
	{
		id: contentWrapper

		width: Math.max(style.minimumWidth, content.width + closeButton.width + leftPadding + rightPadding);
		height: Math.max(style.minimumHeight, content.height + topPadding + bottomPadding)

		// Column is used here so that we can get size of the content item
		Column
		{
			id: content
			clip: true
			x: leftPadding
			y: topPadding
		}

		VertButton
		{
			id: closeButton
			visible: container.showCloseButton

			anchors
			{
				left: content.right
				top: contentWrapper.top
			}

			width: container.showCloseButton ? icon.width : 0
			height: icon.height
			backgroundImages: ButtonThemeImages {}
			iconSource: "../images/btn_exit.png"
			onClicked: container.closeButtonClicked();
			iconOpacity: ButtonThemeOpacities
			{
				normal: 0.4
				hovered: 0.5
				pressed: 0.3
				disabled: 0.1
			}
		}
	}

	//==========================================================================
	// Arrow Direction States
	//==========================================================================
	states: [
		State
		{
			name: "ArrowDown"
			when: tipType === Phoenix.ToolTip.ArrowDown
			PropertyChanges
			{
				target: arrow
				source: style.arrowDownImage
				anchors.bottomMargin: -arrow.arrowHeight + border.border.bottom - style.contentPaddingBottom
				x: arrow.arrowHOffset
			}
			AnchorChanges
			{
				target: arrow
				anchors.bottom: border.bottom
			}
			PropertyChanges
			{
				target: contentWrapper
				y: -arrow.arrowHeight
			}
		},
		State
		{
			name: "ArrowRight"
			when: tipType === Phoenix.ToolTip.ArrowRight
			PropertyChanges
			{
				target: arrow
				source: style.arrowRightImage
				anchors.rightMargin: -arrow.arrowWidth + border.border.right - style.contentPaddingRight
				y: arrow.arrowVOffset
			}
			AnchorChanges
			{
				target: arrow
				anchors.right: border.right
			}
			PropertyChanges
			{
				target: contentWrapper
				x: -arrow.arrowWidth
			}
		},
		State
		{
			name: "ArrowUp"
			when: tipType === Phoenix.ToolTip.ArrowUp
			PropertyChanges
			{
				target: arrow
				source: style.arrowUpImage
				anchors.topMargin: -arrow.arrowHeight + border.border.top - style.contentPaddingTop
				x: arrow.arrowHOffset
			}
			AnchorChanges
			{
				target: arrow
				anchors.top: border.top
			}
			PropertyChanges
			{
				target: contentWrapper
				y: arrow.arrowHeight
			}
		},
		State
		{
			name: "ArrowLeft"
			when: tipType === Phoenix.ToolTip.ArrowLeft
			PropertyChanges
			{
				target: arrow
				source: style.arrowLeftImage
				anchors.leftMargin: -arrow.arrowWidth + border.border.left - style.contentPaddingLeft
				y: arrow.arrowVOffset
			}
			AnchorChanges
			{
				target: arrow
				anchors.left: border.left
			}
			PropertyChanges
			{
				target: contentWrapper
				x: arrow.arrowWidth
			}
		}
	]
}
