extends Control

@export var item_scene: PackedScene
var _current_item_scenes: Array[InventoryItem]

var _selected_item_client_id: String = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.inventory_update.connect(update_inventory)
	%ItemDetailsMenu.on_salvage_item.connect(_on_salvage_item)
	%EquippedItems.on_item_selected.connect(_on_item_selected)

	_on_item_selected("")


func _on_close_button_pressed() -> void:
	queue_free()


func _on_give_random_button_pressed() -> void:
	Services.loot.loot_random_item()
	update_inventory()


func _on_salvage_item() -> void:
	_on_item_selected("")


func _on_item_selected(item_client_id: String) -> void:
	_selected_item_client_id = item_client_id
	update_inventory()


# https://docs.godotengine.org/en/stable/classes/class_array.html#class-array-method-sort-custom
# func is called as many times as necessary, receiving two array elements as arguments.
# The function should return true if the first element should be moved behind the second one,
# otherwise it should return false.
func _sort_inventory_custom_sort(
	inventory_item_a: InventoryItem, inventory_item_b: InventoryItem
) -> bool:
	var item_a := Services.inventory.get_item_from_client_id(inventory_item_a.item_client_id)
	var item_b := Services.inventory.get_item_from_client_id(inventory_item_b.item_client_id)

	if item_a.type != item_b.type:
		return item_a.type > item_b.type

	if item_a.rarity != item_b.rarity:
		return item_a.rarity > item_b.rarity

	if item_a.level != item_b.level:
		return item_a.level > item_b.level

	return false


# https://docs.godotengine.org/en/stable/classes/class_array.html#class-array-method-sort-custom
# func is called as many times as necessary, receiving two array elements as arguments.
# The function should return true if the first element should be moved behind the second one,
# otherwise it should return false.
func _sort_inventory_custom_sort_equipped_items(
	inventory_item_a: InventoryItem, inventory_item_b: InventoryItem
) -> bool:
	var item_a := Services.inventory.get_item_from_client_id(inventory_item_a.item_client_id)
	var item_b := Services.inventory.get_item_from_client_id(inventory_item_b.item_client_id)

	if item_a.is_equipped and not item_b.is_equipped:
		return true

	return false


func get_inventory_items_scenes() -> Array[InventoryItem]:
	var inventory_items: Array[InventoryItem] = []

	var items := Services.inventory.get_items()

	for item_index in len(items):
		var new_item_scene: InventoryItem = item_scene.instantiate().with_data(
			items[item_index].client_id
		)

		new_item_scene.on_item_selected.connect(_on_item_selected)
		new_item_scene.is_selected = new_item_scene.item_client_id == _selected_item_client_id

		inventory_items.push_back(new_item_scene)

	return inventory_items


func update_inventory() -> void:
	for scene in _current_item_scenes:
		scene.queue_free()

	_current_item_scenes = get_inventory_items_scenes()
	_current_item_scenes.sort_custom(_sort_inventory_custom_sort)
	_current_item_scenes.sort_custom(_sort_inventory_custom_sort_equipped_items)

	for scene in _current_item_scenes:
		%InventoryGridContainer.add_child(scene)

	%ItemDetailsMenu.open_for_item(_selected_item_client_id)
	%EquippedItems.update_equipped_items()
