extends Control

signal on_salvage_item

var _item: Item = null


func _prettify_level(level: int) -> String:
	return "Lv. {0}".format([level])


func _prettify_statistic(item_stat: ItemStat, level: int) -> String:
	var current_value := item_stat.base_value * level

	return ItemStatistics._prettify_statistic(item_stat.statistic, current_value)


func _update_item_details_menu() -> void:
	if _item == null:
		return

	%ItemNameLabel.text = _item.name
	%ItemTexture.texture = _item.texture
	%ItemRarityLabel.text = ItemRarity._prettify_rarity(_item.rarity)
	%ItemLevelLabel.text = _prettify_level(_item.level)

	%MainStatLabel.text = _prettify_statistic(_item.main_stat, _item.level)
	%AdditionnalStat1Label.text = _prettify_statistic(_item.additional_stats[0], _item.level)

	if _item.additional_stats.size() >= 2:
		%AdditionnalStat2Label.text = _prettify_statistic(_item.additional_stats[1], _item.level)
	else:
		%AdditionnalStat2Label.text = ""

	if _item.additional_stats.size() >= 3:
		%AdditionnalStat3Label.text = _prettify_statistic(_item.additional_stats[2], _item.level)
	else:
		%AdditionnalStat3Label.text = ""

	if _item.additional_stats.size() >= 4:
		%AdditionnalStat4Label.text = _prettify_statistic(_item.additional_stats[3], _item.level)
	else:
		%AdditionnalStat4Label.text = ""

	%SalvagePriceLabel.text = str(_item.item_salvage_price())
	%LevelUpCostLabel.text = str(_item.level_up_cost())

	%LevelUpButton.disabled = (_item.level_up_cost() > Data.currencies.amethyst.get_value())

	if _item.is_equipped:
		%EquipButton.text = "Unequip"
	else:
		%EquipButton.text = "Equip"


func open_for_item(item_client_id: String) -> void:
	_item = Services.inventory.get_item_from_client_id(item_client_id)

	if _item == null:
		%NoItemSelectedLabel.show()
		%ItemsDetailVBoxContainer.hide()

		return

	%ItemsDetailVBoxContainer.show()
	%NoItemSelectedLabel.hide()

	_update_item_details_menu()


func _on_level_up_button_pressed() -> void:
	Data.currencies.amethyst.update_value(-_item.level_up_cost())
	Services.inventory.level_up_item(_item.client_id)

	_update_item_details_menu()


func _on_salvage_button_pressed() -> void:
	Data.currencies.amethyst.update_value(_item.item_salvage_price())
	Services.inventory.delete_item(_item.client_id)

	on_salvage_item.emit()


func _on_equip_button_pressed() -> void:
	if _item.is_equipped:
		Services.inventory.unequip_item(_item.client_id)
	else:
		Services.inventory.equip_item(_item.client_id)

	_update_item_details_menu()
