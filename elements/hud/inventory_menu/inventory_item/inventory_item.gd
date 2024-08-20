extends Node

class_name InventoryItem

func _init(level: int, rarity: ItemRarity.ItemRarity, texture: Texture2D) -> void:
	%ItemTextureRect.texture = texture
	%ItemLevelLabel.text = str(level)
	%ItemRarityLabel.text = str(rarity)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
