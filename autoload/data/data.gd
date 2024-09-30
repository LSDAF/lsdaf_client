extends Node

# Scripts
var currencies: Currencies = preload("res://autoload/data/currencies/currencies.gd").new()
var inventory: Inventory = preload("res://autoload/data/inventory/inventory.gd").new()
var stage: Stage = preload("res://autoload/data/stage/stage.gd").new()

# Scenes (CAUTION: The scenes need to be instanced in the _ready function)
var characteristics: Characteristics = (
	preload("res://autoload/data/characteristics/characteristics.tscn").instantiate()
)
var current_quest: CurrentQuest = (
	preload("res://autoload/data/quests/current_quest.tscn").instantiate()
)
var difficulty: Difficulty = preload("res://autoload/data/difficulty/difficulty.tscn").instantiate()


func _ready() -> void:
	add_child(characteristics)
	add_child(current_quest)
	add_child(difficulty)
