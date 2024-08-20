extends Control

@export var item_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	queue_free()

func fetch_inventory_items_scenes() -> Array[InventoryItem]:
	var inventory_items: Array[InventoryItem] = []
	
	for item in Inventory.items:
		var new_item_scene := item_scene.instantiate()
		inventory_items.push_back(new_item_scene)

	return inventory_items
	

func _on_give_random_button_pressed() -> void:
	# TODO
	pass # Replace with function body.
