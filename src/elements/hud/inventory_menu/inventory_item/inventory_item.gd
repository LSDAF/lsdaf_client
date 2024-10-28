class_name InventoryItem
extends Node

signal on_item_selected(item_index: int)

var item_index: int
var is_selected: bool = false


# https://www.reddit.com/r/godot/comments/13pm5o5/instantiating_a_scene_with_constructor_parameters/
func with_data(item_to_load_index: int) -> InventoryItem:
	item_index = item_to_load_index

	return self


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inventory_item := Services.inventory.get_item_at_index(item_index)
	%ItemTextureRect.texture = inventory_item.texture
	%ItemLevelLabel.text = str(inventory_item.level)
	%ItemRarityLabel.text = _prettify_rarity(inventory_item.rarity)

	%SelectedTextureRect.visible = is_selected
	%ItemEquippedLabel.visible = inventory_item.is_equipped


func _prettify_rarity(item_rarity: ItemRarity.ItemRarity) -> String:
	match item_rarity:
		ItemRarity.ItemRarity.NORMAL:
			return "N"
		_:
			return "?"


func _on_pressed() -> void:
	on_item_selected.emit(item_index)
