extends GutTest

const CharacteristicsStoreClass = preload(
	"res://src/store/stores/characteristics/characteristics_store.gd"
)

var sut: PlayerStatsService
var inventory_service := preload("res://src/services/inventory/inventory_service.gd")
var characteristics_store_double: CharacteristicsStoreClass
var inventory_service_partial_double: Variant


func before_each() -> void:
	characteristics_store_double = CharacteristicsStoreClass.new()
	inventory_service_partial_double = partial_double(inventory_service).new()

	Stores.reset()
	await (
		Stores
		. replace_stores_with_doubles(
			{
				&"characteristics": characteristics_store_double,
			}
		)
	)

	sut = preload("res://src/services/player_stats/player_stats_service.gd").new(
		inventory_service_partial_double
	)
	add_child_autofree(sut)
	await get_tree().process_frame


##### Attack #####
func test_get_attack_multiplier() -> void:
	# Arrange
	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.type = ItemType.ItemType.SWORD
	item_0.rarity = ItemRarity.ItemRarity.NORMAL
	item_0.level = 1
	item_0.main_stat = ItemStat.new()
	item_0.main_stat.statistic = ItemStatistics.ItemStatistics.ATTACK_MULT
	item_0.main_stat.base_value = 20.0

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.type = ItemType.ItemType.GLOVES
	item_1.rarity = ItemRarity.ItemRarity.NORMAL
	item_1.level = 2
	item_1.main_stat = ItemStat.new()
	item_1.additional_stats = [ItemStat.new()]
	item_1.additional_stats[0].statistic = ItemStatistics.ItemStatistics.ATTACK_MULT
	item_1.additional_stats[0].base_value = 40.0

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.type = ItemType.ItemType.SHIELD
	item_2.rarity = ItemRarity.ItemRarity.NORMAL
	item_2.level = 3
	item_2.main_stat = ItemStat.new()
	item_2.main_stat.statistic = ItemStatistics.ItemStatistics.HEALTH_MULT
	item_2.main_stat.base_value = 69.0

	stub(inventory_service_partial_double, "get_equipped_items_client_id").to_return(
		["item_0", "item_1", "item_2"]
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_0")
		. to_return(item_0)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_1")
		. to_return(item_1)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_2")
		. to_return(item_2)
	)

	# Act
	var attack_multiplier: float = sut._get_attack_multiplier()

	# Assert
	assert_eq(attack_multiplier, 2.0)


func test_get_attack_value() -> void:
	# Arrange
	characteristics_store_double.set_attack_level(1000)

	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.client_id = "item_0"
	item_0.type = ItemType.ItemType.SWORD
	item_0.rarity = ItemRarity.ItemRarity.NORMAL
	item_0.level = 1
	item_0.main_stat = ItemStat.new()
	item_0.main_stat.statistic = ItemStatistics.ItemStatistics.ATTACK_ADD
	item_0.main_stat.base_value = 10.0

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.client_id = "item_1"
	item_1.type = ItemType.ItemType.GLOVES
	item_1.rarity = ItemRarity.ItemRarity.NORMAL
	item_1.level = 2
	item_1.main_stat = ItemStat.new()
	item_1.additional_stats = [ItemStat.new()]
	item_1.additional_stats[0].statistic = ItemStatistics.ItemStatistics.ATTACK_ADD
	item_1.additional_stats[0].base_value = 20.0

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.client_id = "item_2"
	item_2.type = ItemType.ItemType.SHIELD
	item_2.rarity = ItemRarity.ItemRarity.NORMAL
	item_2.level = 3
	item_2.main_stat = ItemStat.new()
	item_2.main_stat.statistic = ItemStatistics.ItemStatistics.HEALTH_ADD
	item_2.main_stat.base_value = 69.0

	stub(inventory_service_partial_double, "get_equipped_items_client_id").to_return(
		["item_0", "item_1", "item_2"]
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_0")
		. to_return(item_0)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_1")
		. to_return(item_1)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_2")
		. to_return(item_2)
	)

	# Act
	var attack_value: float = await sut._get_attack_value()

	# Assert
	assert_eq(attack_value, 2050.0)


func test_get_attack() -> void:
	# Arrange
	characteristics_store_double.set_attack_level(250)

	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.type = ItemType.ItemType.SWORD
	item_0.rarity = ItemRarity.ItemRarity.NORMAL
	item_0.level = 1
	item_0.main_stat = ItemStat.new()
	item_0.main_stat.statistic = ItemStatistics.ItemStatistics.ATTACK_ADD
	item_0.main_stat.base_value = 5.0
	item_0.additional_stats = [ItemStat.new()]
	item_0.additional_stats[0].statistic = ItemStatistics.ItemStatistics.ATTACK_MULT
	item_0.additional_stats[0].base_value = 10.0

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.type = ItemType.ItemType.GLOVES
	item_1.rarity = ItemRarity.ItemRarity.NORMAL
	item_1.level = 2
	item_1.main_stat = ItemStat.new()
	item_1.main_stat.statistic = ItemStatistics.ItemStatistics.ATTACK_MULT
	item_1.main_stat.base_value = 50.0
	item_1.additional_stats = [ItemStat.new()]
	item_1.additional_stats[0].statistic = ItemStatistics.ItemStatistics.ATTACK_ADD
	item_1.additional_stats[0].base_value = 25.0

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.type = ItemType.ItemType.SHIELD
	item_2.rarity = ItemRarity.ItemRarity.NORMAL
	item_2.level = 3
	item_2.main_stat = ItemStat.new()
	item_2.main_stat.statistic = ItemStatistics.ItemStatistics.HEALTH_ADD
	item_2.main_stat.base_value = 69.0
	item_2.additional_stats = [ItemStat.new(), ItemStat.new()]
	item_2.additional_stats[0].statistic = ItemStatistics.ItemStatistics.ATTACK_ADD
	item_2.additional_stats[0].base_value = 100.0
	item_2.additional_stats[1].statistic = ItemStatistics.ItemStatistics.ATTACK_MULT
	item_2.additional_stats[1].base_value = 200.0

	stub(inventory_service_partial_double, "get_equipped_items_client_id").to_return(
		["item_0", "item_1", "item_2"]
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_0")
		. to_return(item_0)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_1")
		. to_return(item_1)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_2")
		. to_return(item_2)
	)

	# Act
	var attack: PlayerStat = await sut.get_attack()

	# Assert
	assert_eq(attack.value, 855.0)
	assert_eq(attack.multiplier, 8.1)


#####   Crit. Chance   #####
func test_get_crit_chance_value() -> void:
	# Arrange
	characteristics_store_double.set_characteristics_level(0, 10, 0, 0, 0)

	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.type = ItemType.ItemType.SWORD
	item_0.rarity = ItemRarity.ItemRarity.NORMAL
	item_0.level = 1
	item_0.main_stat = ItemStat.new()
	item_0.main_stat.statistic = ItemStatistics.ItemStatistics.CRIT_CHANCE
	item_0.main_stat.base_value = 5.0

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.type = ItemType.ItemType.GLOVES
	item_1.rarity = ItemRarity.ItemRarity.NORMAL
	item_1.level = 2
	item_1.main_stat = ItemStat.new()
	item_1.additional_stats = [ItemStat.new()]
	item_1.additional_stats[0].statistic = ItemStatistics.ItemStatistics.CRIT_CHANCE
	item_1.additional_stats[0].base_value = 7.5

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.type = ItemType.ItemType.SHIELD
	item_2.rarity = ItemRarity.ItemRarity.NORMAL
	item_2.level = 3
	item_2.main_stat = ItemStat.new()
	item_2.main_stat.statistic = ItemStatistics.ItemStatistics.HEALTH_ADD
	item_2.main_stat.base_value = 69.0

	stub(inventory_service_partial_double, "get_equipped_items_client_id").to_return(
		["item_0", "item_1", "item_2"]
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_0")
		. to_return(item_0)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_1")
		. to_return(item_1)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_2")
		. to_return(item_2)
	)

	# Act
	var crit_chance_value: float = await sut._get_crit_chance_value()

	# Assert
	assert_eq(crit_chance_value, 40.0)


func test_get_crit_chance() -> void:
	# Arrange
	characteristics_store_double.set_crit_chance_level(25)

	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.type = ItemType.ItemType.SWORD
	item_0.rarity = ItemRarity.ItemRarity.NORMAL
	item_0.level = 1
	item_0.main_stat = ItemStat.new()
	item_0.main_stat.statistic = ItemStatistics.ItemStatistics.CRIT_CHANCE
	item_0.main_stat.base_value = 1.0
	item_0.additional_stats = [ItemStat.new()]
	item_0.additional_stats[0].statistic = ItemStatistics.ItemStatistics.CRIT_DAMAGE
	item_0.additional_stats[0].base_value = 5.0

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.type = ItemType.ItemType.GLOVES
	item_1.rarity = ItemRarity.ItemRarity.NORMAL
	item_1.level = 2
	item_1.main_stat = ItemStat.new()
	item_1.main_stat.statistic = ItemStatistics.ItemStatistics.CRIT_DAMAGE
	item_1.main_stat.base_value = 50.0
	item_1.additional_stats = [ItemStat.new()]
	item_1.additional_stats[0].statistic = ItemStatistics.ItemStatistics.CRIT_CHANCE
	item_1.additional_stats[0].base_value = 2.0

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.type = ItemType.ItemType.SHIELD
	item_2.rarity = ItemRarity.ItemRarity.NORMAL
	item_2.level = 3
	item_2.main_stat = ItemStat.new()
	item_2.main_stat.statistic = ItemStatistics.ItemStatistics.HEALTH_ADD
	item_2.main_stat.base_value = 69.0
	item_2.additional_stats = [ItemStat.new(), ItemStat.new()]
	item_2.additional_stats[0].statistic = ItemStatistics.ItemStatistics.CRIT_CHANCE
	item_2.additional_stats[0].base_value = 5.0
	item_2.additional_stats[1].statistic = ItemStatistics.ItemStatistics.CRIT_DAMAGE
	item_2.additional_stats[1].base_value = 120.0

	stub(inventory_service_partial_double, "get_equipped_items_client_id").to_return(
		["item_0", "item_1", "item_2"]
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_0")
		. to_return(item_0)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_1")
		. to_return(item_1)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_2")
		. to_return(item_2)
	)

	# Act
	var crit_chance: PlayerStat = await sut.get_crit_chance()

	# Assert
	assert_eq(crit_chance.value, 70.0)
	assert_eq(crit_chance.multiplier, 1.0)


#####   Crit. Damage   #####
func test_get_crit_damage_value() -> void:
	# Arrange
	characteristics_store_double.set_characteristics_level(0, 0, 200, 0, 0)

	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.type = ItemType.ItemType.SWORD
	item_0.rarity = ItemRarity.ItemRarity.NORMAL
	item_0.level = 1
	item_0.main_stat = ItemStat.new()
	item_0.main_stat.statistic = ItemStatistics.ItemStatistics.CRIT_DAMAGE
	item_0.main_stat.base_value = 15.0

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.type = ItemType.ItemType.GLOVES
	item_1.rarity = ItemRarity.ItemRarity.NORMAL
	item_1.level = 2
	item_1.main_stat = ItemStat.new()
	item_1.additional_stats = [ItemStat.new()]
	item_1.additional_stats[0].statistic = ItemStatistics.ItemStatistics.CRIT_DAMAGE
	item_1.additional_stats[0].base_value = 35.0

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.type = ItemType.ItemType.SHIELD
	item_2.rarity = ItemRarity.ItemRarity.NORMAL
	item_2.level = 3
	item_2.main_stat = ItemStat.new()
	item_2.main_stat.statistic = ItemStatistics.ItemStatistics.HEALTH_ADD
	item_2.main_stat.base_value = 69.0

	stub(inventory_service_partial_double, "get_equipped_items_client_id").to_return(
		["item_0", "item_1", "item_2"]
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_0")
		. to_return(item_0)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_1")
		. to_return(item_1)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_2")
		. to_return(item_2)
	)

	# Act
	var crit_damage_value: float = await sut._get_crit_damage_value()

	# Assert
	assert_eq(crit_damage_value, 485.0)


func test_get_crit_damage() -> void:
	# Arrange
	characteristics_store_double.set_crit_damage_level(100)

	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.type = ItemType.ItemType.SWORD
	item_0.rarity = ItemRarity.ItemRarity.NORMAL
	item_0.level = 1
	item_0.main_stat = ItemStat.new()
	item_0.main_stat.statistic = ItemStatistics.ItemStatistics.CRIT_DAMAGE
	item_0.main_stat.base_value = 25.0
	item_0.additional_stats = [ItemStat.new()]
	item_0.additional_stats[0].statistic = ItemStatistics.ItemStatistics.CRIT_CHANCE
	item_0.additional_stats[0].base_value = 1.0

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.type = ItemType.ItemType.GLOVES
	item_1.rarity = ItemRarity.ItemRarity.NORMAL
	item_1.level = 2
	item_1.main_stat = ItemStat.new()
	item_1.main_stat.statistic = ItemStatistics.ItemStatistics.CRIT_CHANCE
	item_1.main_stat.base_value = 150.0
	item_1.additional_stats = [ItemStat.new()]
	item_1.additional_stats[0].statistic = ItemStatistics.ItemStatistics.CRIT_DAMAGE
	item_1.additional_stats[0].base_value = 75.0

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.type = ItemType.ItemType.SHIELD
	item_2.rarity = ItemRarity.ItemRarity.NORMAL
	item_2.level = 3
	item_2.main_stat = ItemStat.new()
	item_2.main_stat.statistic = ItemStatistics.ItemStatistics.HEALTH_ADD
	item_2.main_stat.base_value = 69.0
	item_2.additional_stats = [ItemStat.new(), ItemStat.new()]
	item_2.additional_stats[0].statistic = ItemStatistics.ItemStatistics.CRIT_DAMAGE
	item_2.additional_stats[0].base_value = 25.0
	item_2.additional_stats[1].statistic = ItemStatistics.ItemStatistics.CRIT_CHANCE
	item_2.additional_stats[1].base_value = 15.0

	stub(inventory_service_partial_double, "get_equipped_items_client_id").to_return(
		["item_0", "item_1", "item_2"]
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_0")
		. to_return(item_0)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_1")
		. to_return(item_1)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_2")
		. to_return(item_2)
	)

	# Act
	var crit_damage: PlayerStat = await sut.get_crit_damage()

	# Assert
	assert_eq(crit_damage.value, 450.0)
	assert_eq(crit_damage.multiplier, 1.0)


#####   Health   #####
func test_get_health_multiplier() -> void:
	# Arrange
	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.type = ItemType.ItemType.SWORD
	item_0.rarity = ItemRarity.ItemRarity.NORMAL
	item_0.level = 1
	item_0.main_stat = ItemStat.new()
	item_0.main_stat.statistic = ItemStatistics.ItemStatistics.HEALTH_MULT
	item_0.main_stat.base_value = 5.0

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.type = ItemType.ItemType.GLOVES
	item_1.rarity = ItemRarity.ItemRarity.NORMAL
	item_1.level = 2
	item_1.main_stat = ItemStat.new()
	item_1.additional_stats = [ItemStat.new()]
	item_1.additional_stats[0].statistic = ItemStatistics.ItemStatistics.HEALTH_MULT
	item_1.additional_stats[0].base_value = 30.0

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.type = ItemType.ItemType.SHIELD
	item_2.rarity = ItemRarity.ItemRarity.NORMAL
	item_2.level = 3
	item_2.main_stat = ItemStat.new()
	item_2.main_stat.statistic = ItemStatistics.ItemStatistics.ATTACK_ADD
	item_2.main_stat.base_value = 69.0

	stub(inventory_service_partial_double, "get_equipped_items_client_id").to_return(
		["item_0", "item_1", "item_2"]
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_0")
		. to_return(item_0)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_1")
		. to_return(item_1)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_2")
		. to_return(item_2)
	)

	# Act
	var health_multiplier: float = sut._get_health_multiplier()

	# Assert
	assert_eq(health_multiplier, 1.65)


func test_get_health_value() -> void:
	# Arrange
	characteristics_store_double.set_health_level(100)

	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.type = ItemType.ItemType.SWORD
	item_0.rarity = ItemRarity.ItemRarity.NORMAL
	item_0.level = 1
	item_0.main_stat = ItemStat.new()
	item_0.main_stat.statistic = ItemStatistics.ItemStatistics.HEALTH_ADD
	item_0.main_stat.base_value = 15.0

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.type = ItemType.ItemType.GLOVES
	item_1.rarity = ItemRarity.ItemRarity.NORMAL
	item_1.level = 2
	item_1.main_stat = ItemStat.new()
	item_1.additional_stats = [ItemStat.new()]
	item_1.additional_stats[0].statistic = ItemStatistics.ItemStatistics.HEALTH_ADD
	item_1.additional_stats[0].base_value = 25.0

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.type = ItemType.ItemType.SHIELD
	item_2.rarity = ItemRarity.ItemRarity.NORMAL
	item_2.level = 3
	item_2.main_stat = ItemStat.new()
	item_2.main_stat.statistic = ItemStatistics.ItemStatistics.ATTACK_ADD
	item_2.main_stat.base_value = 69.0

	stub(inventory_service_partial_double, "get_equipped_items_client_id").to_return(
		["item_0", "item_1", "item_2"]
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_0")
		. to_return(item_0)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_1")
		. to_return(item_1)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_2")
		. to_return(item_2)
	)

	# Act
	var health_value: float = await sut._get_health_value()

	# Assert
	assert_eq(health_value, 265.0)


func test_get_health() -> void:
	# Arrange
	characteristics_store_double.set_characteristics_level(0, 0, 0, 135, 0)

	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.type = ItemType.ItemType.SWORD
	item_0.rarity = ItemRarity.ItemRarity.NORMAL
	item_0.level = 1
	item_0.main_stat = ItemStat.new()
	item_0.main_stat.statistic = ItemStatistics.ItemStatistics.HEALTH_ADD
	item_0.main_stat.base_value = 15.0
	item_0.additional_stats = [ItemStat.new()]
	item_0.additional_stats[0].statistic = ItemStatistics.ItemStatistics.HEALTH_MULT
	item_0.additional_stats[0].base_value = 30.0

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.type = ItemType.ItemType.GLOVES
	item_1.rarity = ItemRarity.ItemRarity.NORMAL
	item_1.level = 2
	item_1.main_stat = ItemStat.new()
	item_1.additional_stats = [ItemStat.new()]
	item_1.additional_stats[0].statistic = ItemStatistics.ItemStatistics.HEALTH_ADD
	item_1.additional_stats[0].base_value = 50.0

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.type = ItemType.ItemType.SHIELD
	item_2.rarity = ItemRarity.ItemRarity.NORMAL
	item_2.level = 3
	item_2.main_stat = ItemStat.new()
	item_2.main_stat.statistic = ItemStatistics.ItemStatistics.ATTACK_ADD
	item_2.main_stat.base_value = 69.0
	item_2.additional_stats = [ItemStat.new(), ItemStat.new()]
	item_2.additional_stats[0].statistic = ItemStatistics.ItemStatistics.HEALTH_ADD
	item_2.additional_stats[0].base_value = 25.0
	item_2.additional_stats[1].statistic = ItemStatistics.ItemStatistics.HEALTH_MULT
	item_2.additional_stats[1].base_value = 15.0

	stub(inventory_service_partial_double, "get_equipped_items_client_id").to_return(
		["item_0", "item_1", "item_2"]
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_0")
		. to_return(item_0)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_1")
		. to_return(item_1)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_2")
		. to_return(item_2)
	)

	# Act
	var health: PlayerStat = await sut.get_health()

	# Assert
	assert_eq(health.value, 460.0)
	assert_eq(health.multiplier, 1.75)


#####   Resistance   #####
func test_get_resistance_multiplier() -> void:
	# Arrange
	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.type = ItemType.ItemType.SWORD
	item_0.rarity = ItemRarity.ItemRarity.NORMAL
	item_0.level = 1
	item_0.main_stat = ItemStat.new()
	item_0.main_stat.statistic = ItemStatistics.ItemStatistics.RESISTANCE_MULT
	item_0.main_stat.base_value = 55.0

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.type = ItemType.ItemType.GLOVES
	item_1.rarity = ItemRarity.ItemRarity.NORMAL
	item_1.level = 2
	item_1.main_stat = ItemStat.new()
	item_1.additional_stats = [ItemStat.new()]
	item_1.additional_stats[0].statistic = ItemStatistics.ItemStatistics.RESISTANCE_MULT
	item_1.additional_stats[0].base_value = 35.0

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.type = ItemType.ItemType.SHIELD
	item_2.rarity = ItemRarity.ItemRarity.NORMAL
	item_2.level = 3
	item_2.main_stat = ItemStat.new()
	item_2.main_stat.statistic = ItemStatistics.ItemStatistics.ATTACK_ADD
	item_2.main_stat.base_value = 69.0

	stub(inventory_service_partial_double, "get_equipped_items_client_id").to_return(
		["item_0", "item_1", "item_2"]
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_0")
		. to_return(item_0)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_1")
		. to_return(item_1)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_2")
		. to_return(item_2)
	)

	# Act
	var resistance_multiplier: float = sut._get_resistance_multiplier()

	# Assert
	assert_eq(resistance_multiplier, 2.25)


func test_get_resistance_value() -> void:
	# Arrange
	characteristics_store_double.set_characteristics_level(0, 0, 0, 0, 150)

	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.type = ItemType.ItemType.SWORD
	item_0.rarity = ItemRarity.ItemRarity.NORMAL
	item_0.level = 1
	item_0.main_stat = ItemStat.new()
	item_0.main_stat.statistic = ItemStatistics.ItemStatistics.RESISTANCE_ADD
	item_0.main_stat.base_value = 155.0

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.type = ItemType.ItemType.GLOVES
	item_1.rarity = ItemRarity.ItemRarity.NORMAL
	item_1.level = 2
	item_1.main_stat = ItemStat.new()
	item_1.additional_stats = [ItemStat.new()]
	item_1.additional_stats[0].statistic = ItemStatistics.ItemStatistics.RESISTANCE_ADD
	item_1.additional_stats[0].base_value = 55.0

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.type = ItemType.ItemType.SHIELD
	item_2.rarity = ItemRarity.ItemRarity.NORMAL
	item_2.level = 3
	item_2.main_stat = ItemStat.new()
	item_2.main_stat.statistic = ItemStatistics.ItemStatistics.ATTACK_ADD
	item_2.main_stat.base_value = 69.0

	stub(inventory_service_partial_double, "get_equipped_items_client_id").to_return(
		["item_0", "item_1", "item_2"]
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_0")
		. to_return(item_0)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_1")
		. to_return(item_1)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_2")
		. to_return(item_2)
	)

	# Act
	var resistance_value: float = await sut._get_resistance_value()

	# Assert
	assert_eq(resistance_value, 565.0)


func test_get_resistance() -> void:
	# Arrange
	characteristics_store_double.set_resistance_level(135)

	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.type = ItemType.ItemType.SWORD
	item_0.rarity = ItemRarity.ItemRarity.NORMAL
	item_0.level = 1
	item_0.main_stat = ItemStat.new()
	item_0.main_stat.statistic = ItemStatistics.ItemStatistics.RESISTANCE_ADD
	item_0.main_stat.base_value = 10.0
	item_0.additional_stats = [ItemStat.new()]
	item_0.additional_stats[0].statistic = ItemStatistics.ItemStatistics.RESISTANCE_MULT
	item_0.additional_stats[0].base_value = 50.0

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.type = ItemType.ItemType.GLOVES
	item_1.rarity = ItemRarity.ItemRarity.NORMAL
	item_1.level = 2
	item_1.main_stat = ItemStat.new()
	item_1.additional_stats = [ItemStat.new()]
	item_1.additional_stats[0].statistic = ItemStatistics.ItemStatistics.RESISTANCE_ADD
	item_1.additional_stats[0].base_value = 150.0

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.type = ItemType.ItemType.SHIELD
	item_2.rarity = ItemRarity.ItemRarity.NORMAL
	item_2.level = 3
	item_2.main_stat = ItemStat.new()
	item_2.main_stat.statistic = ItemStatistics.ItemStatistics.ATTACK_ADD
	item_2.main_stat.base_value = 69.0
	item_2.additional_stats = [ItemStat.new(), ItemStat.new()]
	item_2.additional_stats[0].statistic = ItemStatistics.ItemStatistics.RESISTANCE_ADD
	item_2.additional_stats[0].base_value = 20.0
	item_2.additional_stats[1].statistic = ItemStatistics.ItemStatistics.RESISTANCE_MULT
	item_2.additional_stats[1].base_value = 45.0

	stub(inventory_service_partial_double, "get_equipped_items_client_id").to_return(
		["item_0", "item_1", "item_2"]
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_0")
		. to_return(item_0)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_1")
		. to_return(item_1)
	)
	(
		stub(inventory_service_partial_double, "get_item_from_client_id")
		. when_passed("item_2")
		. to_return(item_2)
	)

	# Act
	var resistance: PlayerStat = await sut.get_resistance()

	# Assert
	assert_eq(resistance.value, 640.0)
	assert_eq(resistance.multiplier, 2.85)
