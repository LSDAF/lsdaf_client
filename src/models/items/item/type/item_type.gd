class_name ItemType

enum ItemType {
	BOOTS,
	CHESTPLATE,
	GLOVES,
	HELMET,
	SHIELD,
	SWORD,
}


static func value_of(string: String) -> ItemType.ItemType:
	match string:
		"boots":
			return ItemType.ItemType.BOOTS
		"chestplate":
			return ItemType.ItemType.CHESTPLATE
		"gloves":
			return ItemType.ItemType.GLOVES
		"helmet":
			return ItemType.ItemType.HELMET
		"shield":
			return ItemType.ItemType.SHIELD
		"sword":
			return ItemType.ItemType.SWORD
		_:
			push_error("Invalid item type, defaulting to boots")
			return ItemType.ItemType.BOOTS
