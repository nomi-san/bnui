import QtQuick 2.2
Item
{
	id: container

	property string sourceText: ""
	property bool _updating: false
	property int _margins: 10

	Text
	{
		id: displayText
		anchors.fill: parent

		wrapMode: Text.Wrap
		font.family: fonts.regularFont.name
		font.pixelSize: 13;
		color: "white"
		verticalAlignment: Text.AlignVCenter
	}

	Component.onCompleted: updateText()
	onSourceTextChanged: updateText()
	onWidthChanged: updateText()

	function isFit()
	{
		return displayText.paintedWidth <= container.width;
	}

	function findMiddleSpace(text)
	{
		var middleIndex = text.length/2;

		var firstHalf = text.substr(0, middleIndex);
		var secondHalf = text.substr(middleIndex);

		var middleLeftIndex = firstHalf.lastIndexOf(' ');
		var middleRightIndex = secondHalf.indexOf(' ') >= 0
				? firstHalf.length + secondHalf.indexOf(' ')
				: -1;

		if (middleLeftIndex > 0 && middleRightIndex > 0)
		{
			// There're two candidates, find clostest one to the middle index
			return (Math.abs(middleLeftIndex - middleIndex) < Math.abs(middleRightIndex - middleIndex))
				? middleLeftIndex : middleRightIndex;
		}
		else
		{
			// Either one of them is -1, which also covers no space case.
			return middleLeftIndex > 0 ? middleLeftIndex : middleRightIndex;
		}
	}

	function tryRegularFormat()
	{
		displayText.wrapMode = Text.NoWrap;
		displayText.text = container.sourceText;

		container._margins = 25;

		return isFit();
	}

	function tryShrinkPadding()
	{
		displayText.wrapMode = Text.NoWrap;
		displayText.text = container.sourceText

		container._margins = 5;

		return isFit();
	}

	function tryWrap()
	{
		displayText.wrapMode = Text.WordWrap;
		displayText.text = container.sourceText

		container._margins = 25;

		return isFit();
	}

	function tryBreakWord()
	{
		var newText = container.sourceText;
		var n = findMiddleSpace(newText);

		// No space found in the string
		if (n < 0)
			return false;

		displayText.wrapMode = Text.NoWrap;
		displayText.text = newText.substring(0,n) + ' \n' + newText.substring(n + 1);

		container._margins = 10;

		return isFit();
	}

	function updateText()
	{
		if (_updating)
			return;

		_updating = true;

		do
		{
			if (tryRegularFormat())
				break;

			if (util.isAsianLocale())
			{
				if (tryShrinkPadding() || tryBreakWord())
					break;
			}

			// As final solution, just wrap it.
			tryWrap();
			break;

		} while (false)

		_updating = false;
	}
}
