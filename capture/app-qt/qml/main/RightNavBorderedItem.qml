import QtQuick 2.2
import Phoenix 1.0
import "../common"

// This item is intended to be used inside RightNav.qml
// This item contains a button, a hover rect, and a left separator
// The separator exists here because during animation we want
// the separator to animate in with the item

Item
{
	id: borderedItem

	property alias loader: loader
	property bool stateVisible: false
	property int itemWidth: 44

	// Expose navItemWidth to loaded component since it's animating
	// (currently used in NotificationButton via RightNav)
	property alias navItemWidth: borderedItem.width

	// Externally defined by RightNav (parent)
	// borderWidth
	// borderOpacity
	// dimmedBackgroundOpacity
	// hoverRectOpacity
	// borderHoverAnimationDuration

	// Bind visibility to loader opacity. This allow us to use loader opacity animations to control visibility.
	visible: loader.opacity != 0.0
	width: 0
	height: 32

	QtObject
	{
		id: priv

		property int animationDuration: 200
	}

	// When animating we set clip to true so it looks like we "come from nothingness"
	// However once complete, we need to be able to clip in order to render the hoverRect
	// outside our bounds.
	// As a RightNav item, our left/right edge is shared with the item to our left/right
	// If we're transitioning our opacity or width then we're animating
	clip: (loader.opacity != 1.0 && loader.opacity != 0.0) || (width != itemWidth && width != 0)

	// Our loader object internals are not exposed to us. But a Behavior allows us to animate even when
	// our loader object changes width internally
	Behavior on width
	{
		NumberAnimation { duration: priv.animationDuration; easing.type: Easing.InOutQuad }
	}

	SimpleLoader
	{
		id: loader

		visible: borderedItem.visible;
		opacity: 0.0

		anchors.left: parent.left
		anchors.top: parent.top
		anchors.bottom: parent.bottom

		Behavior on opacity
		{
			NumberAnimation { duration: priv.animationDuration; easing.type: Easing.InOutQuad }
		}
	}

	Rectangle
	{
		id: dimmedBackground
		z: -2 // Place behind everything

		anchors.fill: parent
		// Keep off leftSeparator so we don't mix opacities
		anchors.leftMargin: leftSeparator.width
		anchors.topMargin: borderWidth
		anchors.bottomMargin: borderWidth

		color: "black"
		opacity: 0.1
	}

	Rectangle
	{
		// Note that this separator is "shared" by the item to our left.
		// This is because this is actually part of the 1px border around items
		// in the RightNav
		id: leftSeparator

		width: borderWidth
		height: borderedItem.height

		visible: borderedItem.visible

		color: "white"
		// This is being displayed on top of a background with opacity.
		// So we set our opacity a bit higher to counteract that
		opacity: borderOpacity

		anchors.left: parent.left
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		// Keep off the border
		anchors.topMargin: borderWidth
		anchors.bottomMargin: borderWidth
	}

	Rectangle
	{
		id: hoverRect
		color: "transparent"

		visible: opacity != 0.0

		anchors.fill: parent
		border.color: "white"
		border.width: 1
		anchors.rightMargin: -1 // reach over into next item

		opacity: 0.0
	}

	StateGroup
	{
		id: visibilityStates
		states:
		[
			State
			{
				name: "showing"; when: stateVisible
				PropertyChanges { target: borderedItem; width: itemWidth }
				PropertyChanges { target: loader; opacity: 1.0 }
			},
			State
			{
				name: "hiding"; when: !stateVisible
				PropertyChanges { target: borderedItem; width: 0 }
				PropertyChanges { target: loader; opacity: 0.0 }
			}
		]
	}

	StateGroup
	{
		id: hoverStates
		states:
		[
			State
			{
				name: "hovered"; when: loader.item && (loader.item.hovered || loader.item.pressed)
				PropertyChanges { target: hoverRect; opacity: hoverRectOpacity - (hoverRectOpacity * borderOpacity) }
			}
		]

		transitions: Transition
		{
			from: "hovered"; to: "*"
			NumberAnimation { property: "opacity"; duration: borderHoverAnimationDuration }
		}
	}
}
