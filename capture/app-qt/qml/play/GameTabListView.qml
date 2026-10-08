import QtQuick 2.3
import QtQml.Models 2.1

ListView
{
	id: gameTabListView

	property var listModel: gameController.blizzardProductsModel
	
	height: contentHeight
	snapMode: ListView.NoSnap;
	interactive: false

	// DelegateModel is used to support moving items via drag & drop
	model: DelegateModel
	{
		id: visualModel
		model: gameTabListView.listModel

		delegate: GameTabListItem
		{
			width: gameTabListView.width
			height: 44

			listView: gameTabListView
		}
	}
}

