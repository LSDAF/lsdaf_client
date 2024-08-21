extends Control

var _item: Item = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _prettify_rarity(item_rarity: ItemRarity.ItemRarity) -> String:
	match item_rarity:
		ItemRarity.ItemRarity.NORMAL:
			return "Normal"
		_:
			return "NO_RARITY"


func _prettify_statistic(item_stat: ItemStat, level: int) -> String:
	var prettified_statistic := ""

	var current_value := item_stat.base_value * (level / 100)

	match item_stat.statistic:
		ItemStatistics.ItemStatistics.ATTACK_ADD:
			prettified_statistic = "+{0} {1}".format([current_value, "Attack"])
		ItemStatistics.ItemStatistics.ATTACK_MULT:
			prettified_statistic = "+{0}% {1}".format([current_value, "Attack"])
		ItemStatistics.ItemStatistics.HP_ADD:
			prettified_statistic = "+{0} {1}".format([current_value, "HP"])
		ItemStatistics.ItemStatistics.HP_MULT:
			prettified_statistic = "+{0}% {1}".format([current_value, "HP"])
		_:
			prettified_statistic = "UNSUPPORTED"

	return prettified_statistic


func _update_item_details_menu() -> void:
	if _item == null:
		return

	%ItemNameLabel.text = _item.name
	%ItemTexture.texture = _item.texture
	%ItemRarityLabel.text = _prettify_rarity(_item.rarity)

	%MainStatLabel.text = _prettify_statistic(_item.main_stat, _item.level)
	%AdditionnalStat1Label.text = _prettify_statistic(_item.additional_stats[0], _item.level)
	%AdditionnalStat2Label.text = _prettify_statistic(_item.additional_stats[1], _item.level)
	%AdditionnalStat3Label.text = _prettify_statistic(_item.additional_stats[2], _item.level)
	%AdditionnalStat4Label.text = _prettify_statistic(_item.additional_stats[3], _item.level)


func update_selected_item(item: Item) -> void:
	_item = item

	if _item == null:
		%NoItemSelectedLabel.show()
		%ItemsDetailVBoxContainer.hide()

		return

	%ItemsDetailVBoxContainer.show()
	%NoItemSelectedLabel.hide()

	_update_item_details_menu()
