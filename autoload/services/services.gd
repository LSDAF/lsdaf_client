extends Node

# Scripts
var game_save_service: GameSaveService = preload("res://autoload/services/game_save/game_save_service.gd").new()
var loot: Loot = preload("res://autoload/services/loot/loot.gd").new()
var player_stats: PlayerStats = preload("res://autoload/services/player_stats/player_stats.gd").new()

# Scenes (CAUTION: The scenes need to be instanced in the _ready function)
var items_service: ItemsService = preload("res://autoload/services/items/items_service.tscn").instantiate()

func _ready() -> void:
	add_child(items_service)
