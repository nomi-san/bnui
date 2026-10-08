import QtQuick 2.2
import Phoenix 1.0

QtObject
{
	function globalGeometry(item)
	{
		return self.GetGlobalRect(item);
	}

	function mouseHoverOver(item)
	{
		var cursorPos = appController.GetMousePosition()
		var globalRect = util.globalGeometry(item);
		if ((globalRect.x <= cursorPos.x && cursorPos.x < globalRect.x + globalRect.width)
			&& (globalRect.y <= cursorPos.y && cursorPos.y < globalRect.y + globalRect.height))
		{
			return true;
		}
		return false;
	}

	function hideToolTip()
	{
		appController.ShowToolTipExplicit(Qt.rect(0,0,0,0), "", 0, self, Qt.rect(0,0,0,0), true /*noDelay*/, false, true);
	}

	function showToolTip(mouseArea, centeredItem, tooltipText, arrowDirection, noDelay, popupMode, enableHtml)
	{
		if (typeof arrowDirection === 'undefined')
		{
			arrowDirection = ToolTip.ArrowDown;
		}

		if (typeof popupMode === 'undefined')
		{
			popupMode = false;
		}

		if (typeof noDelay === 'undefined')
		{
			noDelay = false;
		}

		if (typeof enableHtml === 'undefined')
		{
			enableHtml = true;
		}

		var centeredRect = globalGeometry(centeredItem);
		var anchorRect = globalGeometry(mouseArea);

		appController.ShowToolTipExplicit(centeredRect, tooltipText, arrowDirection, self, anchorRect, noDelay, popupMode, enableHtml);
	}

	function fromCatalog(url, depth)
	{
		// turn url into a js string
		url = url + "";

		if (url.substring(0, 8) === "image://") {
			return url;
		}

		if (url === "") {
			return url;
		}

		depth = depth === undefined ? 1 : depth;
		var s = new Array(depth + 1).join("../../");
		var newS = s + url; /* + url.replace("resources/", "");*/

		//console.log("fromCatalog: " + url + " => " + newS);
		return newS;
	}

	function isAsianLocale()
	{
		var locale = appController.locale;
		return locale === "koKR" || locale === "zhTW" || locale === "zhCN"
	}

	function isMac()
	{
		return appController.platform == "Mac";
	}
}
