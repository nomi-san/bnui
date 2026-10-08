import QtQuick 2.2
import Phoenix 1.0

Item
{
	id: fonts

	property bool mac: appController.platform === "Mac"

	property alias lightFont:   lightFont
	property alias regularFont: regularFont

	// On TextField, TextInput, Windows and Mac renders text same, so we need to use different set of fonts on them.
	property string textFieldRegularFontName: fonts.mac ? regularFont.name: lightFont.name

	FontLoader
	{
		id: lightFont;
		name: fontManager.lightFontName
	}
	FontLoader
	{
		id: regularFont;
		name: fontManager.regularFontName
	}
}

