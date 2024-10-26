class_name LootService


# INFO: This is a temporary solution during dev, do not test it
func loot_random_item() -> void:
	var new_item := Services.items.create_random_item()
	Services.inventory.add_item(new_item)


func try_loot_item() -> void:
	var difficulty := Services.difficulty.get_current_difficulty()
	var rarity := _get_rarity_for_difficulty(difficulty)
	var type := _get_type_for_difficulty(difficulty)
	var drop_rate := _get_drop_rate_for_difficulty(difficulty)

	var roll := randf()
	if roll > drop_rate:
		return

	var new_item := Services.items.create_item(type, rarity)
	Services.inventory.add_item(new_item)


func _get_rarity_for_difficulty(difficulty: int) -> ItemRarity.ItemRarity:
	return ItemRarity.ItemRarity.values().pick_random()


func _get_type_for_difficulty(difficulty: int) -> ItemType.ItemType:
	return ItemType.ItemType.values().pick_random()


func _get_drop_rate_for_difficulty(difficulty: int) -> float:
	return 1.0 / difficulty
