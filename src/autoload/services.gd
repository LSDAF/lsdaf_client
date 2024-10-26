extends Node

var clock: ClockService = preload("res://src/services/clock/clock_service.gd").new()
var currencies: CurrenciesService = (
	preload("res://src/services/currencies/currencies_service.gd").new(Data.currencies)
)
var stage: StageService = preload("res://src/services/stage/stage_service.gd").new(Data.stage)
var current_quest: CurrentQuestService = (
	preload("res://src/services/current_quest/current_quest_service.gd")
	. new(Data.currencies, Data.current_quest, stage)
)
var difficulty: DifficultyService = (
	preload("res://src/services/difficulty/difficulty_service.gd").new(Data.difficulty)
)
var inventory: InventoryService = preload("res://src/services/inventory/inventory_service.gd").new()
var items: ItemsService = preload("res://src/services/items/items_service.gd").new()
var loot: LootService = preload("res://src/services/loot/loot_service.gd").new()
var player_stats: PlayerStatsService = (
	preload("res://src/services/player_stats/player_stats_service.gd").new()
)
var toaster: ToasterService = preload("res://src/services/toaster/toaster_service.gd").new()
var user_local_data: UserLocalDataService = (
	preload("res://src/services/user_local_data/user_local_data_service.gd").new()
)

var game_save: GameSaveService = preload("res://src/services/game_save/game_save_service.gd").new(
	Api.currencies, Api.stage, clock, currencies, stage, Data.game_save
)
