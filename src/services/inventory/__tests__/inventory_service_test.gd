extends GutTest

var sut: InventoryService

var inventory_data := preload("res://src/data/inventory/inventory_data.gd")

var inventory_data_partial_double: Variant


func before_each() -> void:
	inventory_data_partial_double = partial_double(inventory_data).new()

	sut = preload("res://src/services/inventory/inventory_service.gd").new(
		inventory_data_partial_double
	)


func test_add_item() -> void:
	# Arrange
	var item := Item.new()
	item.name = "item"

	# Act
	sut.add_item(item)

	# Assert
	assert_eq(inventory_data_partial_double.items.size(), 1)
	assert_eq(inventory_data_partial_double.items[0].name, "item")
	assert_eq(inventory_data_partial_double.items[0], item)


func test_delete_item_at_index() -> void:
	# Arrange
	var item_0 := Item.new()
	item_0.name = "item_0"
	var item_1 := Item.new()
	item_1.name = "item_1"

	inventory_data_partial_double.items.push_back(item_0)
	inventory_data_partial_double.items.push_back(item_1)

	# Act
	sut.delete_item_at_index(0)

	# Assert
	assert_eq(inventory_data_partial_double.items.size(), 1)
	assert_eq(inventory_data_partial_double.items[0].name, "item_1")


func test_equip_item_at_index() -> void:
	# Arrange
	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.is_equipped = true
	item_0.type = ItemType.ItemType.SWORD

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.is_equipped = false
	item_1.type = ItemType.ItemType.SWORD

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.is_equipped = true
	item_2.type = ItemType.ItemType.SHIELD

	inventory_data_partial_double.items.push_back(item_0)
	inventory_data_partial_double.items.push_back(item_1)
	inventory_data_partial_double.items.push_back(item_2)

	# Act
	sut.equip_item_at_index(1)

	# Assert
	assert_eq(inventory_data_partial_double.items[0].is_equipped, false)
	assert_eq(inventory_data_partial_double.items[1].is_equipped, true)
	assert_eq(inventory_data_partial_double.items[2].is_equipped, true)


func test_get_items() -> void:
	# Arrange
	var item_0 := Item.new()
	item_0.name = "item_0"
	var item_1 := Item.new()
	item_1.name = "item_1"

	inventory_data_partial_double.items.push_back(item_0)
	inventory_data_partial_double.items.push_back(item_1)

	# Act
	var items: Array[Item] = sut.get_items()

	# Assert
	assert_eq(items.size(), 2)
	assert_eq(items[0].name, "item_0")
	assert_eq(items[1].name, "item_1")


func test_get_equipped_items_index() -> void:
	# Arrange
	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.is_equipped = true
	item_0.type = ItemType.ItemType.SWORD

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.is_equipped = false
	item_1.type = ItemType.ItemType.SWORD

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.is_equipped = true
	item_2.type = ItemType.ItemType.SHIELD

	inventory_data_partial_double.items.push_back(item_0)
	inventory_data_partial_double.items.push_back(item_1)
	inventory_data_partial_double.items.push_back(item_2)

	# Act
	var equipped_items_index: Array[int] = sut.get_equipped_items_index()

	# Assert
	assert_eq(equipped_items_index.size(), 2)
	assert_eq(equipped_items_index[0], 0)
	assert_eq(equipped_items_index[1], 2)


func test_get_item_at_index() -> void:
	# Arrange
	var item_0 := Item.new()
	item_0.name = "item_0"
	var item_1 := Item.new()
	item_1.name = "item_1"

	inventory_data_partial_double.items.push_back(item_0)
	inventory_data_partial_double.items.push_back(item_1)

	# Act
	var item: Item = sut.get_item_at_index(1)

	# Assert
	assert_eq(item.name, "item_1")


func test_level_up_item_at_index() -> void:
	# Arrange
	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.level = 1

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.level = 2

	inventory_data_partial_double.items.push_back(item_0)
	inventory_data_partial_double.items.push_back(item_1)

	# Act
	sut.level_up_item_at_index(1)

	# Assert
	assert_eq(inventory_data_partial_double.items[0].level, 1)
	assert_eq(inventory_data_partial_double.items[1].level, 3)


func test_set_inventory_from_fetch_inventory_dto() -> void:
	# Arrange
	var fetch_inventory_dto := (
		FetchInventoryDto
		. new(
			{
				"items":
				[
					{
						"main_stat": {"statistic": "ATTACK_ADD", "base_value": 1.0},
						"additional_stats": [{"statistic": "CRIT_DAMAGE", "base_value": 3.0}],
						"rarity": "NORMAL",
						"level": 1,
						"type": "SWORD",
						"is_equipped": false,
					},
					{
						"main_stat": {"statistic": "CRIT_CHANCE", "base_value": 2.0},
						"additional_stats": [{"statistic": "HEALTH_ADD", "base_value": 4.0}],
						"rarity": "NORMAL",
						"level": 10,
						"type": "CHESTPLATE",
						"is_equipped": true,
					}
				]
			}
		)
	)

	# Act
	sut.set_inventory_from_fetch_inventory_dto(fetch_inventory_dto)

	# Assert
	assert_eq(inventory_data_partial_double.items.size(), 2)
	assert_eq(
		inventory_data_partial_double.items[0].main_stat.statistic,
		ItemStatistics.ItemStatistics.ATTACK_ADD
	)
	assert_eq(inventory_data_partial_double.items[0].main_stat.base_value, 1.0)
	assert_eq(
		inventory_data_partial_double.items[0].additional_stats[0].statistic,
		ItemStatistics.ItemStatistics.CRIT_DAMAGE
	)
	assert_eq(inventory_data_partial_double.items[0].additional_stats[0].base_value, 3.0)
	assert_eq(inventory_data_partial_double.items[0].rarity, ItemRarity.ItemRarity.NORMAL)
	assert_eq(inventory_data_partial_double.items[0].level, 1)
	assert_eq(inventory_data_partial_double.items[0].type, ItemType.ItemType.SWORD)
	assert_eq(inventory_data_partial_double.items[0].is_equipped, false)
	assert_eq(
		inventory_data_partial_double.items[1].main_stat.statistic,
		ItemStatistics.ItemStatistics.CRIT_CHANCE
	)
	assert_eq(inventory_data_partial_double.items[1].main_stat.base_value, 2.0)
	assert_eq(
		inventory_data_partial_double.items[1].additional_stats[0].statistic,
		ItemStatistics.ItemStatistics.HEALTH_ADD
	)
	assert_eq(inventory_data_partial_double.items[1].additional_stats[0].base_value, 4.0)
	assert_eq(inventory_data_partial_double.items[1].rarity, ItemRarity.ItemRarity.NORMAL)
	assert_eq(inventory_data_partial_double.items[1].level, 10)
	assert_eq(inventory_data_partial_double.items[1].type, ItemType.ItemType.CHESTPLATE)
	assert_eq(inventory_data_partial_double.items[1].is_equipped, true)


func test_unequip_item_at_index() -> void:
	# Arrange
	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.is_equipped = true
	item_0.type = ItemType.ItemType.SWORD

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.is_equipped = false
	item_1.type = ItemType.ItemType.SWORD

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.is_equipped = true
	item_2.type = ItemType.ItemType.SHIELD

	inventory_data_partial_double.items.push_back(item_0)
	inventory_data_partial_double.items.push_back(item_1)
	inventory_data_partial_double.items.push_back(item_2)

	# Act
	sut.unequip_item_at_index(0)

	# Assert
	assert_eq(inventory_data_partial_double.items[0].is_equipped, false)
	assert_eq(inventory_data_partial_double.items[1].is_equipped, false)
	assert_eq(inventory_data_partial_double.items[2].is_equipped, true)
