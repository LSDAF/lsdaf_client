class_name LootService

var _inventory_service: InventoryService
var _items_service: ItemsService
var _random_number_generator_service: RandomNumberGeneratorService
var _difficulty_store: DifficultyStore


func _init(
	inventory_service: InventoryService,
	items_service: ItemsService,
	random_number_generator_service: RandomNumberGeneratorService,
	difficulty_store: DifficultyStore
) -> void:
	_inventory_service = inventory_service
	_items_service = items_service
	_random_number_generator_service = random_number_generator_service
	_difficulty_store = difficulty_store


# INFO: This is a temporary solution during dev, do not test it
func loot_random_item() -> void:
	var new_item := _items_service.create_random_item()
	_inventory_service.add_item(new_item)


func try_loot_item() -> void:
	var difficulty := _difficulty_store.current_difficulty
	var rarity := _get_rarity_for_difficulty(difficulty)
	var type := _get_type_for_difficulty(difficulty)
	var drop_rate := _get_drop_rate_for_difficulty(difficulty)

	var roll := _random_number_generator_service.randf()
	if roll > drop_rate:
		return

	var new_item := _items_service.create_item(type, rarity)
	_inventory_service.add_item(new_item)


# NOTE: Not yet implemented, not tested
func _get_rarity_for_difficulty(_difficulty: int) -> ItemRarity.ItemRarity:
	return ItemRarity.ItemRarity.values().pick_random()


# NOTE: Not yet implemented, not tested
func _get_type_for_difficulty(_difficulty: int) -> ItemType.ItemType:
	return ItemType.ItemType.values().pick_random()


func _get_drop_rate_for_difficulty(difficulty: int) -> float:
	return 1.0 / difficulty
