extends Control

signal on_item_selected(item_index: int)

@export var item_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_equipped_items()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_item_selected(item_index: int) -> void:
	on_item_selected.emit(item_index)

func _remove_children(slot: Node) -> void:
	slot.get_children().reduce(func(child: Node) -> void: child.queue_free())

func _update_corresponding_slot(inventory_item: InventoryItem, item_type: ItemType.ItemType) -> void:
	_remove_children(%BootsSlot)
	_remove_children(%ChestplateSlot)
	_remove_children(%GlovesSlot)
	_remove_children(%HelmetSlot)
	_remove_children(%ShieldSlot)
	_remove_children(%SwordSlot)
	
	match(item_type):
		ItemType.ItemType.BOOTS:
			%BootsSlot.add_child(inventory_item)
		ItemType.ItemType.CHESTPLATE:
			%ChestplateSlot.add_child(inventory_item)
		ItemType.ItemType.GLOVES:
			%GlovesSlot.add_child(inventory_item)
		ItemType.ItemType.HELMET:
			%HelmetSlot.add_child(inventory_item)
		ItemType.ItemType.SHIELD:
			%ShieldSlot.add_child(inventory_item)
		ItemType.ItemType.SWORD:
			%SwordSlot.add_child(inventory_item)

func update_equipped_items() -> void:
	var equipped_items_index := Inventory.get_equipped_items_index()

	for item_index in equipped_items_index:
		var new_item_scene: InventoryItem = item_scene.instantiate().with_data(item_index)
		new_item_scene.on_item_selected.connect(_on_item_selected)

		_update_corresponding_slot(new_item_scene, Inventory.items[item_index].type)
