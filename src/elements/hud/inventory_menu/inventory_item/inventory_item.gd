class_name InventoryItem
extends Node

signal on_item_selected(item_client_id: String)

var item_client_id: String
var is_selected: bool = false


# https://www.reddit.com/r/godot/comments/13pm5o5/instantiating_a_scene_with_constructor_parameters/
func with_data(item_client_id: String) -> InventoryItem:
	self.item_client_id = item_client_id

	return self


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inventory_item := Services.inventory.get_item_from_client_id(item_client_id)
	%ItemTextureRect.texture = inventory_item.texture
	%ItemLevelLabel.text = str(inventory_item.level)
	%ItemRarityLabel.text = _prettify_rarity(inventory_item.rarity)

	%SelectedTextureRect.visible = is_selected
	%ItemEquippedLabel.visible = inventory_item.is_equipped


func _prettify_rarity(item_rarity: ItemRarity.ItemRarity) -> String:
	return ItemRarity._prettify_rarity(item_rarity).substr(0, 1)


func _on_pressed() -> void:
	on_item_selected.emit(item_client_id)
