extends Node

# Public variables (services)
var clock: ClockService = preload("res://src/services/clock/clock_service.gd").new()
var current_quest := preload("res://src/services/current_quest/current_quest_service.gd").new(
	_currencies_store, Data.current_quest
)
var game_save := preload("res://src/services/game_save/game_save_service.gd").new(
	Api.characteristics,
	Api.currencies,
	Api.inventory,
	Api.stage,
	clock,
	_characteristics_store,
	_currencies_store,
	inventory,
	stage,
	Data.game_save
)
var http_event_handler := (
	preload("res://src/services/http_event_handler/http_event_handler.gd")
	. new(Queue.new(), Queue.new())
)
var inventory := preload("res://src/services/inventory/inventory_service.gd").new(Data.inventory)
var items := preload("res://src/services/items/items_service.gd").new(game_save)
var loot := preload("res://src/services/loot/loot_service.gd").new(
	inventory, items, random_number_generator, _difficulty_store
)
var player_stats := preload("res://src/services/player_stats/player_stats_service.gd").new(
	inventory
)
var random_number_generator := (
	preload("res://src/services/random_number_generator/random_number_generator_service.gd").new()
)
var resource_loader := (
	preload("res://src/services/resource_loader/resource_loader_service.gd").new()
)
var resource_saver := preload("res://src/services/resource_saver/resource_saver_service.gd").new()
var stage := preload("res://src/services/stage/stage_service.gd").new(
	_stage_store, current_quest, _difficulty_store
)
var toaster := preload("res://src/services/toaster/toaster_service.gd").new()
var user_local_data := preload("res://src/services/user_local_data/user_local_data_service.gd").new(
	Api.auth, Data.user_local_data, resource_loader, resource_saver
)

# Private variables (store references)
var _characteristics_store := Stores.characteristics
var _currencies_store := Stores.currencies
var _difficulty_store := Stores.difficulty
var _stage_store := Stores.stage
