class_name InventoryService

var _inventory_data: InventoryData


func _init(inventory_data: InventoryData) -> void:
	_inventory_data = inventory_data


func add_item(item: Item) -> void:
	_inventory_data.items.push_back(item)

	EventBus.inventory_update.emit()


func delete_item_at_index(item_index: int) -> void:
	var items := _inventory_data.items
	if item_index < 0 or item_index >= len(items):
		return

	items.pop_at(item_index)

	EventBus.inventory_update.emit()


func equip_item_at_index(item_index: int) -> void:
	var items := _inventory_data.items
	if item_index < 0 or item_index >= len(items):
		return

	var item_type := items[item_index].type

	for index in len(items):
		if items[index].type != item_type:
			continue

		items[index].is_equipped = index == item_index

	EventBus.inventory_update.emit()


func get_items() -> Array[Item]:
	return _inventory_data.items


func get_equipped_items_index() -> Array[int]:
	var items := _inventory_data.items
	var equipped_items_index: Array[int] = []

	for item_index in len(items):
		if items[item_index].is_equipped:
			equipped_items_index.push_back(item_index)

	return equipped_items_index


func get_item_at_index(item_index: int) -> Item:
	var items := _inventory_data.items
	if item_index < 0 or item_index >= len(items):
		return null

	return items[item_index]


func level_up_item_at_index(item_index: int) -> void:
	var items := _inventory_data.items
	if item_index < 0 or item_index >= len(items):
		return

	items[item_index].level += 1

	EventBus.inventory_update.emit()


func set_inventory_from_fetch_inventory_dto(fetch_inventory_dto: FetchInventoryDto) -> void:
	_inventory_data.items = []

	for inventory_item_dto in fetch_inventory_dto.items:
		var item := Item.new()
		item.main_stat = inventory_item_dto.main_stat
		item.additional_stats = inventory_item_dto.additional_stats
		item.rarity = inventory_item_dto.rarity
		item.level = inventory_item_dto.level
		item.type = inventory_item_dto.type
		item.is_equipped = inventory_item_dto.is_equipped
		_inventory_data.items.append(item)


func unequip_item_at_index(item_index: int) -> void:
	var items := _inventory_data.items
	if item_index < 0 or item_index >= len(items):
		return

	items[item_index].is_equipped = false

	EventBus.inventory_update.emit()
