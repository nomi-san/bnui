import QtQuick 2.2

QtObject
{
	id: container

	property ButtonStatePropertyGroup activated:ButtonStatePropertyGroup{}
	property ButtonStatePropertyGroup normal:	ButtonStatePropertyGroup{}
	property ButtonStatePropertyGroup hovered:	ButtonStatePropertyGroup{}
	property ButtonStatePropertyGroup pressed:	ButtonStatePropertyGroup{}
	property ButtonStatePropertyGroup disabled:	ButtonStatePropertyGroup{}
}
