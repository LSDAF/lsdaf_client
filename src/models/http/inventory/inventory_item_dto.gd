class_name InventoryItemDto

var main_stat: ItemStat
var additional_stats: Array[ItemStat]
var rarity: ItemRarity.ItemRarity
var level: int
var type: ItemType.ItemType
var is_equipped: bool = false


func _init(dictionary: Dictionary) -> void:
	main_stat = ItemStat.new()
	main_stat.statistic = ItemStatistics.value_of(dictionary["main_stat"]["statistic"])
	main_stat.base_value = dictionary["main_stat"]["base_value"]

	for additional_stat: Dictionary in dictionary["additional_stats"]:
		additional_stats.push_back(ItemStat.new())
		additional_stats.back().statistic = ItemStatistics.value_of(additional_stat["statistic"])
		additional_stats.back().base_value = additional_stat["base_value"]

	rarity = ItemRarity.value_of(dictionary["rarity"])
	level = dictionary["level"]
	type = ItemType.value_of(dictionary["type"])
	is_equipped = dictionary["is_equipped"]
