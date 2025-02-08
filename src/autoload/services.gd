extends Node

const CharacteristicsStore := preload(
	"res://src/store/stores/characteristics/characteristics_store.gd"
)
const CurrenciesStore := preload("res://src/store/stores/currencies/currencies_store.gd")

var clock: ClockService = preload("res://src/services/clock/clock_service.gd").new()

var characteristics := Stores.characteristics
var currencies := Stores.currencies

var difficulty_store := Stores.difficulty

var current_quest := preload("res://src/services/current_quest/current_quest_service.gd").new(
	Data.currencies, Data.current_quest
)

var stage := preload("res://src/services/stage/stage_service.gd").new(
	Data.stage, current_quest, difficulty_store
)

var inventory := preload("res://src/services/inventory/inventory_service.gd").new(Data.inventory)

var player_stats := preload("res://src/services/player_stats/player_stats_service.gd").new(
	Data.characteristics, inventory
)

var random_number_generator := (
	preload("res://src/services/random_number_generator/random_number_generator_service.gd").new()
)

var resource_loader := (
	preload("res://src/services/resource_loader/resource_loader_service.gd").new()
)

var resource_saver := preload("res://src/services/resource_saver/resource_saver_service.gd").new()

var toaster := preload("res://src/services/toaster/toaster_service.gd").new()

var user_local_data := preload("res://src/services/user_local_data/user_local_data_service.gd").new(
	Api.auth, Data.user_local_data, resource_loader, resource_saver
)

var http_event_handler := (
	preload("res://src/services/http_event_handler/http_event_handler.gd")
	. new(Queue.new(), Queue.new())
)

var game_save := preload("res://src/services/game_save/game_save_service.gd").new(
	Api.characteristics,
	Api.currencies,
	Api.inventory,
	Api.stage,
	clock,
	characteristics,
	currencies,
	inventory,
	stage,
	Data.game_save
)

var items := preload("res://src/services/items/items_service.gd").new(game_save)

var loot := preload("res://src/services/loot/loot_service.gd").new(
	inventory, items, random_number_generator, difficulty_store
)
