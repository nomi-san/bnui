import QtQuick 2.0

Item {
	id: rootItem

	/*!
		The source image. Each pixel in this image will be tested against the
		cooresponding pixel in the maskSource image's alpha value. If the alpha
		value of the current pixel is not 0 in the maskSource image, the pixel from
		the source image will be rendered.
	*/
	property variant source

	/*!
		The mask image. The alpha values of this image will be used to
		determine the sections where the source image will be visible.
	*/
	property variant maskSource

	/*!
		These properties allow us to control where in the source image pixels will
		begin to be evaluated against the mask.
	*/
	property real sourceTextureOffsetY: 0.0
	property real sourceTextureOffsetX: 0.0

	ShaderEffectSource {
		id: maskEffectSource
		live:false
		sourceItem: rootItem.maskSource
	}

	ShaderEffectSource {
		id: sourceEffectSource
		live: false
		sourceItem: rootItem.source
	}

	ShaderEffect {
		id: shaderItem
		property variant source: sourceEffectSource.sourceItem
		property variant maskSource: maskEffectSource.sourceItem
		property real sourceTextureOffsetY : rootItem.sourceTextureOffsetY
		property real sourceTextureOffsetX : rootItem.sourceTextureOffsetX
		anchors.fill: parent

		fragmentShader: "
			varying highp vec2 qt_TexCoord0;
			uniform highp float qt_Opacity;
			uniform highp float sourceTextureOffsetY;
			uniform highp float sourceTextureOffsetX;
			uniform lowp sampler2D source;
			uniform lowp sampler2D maskSource;
			void main(void) {
				highp vec2 tx = vec2(qt_TexCoord0.s + sourceTextureOffsetX, qt_TexCoord0.t + sourceTextureOffsetY);
				gl_FragColor = texture2D(source, tx) * (texture2D(maskSource, qt_TexCoord0.st).a) * qt_Opacity;
			}
		"
	}
}
