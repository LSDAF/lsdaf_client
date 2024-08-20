extends Node

class_name InventoryItem

var _level: int
var _rarity: ItemRarity.ItemRarity
var _texture: Texture2D

# See https://www.reddit.com/r/godot/comments/13pm5o5/instantiating_a_scene_with_constructor_parameters/
func with_data(level: int, rarity: ItemRarity.ItemRarity, texture: Texture2D) -> InventoryItem:
	_level = level
	_rarity = rarity
	_texture = texture

	return self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%ItemTextureRect.texture = _texture
	%ItemLevelLabel.text = str(_level)
	%ItemRarityLabel.text = str(_rarity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
