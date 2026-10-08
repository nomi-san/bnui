import QtQuick 2.2
import Phoenix 1.0 as Phoenix
import QtQml.Models 2.1
import "../common"

GameTabItem
{
	id: listItem

	property variant listView
	property int visualIndex: DelegateModel.itemsIndex

	anchors.topMargin: listItem.visualIndex == 0 ? 4 : 0

	game: model.gameTabItem
	isCurrentItem: gameController.familyId === game.productId

	dragActive: listItem.drag.active
	dragParent: gameTabListView
	dragEnabled: true

	onPressed: listItem.listView.interactive = false;

	onReleased:
	{
		listItem.listView.interactive = true;

		if (listItem.stopDrag()) {
			listItem.listView.listModel.MoveTab(listItem.game.productId, listItem.visualIndex + 1);
		}
	}

	DropArea
	{
		anchors.fill: parent

		// Ensure that drop events are not accepted so that they may be propogated to other elements
		// that are covered by this one (i.e. scroll buttons).
		onEntered:
		{
			if (!drag.source || drag.source.listView != listView) {
				return;
			}

			// When dragging game icon overlaps other game icon, swap index in DelegateModel
			// Changed tab oders will be committed when mouse button is released
			visualModel.items.move(drag.source.visualIndex, listItem.visualIndex);
		}
	}
}
