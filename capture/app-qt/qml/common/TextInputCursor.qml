import QtQuick 2.2

TextInput
{
	id: textInput

	cursorShape: textInput.enabled ? Qt.IBeamCursor : Qt.ArrowCursor;
	font.family: fonts.textFieldRegularFontName
}
