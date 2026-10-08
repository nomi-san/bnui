import QtQuick 2.0

import "../common"

Canvas {
	id: canvas

	property string text: ""
 	property string color1: _defaultColor1;
	property string color2: _defaultColor2;
	property int badgeWidth: 50
	property int badgeHeight: 50
	property int badgeThickness: 25
	property double scaleFactor: 1.0

	property string _defaultColor1: "#016e97";
 	property string _defaultColor2: "#008dc2"

	visible: text.length > 0
	width: (badgeWidth + badgeThickness + 10) * deviceScaleRatio();
	height: (badgeHeight + badgeThickness + 10) * deviceScaleRatio();

	renderTarget: Canvas.Image;

	onVisibleChanged: canvas.requestPaint();
	onTextChanged: canvas.requestPaint();
	onColor1Changed: canvas.requestPaint();
	onColor2Changed: canvas.requestPaint();

	transform: Scale {
		xScale: 1 / deviceScaleRatio() * scaleFactor;
		yScale: 1 / deviceScaleRatio() * scaleFactor;
	}

	function deviceScaleRatio() {
		// todo: use devicePixelRatio to avoid waste on mac
		return util.isMac() ? 2.0 : 1.0;
	}

	function getCanvasFont() {
		var fontName = fonts.regularFont.name;
		var blizzardFont = fontName.substring(0, 8) === 'Blizzard';
		if (util.isMac() && blizzardFont)
			fontName = 'Blizzard';
		return (blizzardFont ? "bold " : "") + "13px '" + fontName + "'";
	}

	onPaint: {
		var context = getContext("2d");
		context.clearRect(0, 0, canvas.width, canvas.height);

		if (!canvas.visible) return;
		context.save();

		context.scale(deviceScaleRatio(), deviceScaleRatio());

		var grd = context.createLinearGradient(-6, 68, 68, -6);
		grd.addColorStop(0.2, canvas.color1);
		grd.addColorStop(0.8, canvas.color2);

		context.beginPath();
		context.moveTo(canvas.badgeWidth, 0);
		context.lineTo(0, canvas.badgeHeight);
		context.lineTo(0, canvas.badgeHeight + canvas.badgeThickness);
		context.lineTo(canvas.badgeWidth + canvas.badgeThickness, 0);
		context.closePath()
		context.fillStyle = grd;

		context.save();
		context.shadowColor = "rgba(0,0,0,.3)";
		context.shadowBlur = 5;
		context.shadowOffsetX = 1;
		context.shadowOffsetY = 1;
		context.fill();
		context.restore();

		context.translate((badgeWidth + badgeThickness) / 2, (badgeHeight + badgeThickness) / 2);
		context.rotate(-Math.PI/4);
		context.textAlign = "center";
		context.fillStyle = "#000000";

		context.font = getCanvasFont();
		context.textBaseline = "bottom";
		context.fillText(canvas.text.toUpperCase(), 0, 0);

		context.restore();
	}
}
