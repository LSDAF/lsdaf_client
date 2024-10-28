# gdlint: disable=class-definitions-order

extends GutTest

var sut: LootService

var inventory_data := preload("res://src/data/inventory/inventory_data.gd")
var difficulty_service := preload("res://src/services/difficulty/difficulty_service.gd")
var inventory_service := preload("res://src/services/inventory/inventory_service.gd")
var items_service := preload("res://src/services/items/items_service.gd")
var random_number_generator_service := preload(
	"res://src/services/random_number_generator/random_number_generator_service.gd"
)

var inventory_data_partial_double: Variant
var difficulty_service_partial_double: Variant
var inventory_service_partial_double: Variant
var items_service_partial_double: Variant
var random_number_generator_service_partial_double: Variant


func before_each() -> void:
	inventory_data_partial_double = partial_double(inventory_data).new()
	difficulty_service_partial_double = partial_double(difficulty_service).new()
	inventory_service_partial_double = partial_double(inventory_service).new(
		inventory_data_partial_double
	)
	items_service_partial_double = partial_double(items_service).new()
	random_number_generator_service_partial_double = (
		partial_double(random_number_generator_service).new()
	)

	sut = preload("res://src/services/loot/loot_service.gd").new(
		difficulty_service_partial_double,
		inventory_service_partial_double,
		items_service_partial_double,
		random_number_generator_service_partial_double
	)


func test_try_loot_item() -> void:
	# Arrange
	stub(difficulty_service_partial_double, "get_current_difficulty").to_return(1.0)
	stub(random_number_generator_service_partial_double, "randf").to_return(0.0)

	var new_item := Item.new()

	stub(items_service_partial_double, "create_item").to_return(new_item)

	# Act
	sut.try_loot_item()

	# Assert
	assert_called(inventory_service_partial_double, "add_item", [new_item])


# Parameters
# [difficulty]
var test_get_rarity_and_type_for_difficulty_parameters := [
	[1.0],
	[1.5],
	[10.0],
	[100.0],
	[1000.0],
	[1000000.0],
]


func test_not_yet_implemented_get_rarity_and_type_for_difficulty(
	params: Array = use_parameters(test_get_rarity_and_type_for_difficulty_parameters)
) -> void:
	# Arrange
	var difficulty: float = params[0]

	# Act
	var rarity: ItemRarity.ItemRarity = sut._get_rarity_for_difficulty(difficulty)
	var type: ItemType.ItemType = sut._get_type_for_difficulty(difficulty)

	# Assert
	assert_true(rarity is ItemRarity.ItemRarity)
	assert_true(type is ItemType.ItemType)
