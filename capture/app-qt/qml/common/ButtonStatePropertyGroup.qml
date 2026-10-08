import QtQuick 2.2

QtObject
{
	/*
	 * ButtonStateImage relies on the default values for value, opacity and
	 * color to be undefined.
	 */
	property variant value
	property real opacity: 1.0
	property real desaturation: 0.0
	property color color
	property int offsetX: 0
	property int offsetY: 0
}
