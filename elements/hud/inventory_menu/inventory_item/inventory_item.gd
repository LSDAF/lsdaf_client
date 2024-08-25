extends Node

class_name InventoryItem

signal on_item_selected(item_index: int)

var _item_index: int
var is_selected: bool = false


# See https://www.reddit.com/r/godot/comments/13pm5o5/instantiating_a_scene_with_constructor_parameters/
func with_data(item_index: int) -> InventoryItem:
	_item_index = item_index

	return self


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inventory_item := Inventory.get_item_at_index(_item_index)
	%ItemTextureRect.texture = inventory_item.texture
	%ItemLevelLabel.text = str(inventory_item.level)
	%ItemRarityLabel.text = _prettify_rarity(inventory_item.rarity)

	%SelectedTextureRect.visible = is_selected
	%ItemEquippedLabel.visible = inventory_item.is_equipped


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _prettify_rarity(item_rarity: ItemRarity.ItemRarity) -> String:
	match item_rarity:
		ItemRarity.ItemRarity.NORMAL:
			return "N"
		_:
			return "?"


func _on_pressed() -> void:
	on_item_selected.emit(_item_index)
