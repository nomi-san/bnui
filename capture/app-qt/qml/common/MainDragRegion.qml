import QtQuick 2.2

MouseArea
{
    id: mainDragRegion
    property variant targetWindow: self
    property variant clickPos: Qt.point(1, 1)
    property bool buttonPressed
    onPressed: {
        clickPos = Qt.point(mouse.x, mouse.y)
        buttonPressed = true;
    }
    onReleased:
    {
        buttonPressed = false;
    }
    onPositionChanged:
    {
        if (buttonPressed)
        {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
            targetWindow.pos = Qt.point(targetWindow.pos.x + delta.x, targetWindow.pos.y + delta.y)
        }
    }
}
