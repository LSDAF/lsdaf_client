extends Node

signal on_inventory_update

var items: Array[Item] = []

func add_item(item: Item) -> void:
	items.push_back(item)

	on_inventory_update.emit()


func delete_item_at_index(item_index: int) -> void:
	if item_index < 0 or item_index >= len(items):
		return

	items.pop_at(item_index)

	on_inventory_update.emit()


func equip_item_at_index(item_index: int) -> void:
	if item_index < 0 or item_index >= len(items):
		return

	var item_type := items[item_index].type

	for index in len(items):
		if (items[index].type != item_type):
			continue

		print("Cur Index: {0} | Eq. Index: {1} | Type: {2}".format([index, item_index, item_type]))
		items[index].is_equipped = index == item_index

	on_inventory_update.emit()

func get_item_at_index(item_index: int) -> Item:
	if item_index < 0 or item_index >= len(items):
		return null

	return items[item_index]


func level_up_item_at_index(item_index: int) -> void:
	if item_index < 0 or item_index >= len(items):
		return

	items[item_index].level += 1

	on_inventory_update.emit()

func unequip_item_at_index(item_index: int) -> void:
	if item_index < 0 or item_index >= len(items):
		return

	items[item_index].is_equipped = false

	on_inventory_update.emit()
