extends Node

signal on_inventory_update

var items: Array[Item] = []


func get_item_at_index(item_index: int) -> Item:
	if item_index < 0 or item_index >= len(items):
		return null

	return items[item_index]


func level_up_item_at_index(item_index: int) -> void:
	if item_index < 0 or item_index >= len(items):
		return

	items[item_index].level += 1

	on_inventory_update.emit()


func add_item(item: Item) -> void:
	items.push_back(item)

	on_inventory_update.emit()
