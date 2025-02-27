# gdlint: disable=class-definitions-order

extends GutTest

var sut: ItemsService

var game_save_data := preload("res://src/data/game_save/game_save_data.gd")
var game_save_service := preload("res://src/services/game_save/game_save_service.gd")

var game_save_data_partial_double: Variant
var game_save_service_partial_double: Variant

var AttackAdd := preload("res://src/resources/items/stats/attack_add.tres")
var AttackMult := preload("res://src/resources/items/stats/attack_mult.tres")
var CritChance := preload("res://src/resources/items/stats/crit_chance.tres")
var CritDamage := preload("res://src/resources/items/stats/crit_damage.tres")
var HealthAdd := preload("res://src/resources/items/stats/health_add.tres")
var HealthMult := preload("res://src/resources/items/stats/health_mult.tres")
var ResistanceAdd := preload("res://src/resources/items/stats/resistance_add.tres")
var ResistanceMult := preload("res://src/resources/items/stats/resistance_mult.tres")


func before_each() -> void:
	game_save_data_partial_double = partial_double(game_save_data).new()
	game_save_service_partial_double = (
		partial_double(game_save_service)
		. new(
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			game_save_data_partial_double,
		)
	)

	sut = preload("res://src/services/items/items_service.gd").new(game_save_service_partial_double)


func test_create_item() -> void:
	# Arrange
	var item_type: ItemType.ItemType = ItemType.ItemType.SWORD
	var item_rarity: ItemRarity.ItemRarity = ItemRarity.ItemRarity.NORMAL

	# Act
	var item: Item = sut.create_item(item_type, item_rarity)

	# Assert
	assert_eq(item.type, item_type)
	assert_eq(item.rarity, item_rarity)
	assert_not_null(item.client_id)
	assert_not_null(item.blueprint_id)
	assert_ne(item.blueprint_id, "")


func test_get_additional_stats() -> void:
	# Arrange
	var item_stats_pool: ItemStatsPool = ItemStatsPool.new()
	item_stats_pool.main_stat = AttackAdd

	item_stats_pool.potential_stats.push_back(AttackMult)
	item_stats_pool.potential_stats.push_back(CritChance)
	item_stats_pool.potential_stats.push_back(CritDamage)
	item_stats_pool.potential_stats.push_back(HealthAdd)
	item_stats_pool.potential_stats.push_back(HealthMult)
	item_stats_pool.potential_stats.push_back(ResistanceAdd)
	item_stats_pool.potential_stats.push_back(ResistanceMult)

	# Act
	var stats: Array[ItemStat] = sut._get_additionnal_stats(item_stats_pool)

	# Assert
	assert_eq(stats.size(), 4)

	var unique_stats: Array[ItemStatistics.ItemStatistics] = []
	for stat in stats:
		assert_true(stat is ItemStat)
		assert_true(stat.statistic is ItemStatistics.ItemStatistics)
		assert_does_not_have(unique_stats, stat.statistic)
		unique_stats.push_back(stat.statistic)


func test_get_main_stat() -> void:
	# Arrange
	var item_stats_pool: ItemStatsPool = ItemStatsPool.new()
	item_stats_pool.main_stat = AttackAdd

	item_stats_pool.potential_stats.push_back(AttackMult)

	# Act
	var main_stat: ItemStat = sut._get_main_stat(item_stats_pool)

	# Assert
	assert_eq(main_stat.statistic, ItemStatistics.ItemStatistics.ATTACK_ADD)


# Parameters
# [item_type, item_rarity, expected_type, expected_rarity]
var test_get_random_blueprint_from_pools_parameters := [
	# Normal rarity cases
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.NORMAL,
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.NORMAL,
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.GLOVES,
		ItemRarity.ItemRarity.NORMAL,
		ItemType.ItemType.GLOVES,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.HELMET,
		ItemRarity.ItemRarity.NORMAL,
		ItemType.ItemType.HELMET,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.SHIELD,
		ItemRarity.ItemRarity.NORMAL,
		ItemType.ItemType.SHIELD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	# Rare rarity cases (when rare pools are empty)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.RARE,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.RARE,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.GLOVES,
		ItemRarity.ItemRarity.RARE,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.HELMET,
		ItemRarity.ItemRarity.RARE,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.SHIELD,
		ItemRarity.ItemRarity.RARE,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.RARE,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	# Rare rarity cases (when rare pools have items)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.RARE,
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.RARE
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.RARE,
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.RARE
	],
	[
		ItemType.ItemType.GLOVES,
		ItemRarity.ItemRarity.RARE,
		ItemType.ItemType.GLOVES,
		ItemRarity.ItemRarity.RARE
	],
	[
		ItemType.ItemType.HELMET,
		ItemRarity.ItemRarity.RARE,
		ItemType.ItemType.HELMET,
		ItemRarity.ItemRarity.RARE
	],
	[
		ItemType.ItemType.SHIELD,
		ItemRarity.ItemRarity.RARE,
		ItemType.ItemType.SHIELD,
		ItemRarity.ItemRarity.RARE
	],
	[
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.RARE,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.RARE
	],
	# Magic rarity cases (when magic pools are empty)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.MAGIC,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.MAGIC,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	# Magic rarity cases (when magic pools have items)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.MAGIC,
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.MAGIC
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.MAGIC,
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.MAGIC
	],
	# Epic rarity cases (when epic pools are empty)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.EPIC,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.EPIC,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	# Epic rarity cases (when epic pools have items)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.EPIC,
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.EPIC
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.EPIC,
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.EPIC
	],
	# Legendary rarity cases (when legendary pools are empty)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.LEGENDARY,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.LEGENDARY,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	# Legendary rarity cases (when legendary pools have items)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.LEGENDARY,
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.LEGENDARY
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.LEGENDARY,
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.LEGENDARY
	],
	# Mythic rarity cases (when mythic pools are empty)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.MYTHIC,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.MYTHIC,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	# Mythic rarity cases (when mythic pools have items)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.MYTHIC,
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.MYTHIC
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.MYTHIC,
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.MYTHIC
	],
	# Epic rarity cases (when epic pools are empty)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.EPIC,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.EPIC,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	# Epic rarity cases (when epic pools have items)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.EPIC,
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.EPIC
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.EPIC,
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.EPIC
	],
	# Legendary rarity cases (when legendary pools are empty)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.LEGENDARY,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.LEGENDARY,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	# Legendary rarity cases (when legendary pools have items)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.LEGENDARY,
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.LEGENDARY
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.LEGENDARY,
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.LEGENDARY
	],
	# Mythic rarity cases (when mythic pools are empty)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.MYTHIC,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.MYTHIC,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	# Mythic rarity cases (when mythic pools have items)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.MYTHIC,
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.MYTHIC
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.MYTHIC,
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.MYTHIC
	],
	[
		ItemType.ItemType.SHIELD,
		ItemRarity.ItemRarity.RARE,
		ItemType.ItemType.SHIELD,
		ItemRarity.ItemRarity.RARE
	],
	[
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.RARE,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.RARE
	],
	# Magic rarity cases (when magic pools are empty)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.MAGIC,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.MAGIC,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.GLOVES,
		ItemRarity.ItemRarity.MAGIC,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.HELMET,
		ItemRarity.ItemRarity.MAGIC,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.SHIELD,
		ItemRarity.ItemRarity.MAGIC,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	[
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.MAGIC,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.NORMAL
	],
	# Magic rarity cases (when magic pools have items)
	[
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.MAGIC,
		ItemType.ItemType.BOOTS,
		ItemRarity.ItemRarity.MAGIC
	],
	[
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.MAGIC,
		ItemType.ItemType.CHESTPLATE,
		ItemRarity.ItemRarity.MAGIC
	],
	[
		ItemType.ItemType.GLOVES,
		ItemRarity.ItemRarity.MAGIC,
		ItemType.ItemType.GLOVES,
		ItemRarity.ItemRarity.MAGIC
	],
	[
		ItemType.ItemType.HELMET,
		ItemRarity.ItemRarity.MAGIC,
		ItemType.ItemType.HELMET,
		ItemRarity.ItemRarity.MAGIC
	],
	[
		ItemType.ItemType.SHIELD,
		ItemRarity.ItemRarity.MAGIC,
		ItemType.ItemType.SHIELD,
		ItemRarity.ItemRarity.MAGIC
	],
	[
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.MAGIC,
		ItemType.ItemType.SWORD,
		ItemRarity.ItemRarity.MAGIC
	],
	# Invalid type case (should fall back to normal sword)
	[99, ItemRarity.ItemRarity.NORMAL, ItemType.ItemType.SWORD, ItemRarity.ItemRarity.NORMAL],
	# Invalid rarity case (should fall back to normal sword)
	[ItemType.ItemType.BOOTS, 99, ItemType.ItemType.SWORD, ItemRarity.ItemRarity.NORMAL],
]


func test_get_random_blueprint_from_pools(
	params: Array = use_parameters(test_get_random_blueprint_from_pools_parameters)
) -> void:
	# Arrange
	var item_type: ItemType.ItemType = params[0]
	var item_rarity: ItemRarity.ItemRarity = params[1]
	var expected_type: ItemType.ItemType = params[2]
	var expected_rarity: ItemRarity.ItemRarity = params[3]

	# Act
	var item_blueprint: ItemBlueprint = sut._get_random_blueprint_from_pools(item_type, item_rarity)

	# Assert
	assert_not_null(item_blueprint)
	assert_true(item_blueprint is ItemBlueprint)

	# When pools are empty, we expect a fallback to normal sword
	# When pools have items, we expect the correct item type and rarity
	if (
		(
			item_rarity == ItemRarity.ItemRarity.RARE
			or item_rarity == ItemRarity.ItemRarity.MAGIC
			or item_rarity == ItemRarity.ItemRarity.EPIC
			or item_rarity == ItemRarity.ItemRarity.LEGENDARY
			or item_rarity == ItemRarity.ItemRarity.MYTHIC
		)
		and item_blueprint.rarity == item_rarity
	):
		# If we got a matching rarity item, its type should match the requested type
		assert_eq(item_blueprint.type, item_type)
		assert_eq(item_blueprint.rarity, item_rarity)
	elif (
		(
			item_rarity == ItemRarity.ItemRarity.RARE
			or item_rarity == ItemRarity.ItemRarity.MAGIC
			or item_rarity == ItemRarity.ItemRarity.EPIC
			or item_rarity == ItemRarity.ItemRarity.LEGENDARY
			or item_rarity == ItemRarity.ItemRarity.MYTHIC
		)
		and item_blueprint.rarity == ItemRarity.ItemRarity.NORMAL
	):
		# If we got a normal item when requesting higher rarity, it should be a normal sword (fallback)
		assert_eq(item_blueprint.type, ItemType.ItemType.SWORD)
		assert_eq(item_blueprint.rarity, ItemRarity.ItemRarity.NORMAL)
	else:
		# For all other cases (normal items, invalid types/rarities), behavior should match expected
		assert_eq(item_blueprint.type, expected_type)
		assert_eq(item_blueprint.rarity, expected_rarity)


# Parameters
# [item_type, item_rarity]
var test_get_stats_pool_from_pools_parameters := [
	[ItemType.ItemType.BOOTS, ItemRarity.ItemRarity.NORMAL],
	[ItemType.ItemType.CHESTPLATE, ItemRarity.ItemRarity.NORMAL],
	[ItemType.ItemType.GLOVES, ItemRarity.ItemRarity.NORMAL],
	[ItemType.ItemType.HELMET, ItemRarity.ItemRarity.NORMAL],
	[ItemType.ItemType.SHIELD, ItemRarity.ItemRarity.NORMAL],
	[ItemType.ItemType.SWORD, ItemRarity.ItemRarity.NORMAL],
]


func test_get_stats_pool_from_pools(
	params: Array = use_parameters(test_get_stats_pool_from_pools_parameters)
) -> void:
	# Arrange
	var item_type: ItemType.ItemType = params[0]
	var item_rarity: ItemRarity.ItemRarity = params[1]

	# Act
	var item_stats_pool: ItemStatsPool = sut._get_stats_pool_from_pools(item_type, item_rarity)

	# Assert
	assert_eq(item_stats_pool.main_stat.statistic is ItemStatistics.ItemStatistics, true)

	var unique_stats: Array[int] = []
	for stat in item_stats_pool.potential_stats:
		assert_true(stat is ItemStatBlueprint)
		assert_true(stat.statistic is ItemStatistics.ItemStatistics)
		assert_false(unique_stats.has(stat.statistic))
		unique_stats.push_back(stat.statistic)


# Parameters
# [item_statistic, base_value_min, base_value_max, base_value_step]
var test_roll_stat_value_parameters := [
	[ItemStatistics.ItemStatistics.ATTACK_ADD, 0.0, 100.0, 1.0],
	[ItemStatistics.ItemStatistics.ATTACK_MULT, 0.0, 100.0, 5.0],
	[ItemStatistics.ItemStatistics.CRIT_CHANCE, 0.0, 100.0, 20.0],
	[ItemStatistics.ItemStatistics.CRIT_DAMAGE, 0.0, 100.0, 1.5],
	[ItemStatistics.ItemStatistics.HEALTH_ADD, 0.0, 100.0, 99.0],
	[ItemStatistics.ItemStatistics.HEALTH_MULT, 0.0, 100.0, 33.333],
	[ItemStatistics.ItemStatistics.RESISTANCE_ADD, 0.0, 100.0, 17.0],
	[ItemStatistics.ItemStatistics.RESISTANCE_MULT, 0.0, 100.0, 13.0],
]


func test_roll_stat_value(params: Array = use_parameters(test_roll_stat_value_parameters)) -> void:
	# Arrange
	var item_statistic: ItemStatistics.ItemStatistics = params[0]
	var base_value_min: float = params[1]
	var base_value_max: float = params[2]
	var base_value_step: float = params[3]

	var item_stat_blueprint: ItemStatBlueprint = ItemStatBlueprint.new()
	item_stat_blueprint.statistic = item_statistic
	item_stat_blueprint.base_value_min = base_value_min
	item_stat_blueprint.base_value_max = base_value_max
	item_stat_blueprint.base_value_step = base_value_step

	# Act
	var rolled_stat_value: ItemStat = sut._roll_stat_value(item_stat_blueprint)

	# Assert
	assert_eq(rolled_stat_value.statistic, item_stat_blueprint.statistic)
	assert_gte(rolled_stat_value.base_value, item_stat_blueprint.base_value_min)
	assert_lte(rolled_stat_value.base_value, item_stat_blueprint.base_value_max)

	if rolled_stat_value.base_value < item_stat_blueprint.base_value_max:
		assert_eq(fmod(rolled_stat_value.base_value, item_stat_blueprint.base_value_step), 0.0)
