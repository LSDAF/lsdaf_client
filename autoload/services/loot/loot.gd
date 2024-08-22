extends Node


func loot_random_item() -> void:
	var new_item := ItemsService.create_random_item()
	Inventory.add_item(new_item)


func try_loot_item() -> void:
	var difficulty := Difficulty.get_current_difficulty()
	var rarity := _get_rarity_for_difficulty(difficulty)
	var type := _get_type_for_difficulty(difficulty)
	var drop_rate := _get_drop_rate_for_difficulty(difficulty)

	print("Difficulty: {0} | Rarity: {1} | Drop Rate: {2}".format([difficulty, rarity, drop_rate]))

	var roll := randf()
	if roll > drop_rate:
		print("FAILED - Rate: {0} | Rolled: {1}".format([drop_rate, roll]))
		return

	print("LOOT ! - Rate: {0} | Rolled: {1}".format([drop_rate, roll]))
	var new_item := ItemsService.create_item(type, rarity)
	Inventory.add_item(new_item)


func _get_rarity_for_difficulty(difficulty: int) -> ItemRarity.ItemRarity:
	return ItemRarity.ItemRarity.values().pick_random()


func _get_type_for_difficulty(difficulty: int) -> ItemType.ItemType:
	return ItemType.ItemType.values().pick_random()


func _get_drop_rate_for_difficulty(difficulty: int) -> float:
	return 1.0 / difficulty
