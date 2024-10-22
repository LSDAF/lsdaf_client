extends Node

# Scripts
var currencies: Currencies = preload("res://src/autoload/data/currencies/currencies.gd").new()
var difficulty: Difficulty = preload("res://src/autoload/data/difficulty/difficulty.gd").new()
var game_save: GameSave = preload("res://src/autoload/data/game_save/game_save.gd").new()
var inventory: Inventory = preload("res://src/autoload/data/inventory/inventory.gd").new()
var user_local_data: UserLocalData = (
	preload("res://src/autoload/data/user_local_data/user_local_data.gd").new()
)
var stage: Stage = preload("res://src/autoload/data/stage/stage.gd").new()

# Scenes (CAUTION: The scenes need to be instanced in the _ready function)
var characteristics: Characteristics = (
	preload("res://src/autoload/data/characteristics/characteristics.tscn").instantiate()
)
var current_quest: CurrentQuest = (
	preload("res://src/autoload/data/current_quest/current_quest.tscn").instantiate()
)


func _ready() -> void:
	add_child(characteristics)
	add_child(current_quest)
