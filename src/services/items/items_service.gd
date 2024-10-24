extends Node

class_name ItemsService

# INFO: Since this class is static, it is not possible to use exports for resources since we have no attached scene
static var item_stats_pools: ItemStatsPools = load("res://src/resources/items/stats/pools/item_stats_pools.tres")
static var item_pools: ItemPools = load("res://src/resources/items/item_pools/item_pools.tres")


static func create_item(item_type: ItemType.ItemType, item_rarity: ItemRarity.ItemRarity) -> Item:
	var item := Item.new()

	# Fixed
	item.level = 1

	# From constructor
	item.type = item_type
	item.rarity = item_rarity

	# Depend on constructor
	var item_stats_pool := _get_stats_pool_from_pools(item_type, item_rarity)
	item.main_stat = _get_main_stat(item_stats_pool)
	item.additional_stats = _get_additionnal_stats(item_stats_pool)

	var item_blueprint: ItemBlueprint = _get_blueprint_from_pools(item_type, item_rarity)
	item.name = item_blueprint.name
	item.texture = item_blueprint.texture

	return item


static func create_random_item() -> Item:
	var item_type: ItemType.ItemType = ItemType.ItemType.values().pick_random()
	var item_rarity: ItemRarity.ItemRarity = ItemRarity.ItemRarity.values().pick_random()

	return create_item(item_type, item_rarity)


static func _get_additionnal_stats(item_stats_pool: ItemStatsPool) -> Array[ItemStat]:
	var item_additionnal_stats_blueprints: Array[ItemStatBlueprint] = []
	var potential_stats_blueprints := item_stats_pool.potential_stats
	potential_stats_blueprints.shuffle()
	item_additionnal_stats_blueprints = potential_stats_blueprints.slice(0, 4)

	var item_additionnal_stats: Array[ItemStat] = []
	for item_additionnal_stats_blueprint in item_additionnal_stats_blueprints:
		var item_additionnal_stat: ItemStat = _roll_stat_value(item_additionnal_stats_blueprint)

		item_additionnal_stats.push_back(item_additionnal_stat)

	return item_additionnal_stats


static func _get_main_stat(item_stats_pool: ItemStatsPool) -> ItemStat:
	return _roll_stat_value(item_stats_pool.main_stat)


static func _get_blueprint_from_pools(
	item_type: ItemType.ItemType, item_rarity: ItemRarity.ItemRarity
) -> ItemBlueprint:
	match item_type:
		ItemType.ItemType.BOOTS:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_pools.boots.normal.pick_random()
		ItemType.ItemType.CHESTPLATE:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_pools.chestplates.normal.pick_random()
		ItemType.ItemType.GLOVES:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_pools.gloves.normal.pick_random()
		ItemType.ItemType.HELMET:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_pools.helmets.normal.pick_random()
		ItemType.ItemType.SHIELD:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_pools.shields.normal.pick_random()
		ItemType.ItemType.SWORD:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_pools.swords.normal.pick_random()

	# WIP
	return item_pools.swords.normal[0]


static func _get_stats_pool_from_pools(
	item_type: ItemType.ItemType, item_rarity: ItemRarity.ItemRarity
) -> ItemStatsPool:
	match item_type:
		ItemType.ItemType.BOOTS:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_stats_pools.boots.normal
		ItemType.ItemType.CHESTPLATE:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_stats_pools.chestplates.normal
		ItemType.ItemType.GLOVES:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_stats_pools.gloves.normal
		ItemType.ItemType.HELMET:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_stats_pools.helmets.normal
		ItemType.ItemType.SHIELD:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_stats_pools.shields.normal
		ItemType.ItemType.SWORD:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_stats_pools.swords.normal

	# WIP
	return item_stats_pools.swords.normal


static func _roll_stat_value(item_stat_blueprint: ItemStatBlueprint) -> ItemStat:
	var item_stat := ItemStat.new()

	item_stat.statistic = item_stat_blueprint.statistic

	var item_stat_base_value := 0.0

	var base_value_dice_roll := randf()
	var base_value_range: float = (
		item_stat_blueprint.base_value_max - item_stat_blueprint.base_value_min
	)
	var base_value_num_step: float = base_value_range / item_stat_blueprint.base_value_step

	var base_value_rolled_steps := ceili(base_value_dice_roll * base_value_num_step)
	item_stat_base_value = (
		item_stat_blueprint.base_value_min
		+ base_value_rolled_steps * item_stat_blueprint.base_value_step
	)

	# Security, useless ?
	item_stat.base_value = clamp(
		item_stat_base_value, item_stat_blueprint.base_value_min, item_stat_blueprint.base_value_max
	)

	return item_stat
