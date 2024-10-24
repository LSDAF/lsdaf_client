class_name InventoryService

signal on_inventory_update


static func add_item(item: Item) -> void:
	Data.inventory.items.push_back(item)

	on_inventory_update.emit()


static func delete_item_at_index(item_index: int) -> void:
	var items := Data.inventory.items
	if item_index < 0 or item_index >= len(items):
		return

	items.pop_at(item_index)

	on_inventory_update.emit()


static func equip_item_at_index(item_index: int) -> void:
	var items := Data.inventory.items
	if item_index < 0 or item_index >= len(items):
		return

	var item_type := items[item_index].type

	for index in len(items):
		if items[index].type != item_type:
			continue

		items[index].is_equipped = index == item_index

	on_inventory_update.emit()


static func get_items() -> Array[Item]:
	return Data.inventory.items


static func get_equipped_items_index() -> Array[int]:
	var items := Data.inventory.items
	var equipped_items_index: Array[int] = []

	for item_index in len(items):
		if items[item_index].is_equipped:
			equipped_items_index.push_back(item_index)

	return equipped_items_index


static func get_item_at_index(item_index: int) -> Item:
	var items := Data.inventory.items
	if item_index < 0 or item_index >= len(items):
		return null

	return items[item_index]


static func level_up_item_at_index(item_index: int) -> void:
	var items := Data.inventory.items
	if item_index < 0 or item_index >= len(items):
		return

	items[item_index].level += 1

	on_inventory_update.emit()


static func unequip_item_at_index(item_index: int) -> void:
	var items := Data.inventory.items
	if item_index < 0 or item_index >= len(items):
		return

	items[item_index].is_equipped = false

	on_inventory_update.emit()
