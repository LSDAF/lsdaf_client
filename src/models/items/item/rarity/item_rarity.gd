class_name ItemRarity

enum ItemRarity {
	NORMAL,
	RARE,
	MAGIC,
	EPIC,
	LEGENDARY,
	MYTHIC,
}


static func _prettify_rarity(item_rarity: ItemRarity.ItemRarity) -> String:
	var prettified_rarity := ""

	match item_rarity:
		ItemRarity.ItemRarity.NORMAL:
			prettified_rarity = "Normal"
		ItemRarity.ItemRarity.RARE:
			prettified_rarity = "Rare"
		ItemRarity.ItemRarity.MAGIC:
			prettified_rarity = "Magic"
		ItemRarity.ItemRarity.EPIC:
			prettified_rarity = "Epic"
		ItemRarity.ItemRarity.LEGENDARY:
			prettified_rarity = "Legendary"
		ItemRarity.ItemRarity.MYTHIC:
			prettified_rarity = "Mythic"
		_:
			prettified_rarity = "?NO_RARITY"

	return prettified_rarity
