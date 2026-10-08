import QtQuick 2.2
import "../common"

DebugBox
{
	visible: appController.debug
	border.color: "white"; border.width: 0
	anchors.bottomMargin: 0; anchors.rightMargin: 0
	color: "red";
	opacity: 0.1;
}