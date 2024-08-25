class_name Item

var main_stat: ItemStat
var additional_stats: Array[ItemStat]
var rarity: ItemRarity.ItemRarity
var level: int
var type: ItemType.ItemType
var name: String
var texture: Texture2D


func level_up_cost() -> int:
	return pow(level, 1.25)


func item_salvage_price() -> int:
	return pow(level, 1.5)
