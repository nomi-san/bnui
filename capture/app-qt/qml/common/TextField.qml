import QtQuick 2.2

FocusScope
{
	id: container

	width: 284;
	height: 37;

	signal accepted

    property alias title: title.text
    property alias text: input.text
    property alias item: input
	property alias textColor: input.color
	property alias maximumLength: input.maximumLength
	property int inputSize: 13

	// this should be BorderImage so that it can be resized
	BorderImage
	{
		id: field
		source: "../images/TextBox_off.png"
		anchors.fill: parent
		horizontalTileMode: BorderImage.Repeat
		border.left: 6; border.top: 6
		border.right: 6; border.bottom: 6
	}

	Text
	{
		id: title
		anchors.left: parent.left
		anchors.leftMargin: 12
		anchors.right: parent.right
		anchors.rightMargin: 5
		anchors.verticalCenter: parent.verticalCenter
		font.family: fonts.regularFont.name
		font.pixelSize: 13;
		font.letterSpacing: 0
		opacity: 0.20
		color: "#ffffff";
		text: ""

		states:
		[
			State
			{
				name: "hasTextActive";
				when: input.text != ''
				PropertyChanges { target: title; opacity: 0 }
				PropertyChanges { target: field; source: "../images/TextBox_active.png"; }
			}
		]
	}

	TextInputCursor
	{
		id: input
		anchors.left: parent.left
		anchors.leftMargin: 12
		anchors.right: parent.right
		anchors.rightMargin: 12
		anchors.verticalCenter: parent.verticalCenter
		focus: true

		font.pixelSize: inputSize;
		font.letterSpacing: 0
		opacity: 0.70

		color: "#ffffff";
		selectionColor: "#787878"

		onAccepted: container.accepted()

		selectByMouse: true
    }

	MouseArea
	{
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true
		onPressed:
		{
			// make sure TextInput is focused when clicked
			input.forceActiveFocus();
			mouse.accepted = false;
		}
	}

    states:
	[
		State
		{
			name: "Disabled"
			when: !input.enabled
			PropertyChanges { target: field; source: "../images/TextBox_off.png"; opacity: 0.15 }
			PropertyChanges { target: input; color: "#ffffff"; opacity: 0.2; cursorVisible: false }
		},
		State
		{
			name: "Active"
			when: input.activeFocus			
			PropertyChanges { target: field; source: "../images/TextBox_active.png"; }
		},

		State {
			name: "Inactive"
			when: mouseArea.containsMouse
			PropertyChanges { target: field; source: "../images/TextBox_over.png"; }
		}
	]

}
