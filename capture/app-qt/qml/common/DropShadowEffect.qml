import QtQuick 2.2
import QtGraphicalEffects 1.0 as Effects

Effects.DropShadow
{
	horizontalOffset: 1
	verticalOffset: 1

	radius: 5.0
	samples: radius * 2
	color: "#000000"
}
