extends Node

# Scripts
var game_save: GameSaveService = (
	preload("res://src/autoload/services/game_save/game_save_service.gd").new()
)
var currencies: CurrenciesService = (
	preload("res://src/autoload/services/currencies/currencies_service.gd").new()
)
var current_quest: CurrentQuestService = (
	preload("res://src/autoload/services/current_quest/current_quest_service.gd").new()
)
var difficulty: DifficultyService = (
	preload("res://src/autoload/services/difficulty/difficulty_service.gd").new()
)
var inventory: InventoryService = (
	preload("res://src/autoload/services/inventory/inventory_service.gd").new()
)
var loot: Loot = preload("res://src/autoload/services/loot/loot.gd").new()
var player_stats: PlayerStats = (
	preload("res://src/autoload/services/player_stats/player_stats.gd").new()
)
var stage: StageService = preload("res://src/autoload/services/stage/stage_service.gd").new()
var toaster: ToasterService = preload("res://src/autoload/services/toaster/toaster_service.gd").new()
var user_local_data: UserLocalDataService = (
	preload("res://src/autoload/services/user_local_data_service/user_local_data_service.gd").new()
)

# Scenes (CAUTION: The scenes need to be instanced in the _ready function)
var items_service: ItemsService = (
	preload("res://src/autoload/services/items/items_service.tscn").instantiate()
)


func _ready() -> void:
	add_child(items_service)
