import QtQuick 2.2

AnimatedImage
{
	id: spinner

	property string colorOverride: ""
	property bool small: false
	source: small ? "../images/spinner_small.webp" : "../images/spinner.webp"

	playing: spinner.visible
}
