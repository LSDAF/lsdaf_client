extends Node

# Scripts
var game_save: GameSaveService    = (
	preload("res://autoload/services/game_save/game_save_service.gd").new()
)
var currencies: CurrenciesService = (
	preload("res://autoload/services/currencies/currencies_service.gd").new()
)
var current_quest: CurrentQuestService    = (
	preload("res://autoload/services/current_quest/current_quest_service.gd").new()
)
var difficulty: DifficultyService = (
	preload("res://autoload/services/difficulty/difficulty_service.gd").new()
)
var inventory: InventoryService = (
	preload("res://autoload/services/inventory/inventory_service.gd").new()
)
var loot: Loot = preload("res://autoload/services/loot/loot.gd").new()
var player_stats: PlayerStats = (
	preload("res://autoload/services/player_stats/player_stats.gd").new()
)
var toaster: ToasterService = preload("res://autoload/services/toaster/toaster_service.gd").new()
var user_data: UserDataService = (
	preload("res://autoload/services/user_data_service/user_data_service.gd").new()
)

# Scenes (CAUTION: The scenes need to be instanced in the _ready function)
var items_service: ItemsService = (
	preload("res://autoload/services/items/items_service.tscn").instantiate()
)


func _ready() -> void:
	add_child(items_service)
