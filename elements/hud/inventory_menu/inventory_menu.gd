extends Control

@export var item_scene: PackedScene
var _current_item_scenes: Array[InventoryItem]

var _selected_item_index: int = -1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Inventory.on_inventory_update.connect(update_inventory)
	%ItemDetailsMenu.on_salvage_item.connect(_on_salvage_item)

	_open_details_for_item(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	queue_free()


func _on_give_random_button_pressed() -> void:
	Loot.loot_random_item()
	update_inventory()


func _on_salvage_item(item_index: int) -> void:
	_open_details_for_item(0)


func _open_details_for_item(item_index: int) -> void:
	_selected_item_index = item_index
	update_inventory()


func get_inventory_items_scenes() -> Array[InventoryItem]:
	var inventory_items: Array[InventoryItem] = []

	for item_index in len(Inventory.items):
		var new_item_scene: InventoryItem = item_scene.instantiate().with_data(item_index)

		new_item_scene.on_item_selected.connect(_open_details_for_item)
		new_item_scene.is_selected = item_index == _selected_item_index

		inventory_items.push_back(new_item_scene)

	return inventory_items


func update_inventory() -> void:
	for scene in _current_item_scenes:
		scene.queue_free()

	_current_item_scenes = get_inventory_items_scenes()

	for scene in _current_item_scenes:
		%InventoryGridContainer.add_child(scene)

	%ItemDetailsMenu.open_for_item(_selected_item_index)
