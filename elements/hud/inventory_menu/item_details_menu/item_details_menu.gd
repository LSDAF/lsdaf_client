extends Control

signal on_salvage_item(item_index: int)

var _item: Item = null
var _item_index: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _prettify_level(level: int) -> String:
	return "Lv. {0}".format([level])


func _prettify_rarity(item_rarity: ItemRarity.ItemRarity) -> String:
	match item_rarity:
		ItemRarity.ItemRarity.NORMAL:
			return "Normal"
		_:
			return "NO_RARITY"


func _prettify_statistic(item_stat: ItemStat, level: int) -> String:
	var prettified_statistic := ""

	var current_value := item_stat.base_value * (level / 100.0)

	match item_stat.statistic:
		ItemStatistics.ItemStatistics.ATTACK_ADD:
			prettified_statistic = "+{0} {1}".format([current_value, "Attack"])
		ItemStatistics.ItemStatistics.ATTACK_MULT:
			prettified_statistic = "+{0}% {1}".format([current_value, "Attack"])
		ItemStatistics.ItemStatistics.CRIT_CHANCE:
			prettified_statistic = "+{0}% {1}".format([current_value, "Crit. Chance"])
		ItemStatistics.ItemStatistics.CRIT_DAMAGE:
			prettified_statistic = "+{0}% {1}".format([current_value, "Crit. Damage"])
		ItemStatistics.ItemStatistics.HP_ADD:
			prettified_statistic = "+{0} {1}".format([current_value, "HP"])
		ItemStatistics.ItemStatistics.HP_MULT:
			prettified_statistic = "+{0}% {1}".format([current_value, "HP"])
		ItemStatistics.ItemStatistics.RESISTANCE_ADD:
			prettified_statistic = "+{0} {1}".format([current_value, "Resistance"])
		ItemStatistics.ItemStatistics.RESISTANCE_MULT:
			prettified_statistic = "+{0}% {1}".format([current_value, "Resistance"])
		_:
			prettified_statistic = "UNSUPPORTED"

	return prettified_statistic


func _update_item_details_menu() -> void:
	if _item == null:
		return

	%ItemNameLabel.text = _item.name
	%ItemTexture.texture = _item.texture
	%ItemRarityLabel.text = _prettify_rarity(_item.rarity)
	%ItemLevelLabel.text = _prettify_level(_item.level)

	%MainStatLabel.text = _prettify_statistic(_item.main_stat, _item.level)
	%AdditionnalStat1Label.text = _prettify_statistic(_item.additional_stats[0], _item.level)
	%AdditionnalStat2Label.text = _prettify_statistic(_item.additional_stats[1], _item.level)
	%AdditionnalStat3Label.text = _prettify_statistic(_item.additional_stats[2], _item.level)
	%AdditionnalStat4Label.text = _prettify_statistic(_item.additional_stats[3], _item.level)

	%SalvagePriceLabel.text = str(_item.item_salvage_price())
	%LevelUpCostLabel.text = str(_item.level_up_cost())

	%LevelUpButton.disabled = (_item.level_up_cost() > Currencies.amethyst.get_value())

	if _item.is_equipped:
		%EquipButton.text = "Unequip"
	else:
		%EquipButton.text = "Equip"


func open_for_item(item_index: int) -> void:
	_item_index = item_index
	_item = Inventory.get_item_at_index(item_index)

	if _item == null:
		%NoItemSelectedLabel.show()
		%ItemsDetailVBoxContainer.hide()

		return

	%ItemsDetailVBoxContainer.show()
	%NoItemSelectedLabel.hide()

	_update_item_details_menu()


func _on_level_up_button_pressed() -> void:
	Currencies.amethyst.update_value(-_item.level_up_cost())
	Inventory.level_up_item_at_index(_item_index)

	_update_item_details_menu()


func _on_salvage_button_pressed() -> void:
	Currencies.amethyst.update_value(_item.item_salvage_price())
	Inventory.delete_item_at_index(_item_index)

	on_salvage_item.emit(_item_index)
	#_update_item_details_menu()


func _on_equip_button_pressed() -> void:
	if _item.is_equipped:
		Inventory.unequip_item_at_index(_item_index)
	else:
		Inventory.equip_item_at_index(_item_index)

	_update_item_details_menu()
