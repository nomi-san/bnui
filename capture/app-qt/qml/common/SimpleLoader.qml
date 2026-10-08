import QtQuick 2.2

Loader
{
	property Component component: undefined

	visible: false

	sourceComponent: visible ? component : undefined
}
