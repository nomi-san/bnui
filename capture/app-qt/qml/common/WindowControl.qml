import QtQuick 2.2

Item
{
	id: windowControl

	anchors.top: parent.top
	anchors.topMargin: topMargin
	anchors.right: parent.right
	anchors.rightMargin: edgeMargin

	width: controlArea.width
	height: controlArea.height

	property alias buttonStyle: buttonStyleLoader.item

	property bool allowMaximize: false
	property bool allowMinimize: true

	property int edgeMargin: buttonStyle.outerMargin
	property int topMargin: buttonStyle.topMargin
	property int buttonSpacing: buttonStyle.innerMargin

	signal closeClicked();

	MouseArea
	{
		id: controlMouseArea
		width: controlArea.width
		height: controlArea.height

		hoverEnabled: true

		onPressed: mouse.accepted = false

		Row
		{
			id: controlArea
			layoutDirection: buttonStyle.layoutDirection
			spacing: buttonSpacing

			Row
			{
				spacing: buttonSpacing

				WindowButton
				{
					id: minimizeButton

					buttonState: buttonStyle.minButtonState
					buttonProperties: buttonStyle.minButtonProperties

					visible: windowControl.allowMinimize
					onClicked: self.showMinimized();
				}

				WindowButton
				{
					id: maximizeButton

					buttonState: buttonStyle.maxButtonState
					buttonProperties: buttonStyle.maxButtonProperties

					visible: windowControl.allowMaximize
					onClicked:
					{
						if (!self.maximized)
							self.showMaximized();
						else
							self.showNormal();
					}
				}
			}

			WindowButton
			{
				id: closeButton

				buttonState: buttonStyle.closeButtonState
				buttonProperties: buttonStyle.closeButtonProperties

				onClicked: windowControl.closeClicked();
			}
		}
	}

	Binding	{ target: buttonStyle;	property: "minMouseArea";		value: minimizeButton.mouseArea }
	Binding	{ target: buttonStyle;	property: "maxMouseArea";		value: maximizeButton.mouseArea }
	Binding	{ target: buttonStyle;	property: "closeMouseArea";		value: closeButton.mouseArea }
	Binding	{ target: buttonStyle;	property: "controlMouseArea";	value: controlMouseArea }

	Loader
	{
		id: buttonStyleLoader
		source: "WindowControlStyle.qml"
	}
}
