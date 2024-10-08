extends Node

class_name Loot


func loot_random_item() -> void:
	var new_item := Services.items_service.create_random_item()
	Data.inventory.add_item(new_item)


func try_loot_item() -> void:
	var difficulty := Data.difficulty.get_current_difficulty()
	var rarity := _get_rarity_for_difficulty(difficulty)
	var type := _get_type_for_difficulty(difficulty)
	var drop_rate := _get_drop_rate_for_difficulty(difficulty)

	var roll := randf()
	if roll > drop_rate:
		return

	var new_item := Services.items_service.create_item(type, rarity)
	Data.inventory.add_item(new_item)


func _get_rarity_for_difficulty(difficulty: int) -> ItemRarity.ItemRarity:
	return ItemRarity.ItemRarity.values().pick_random()


func _get_type_for_difficulty(difficulty: int) -> ItemType.ItemType:
	return ItemType.ItemType.values().pick_random()


func _get_drop_rate_for_difficulty(difficulty: int) -> float:
	return 1.0 / difficulty
