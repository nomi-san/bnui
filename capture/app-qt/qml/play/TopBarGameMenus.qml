import QtQuick 2.2
import Phoenix 1.0

import "../common"

Row
{
	id: topBarGameMenus
	property variant view

	/* This should be a ContextMenuModel instance. */
	property variant model: view.contextMenu;

	TextLink
	{
		id: moreOptions

		//: The game options menu.
		text: qsTr("Options")
		iconSource: "../images/contextMenu_gamesetting_on.png"
		dropDownVisible: true

		iconDistance: 4

		visible: moreOptionsModel.count > 0

		anchors.verticalCenter: parent.verticalCenter

		onPressed:
		{
			var rect = util.globalGeometry(moreOptions);
			var centeredRect = util.globalGeometry(moreOptions.dropdownItem);
			rect.height -= 9;
			view.OpenMoreOptionsMenu(centeredRect, rect);
		}
	}

	spacing: 13

	Row
	{
		spacing: 10
		anchors.verticalCenter: parent.verticalCenter

		Repeater
		{
			model: mainMenuModel

			TextLink
			{
				id: menuItem
				text: model.text
				iconSource: util.fromCatalog(model.iconUrl);
				enabled: model.action.enabled
				textColor: model.textColor
				onClicked: model.item.trigger()
				property variant balloonTooltipText: model.item.statusTip
				toolTip: model.item.toolTip
				tipType: ToolTip.ArrowUp
				showToolTipWhenDisabled: true

				GameMenuItemBalloonLoader
				{
					anchorTarget: parent
					tipType: ToolTip.ArrowUp
					balloonText: balloonTooltipText
					modelItem: model.item

					anchors
					{
						top: parent.bottom
						topMargin: 1
					}

					visible: balloonTooltipText != ""
				}
				
				onShowToolTip:
				{
					// If we don't set our own tooltip text or set it to empty string,
					// model.item.toolTip return the menu item text, so we need to
					// explicitly check that they are different.
					if (menuItem.toolTip !== model.item.text)
					{
						util.showToolTip(menuItem, menuItem, menuItem.toolTip, ToolTip.ArrowUp, true);
					}
				}
			}
		}
	}

	GameContextMenuFilterModel
	{
		id: mainMenuModel

		filter: GameContextMenuFilterModel.Main
		model: topBarGameMenus.model
	}

	GameContextMenuFilterModel
	{
		id: moreOptionsModel

		filter: GameContextMenuFilterModel.MoreOptions
		model: topBarGameMenus.model
	}
}
