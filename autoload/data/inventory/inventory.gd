extends Node

class_name Inventory

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
		if items[index].type != item_type:
			continue

		items[index].is_equipped = index == item_index

	on_inventory_update.emit()


func get_equipped_items_index() -> Array[int]:
	var equipped_items_index: Array[int] = []

	for item_index in len(items):
		if items[item_index].is_equipped:
			equipped_items_index.push_back(item_index)

	return equipped_items_index


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
