extends Node
var clock: ClockService
var characteristics: CharacteristicsService
var currencies: CurrenciesService
var current_quest: CurrentQuestService
var stage: StageService
var inventory: InventoryService
var player_stats: PlayerStatsService
var random_number_generator: RandomNumberGeneratorService
var resource_loader: ResourceLoaderService
var resource_saver: ResourceSaverService
var toaster: ToasterService
var user_local_data: UserLocalDataService
var game_save: GameSaveService
var items: ItemsService
var loot: LootService
var http_event_handler: HttpEventHandler


# Wait for stores to be ready before initializing services
func _ready() -> void:
	await get_tree().root.ready
	_initialize_services()


func _initialize_services() -> void:
	clock = preload("res://src/services/clock/clock_service.gd").new()
	characteristics = (preload("res://src/services/characteristics/characteristics_service.gd").new(
		Data.characteristics
	))
	currencies = (preload("res://src/services/currencies/currencies_service.gd").new(
		Data.currencies
	))
	current_quest = (preload("res://src/services/current_quest/current_quest_service.gd").new(
		Data.currencies, Data.current_quest
	))
	stage = preload("res://src/services/stage/stage_service.gd").new(Data.stage, current_quest)
	inventory = preload("res://src/services/inventory/inventory_service.gd").new(Data.inventory)
	player_stats = (preload("res://src/services/player_stats/player_stats_service.gd").new(
		Data.characteristics, inventory
	))
	random_number_generator = (
		preload("res://src/services/random_number_generator/random_number_generator_service.gd")
		. new()
	)
	resource_loader = (
		preload("res://src/services/resource_loader/resource_loader_service.gd").new()
	)
	resource_saver = (preload("res://src/services/resource_saver/resource_saver_service.gd").new())
	toaster = preload("res://src/services/toaster/toaster_service.gd").new()
	user_local_data = (preload("res://src/services/user_local_data/user_local_data_service.gd").new(
		Api.auth, Data.user_local_data, resource_loader, resource_saver
	))
	game_save = preload("res://src/services/game_save/game_save_service.gd").new(
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
	items = preload("res://src/services/items/items_service.gd").new(game_save)
	loot = preload("res://src/services/loot/loot_service.gd").new(
		inventory,
		items,
		random_number_generator,
		Stores.get_store(&"Difficulty") as DifficultyStore
	)
	http_event_handler = (
		preload("res://src/services/http_event_handler/http_event_handler.gd")
		. new(Queue.new(), Queue.new())
	)
