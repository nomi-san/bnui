import QtQuick 2.2

TextEdit
{
	id: textEdit

	cursorShape: textEdit.enabled ? Qt.IBeamCursor : Qt.ArrowCursor;
	font.family: fonts.textFieldRegularFontName
}
