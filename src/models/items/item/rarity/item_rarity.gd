class_name ItemRarity

enum ItemRarity {
	NORMAL,
}


static func value_of(string: String) -> ItemRarity.ItemRarity:
	match string:
		"normal":
			return ItemRarity.ItemRarity.NORMAL
		_:
			push_error("Invalid item rarity, defaulting to normal")
			return ItemRarity.ItemRarity.NORMAL
