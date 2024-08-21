extends Resource

class_name ItemBlueprint

@export var main_stat: ItemStatBlueprint
@export var rarity: ItemRarity.ItemRarity
@export_range(1, 100, 1) var level: int
@export var type: ItemType.ItemType
@export var name: String
@export var texture: Texture2D
