extends Control

signal on_item_selected(item_index: int)

@export var item_scene: PackedScene
@export var empty_item_scene: PackedScene

var _equipped_items := {
	"boots": null,
	"chestplate": null,
	"gloves": null,
	"helmet": null,
	"shield": null,
	"sword": null,
}


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


func _update_corresponding_slot_child(slot: Node, inventory_item: InventoryItem) -> void:
	_remove_children(slot)

	if inventory_item == null:
		var a := empty_item_scene.instantiate()
		slot.add_child(a)

	if inventory_item != null:
		slot.add_child(inventory_item)


func _update_corresponding_slots() -> void:
	_update_corresponding_slot_child(%BootsSlot, _equipped_items.boots)
	_update_corresponding_slot_child(%ChestplateSlot, _equipped_items.chestplate)
	_update_corresponding_slot_child(%GlovesSlot, _equipped_items.gloves)
	_update_corresponding_slot_child(%HelmetSlot, _equipped_items.helmet)
	_update_corresponding_slot_child(%ShieldSlot, _equipped_items.shield)
	_update_corresponding_slot_child(%SwordSlot, _equipped_items.sword)


func _update_corresponding_equipped_item(
	inventory_item: InventoryItem, item_type: ItemType.ItemType
) -> void:
	match item_type:
		ItemType.ItemType.BOOTS:
			_equipped_items.boots = inventory_item
		ItemType.ItemType.CHESTPLATE:
			_equipped_items.chestplate = inventory_item
		ItemType.ItemType.GLOVES:
			_equipped_items.gloves = inventory_item
		ItemType.ItemType.HELMET:
			_equipped_items.helmet = inventory_item
		ItemType.ItemType.SHIELD:
			_equipped_items.shield = inventory_item
		ItemType.ItemType.SWORD:
			_equipped_items.sword = inventory_item


func update_equipped_items() -> void:
	_equipped_items = {
		"boots": null,
		"chestplate": null,
		"gloves": null,
		"helmet": null,
		"shield": null,
		"sword": null,
	}

	var equipped_items_index := Services.inventory.get_equipped_items_index()

	for item_index in equipped_items_index:
		var new_item_scene: InventoryItem = item_scene.instantiate().with_data(item_index)
		new_item_scene.on_item_selected.connect(_on_item_selected)

		_update_corresponding_equipped_item(new_item_scene, Services.inventory.get_item_at_index(item_index).type)

	_update_corresponding_slots()
