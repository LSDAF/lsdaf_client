extends GutTest

var sut: GameSaveService

var characteristics_api := preload("res://src/http/characteristics/characteristics_api.gd")
var currencies_api := preload("res://src/http/currencies/currencies_api.gd")
var inventory_api := preload("res://src/http/inventory/inventory_api.gd")
var stage_api := preload("res://src/http/stage/stage_api.gd")
var game_save_data := preload("res://src/data/game_save/game_save_data.gd")
var inventory_data := preload("res://src/data/inventory/inventory_data.gd")
var stage_data := preload("res://src/data/stage/stage_data.gd")
var characteristics_store := preload(
	"res://src/store/stores/characteristics/characteristics_store.gd"
)
var currencies_store := preload("res://src/store/stores/currencies/currencies_store.gd")
var clock_service := preload("res://src/services/clock/clock_service.gd")
var current_quest_service := preload("res://src/services/current_quest/current_quest_service.gd")
var inventory_service := preload("res://src/services/inventory/inventory_service.gd")
var stage_service := preload("res://src/services/stage/stage_service.gd")

var characteristics_api_partial_double: Variant
var currencies_api_partial_double: Variant
var inventory_api_partial_double: Variant
var stage_api_partial_double: Variant
var game_save_data_partial_double: Variant
var inventory_data_partial_double: Variant
var stage_data_partial_double: Variant
var characteristics_store_partial_double: Variant
var currencies_store_partial_double: Variant
var clock_service_partial_double: Variant
var current_quest_service_partial_double: Variant
var inventory_service_partial_double: Variant
var stage_service_partial_double: Variant
var difficulty_store: DifficultyStore


func before_each() -> void:
	inventory_data_partial_double = partial_double(inventory_data).new()
	stage_data_partial_double = partial_double(stage_data).new()

	characteristics_api_partial_double = partial_double(characteristics_api).new()
	currencies_api_partial_double = partial_double(currencies_api).new()
	inventory_api_partial_double = partial_double(inventory_api).new()
	stage_api_partial_double = partial_double(stage_api).new()
	clock_service_partial_double = partial_double(clock_service).new()
	current_quest_service_partial_double = partial_double(current_quest_service).new()
	characteristics_store_partial_double = partial_double(characteristics_store).new()
	currencies_store_partial_double = partial_double(currencies_store).new()
	inventory_service_partial_double = partial_double(inventory_service).new(
		inventory_data_partial_double
	)

	Stores.reset()
	difficulty_store = DifficultyStore.new()
	Stores.register(&"Difficulty", difficulty_store)
	Stores._post_initialize_stores()

	stage_service_partial_double = partial_double(stage_service).new(
		stage_data_partial_double, current_quest_service_partial_double, difficulty_store
	)
	game_save_data_partial_double = partial_double(game_save_data).new()

	sut = (
		preload("res://src/services/game_save/game_save_service.gd")
		. new(
			characteristics_api_partial_double,
			currencies_api_partial_double,
			inventory_api_partial_double,
			stage_api_partial_double,
			clock_service_partial_double,
			characteristics_store_partial_double,
			currencies_store_partial_double,
			inventory_service_partial_double,
			stage_service_partial_double,
			game_save_data_partial_double,
		)
	)


func test_get_game_save_id() -> void:
	# Arrange
	game_save_data_partial_double._game_save_id = "game_save_id"

	# Act
	var game_save_id: String = sut.get_game_save_id()

	# Assert
	assert_eq(game_save_id, "game_save_id")


func test_load_game_save() -> void:
	# Arrange
	var fetched_characteristics: FetchCharacteristicsDto = (
		FetchCharacteristicsDto
		. new(
			{
				"attack": 100,
				"crit_chance": 100,
				"crit_damage": 100,
				"health": 100,
				"resistance": 100,
			}
		)
	)
	var fetched_currencies: CurrenciesDto = (
		CurrenciesDto
		. new(
			{
				"gold": 1000,
				"diamond": 2000,
				"emerald": 3000,
				"amethyst": 4000,
			}
		)
	)
	var fetched_stage: FetchStageDto = (
		FetchStageDto
		. new(
			{
				"current_stage": 100,
				"max_stage": 200,
			}
		)
	)

	var fetched_inventory: FetchInventoryDto = FetchInventoryDto.new({"items": []})

	stub(characteristics_api_partial_double, "fetch_game_save_characteristics").to_return(
		fetched_characteristics
	)
	stub(currencies_api_partial_double, "fetch_game_save_currencies").to_return(fetched_currencies)
	stub(inventory_api_partial_double, "fetch_game_save_inventory").to_return(fetched_inventory)
	stub(stage_api_partial_double, "fetch_game_save_stage").to_return(fetched_stage)

	# Act
	sut.load_game_save("game_save_id")

	# Assert
	assert_eq(currencies_store_partial_double.gold, 1000)
	assert_eq(currencies_store_partial_double.diamond, 2000)
	assert_eq(currencies_store_partial_double.emerald, 3000)
	assert_eq(currencies_store_partial_double.amethyst, 4000)

	assert_eq(stage_data_partial_double._current_stage, 100)
	assert_eq(stage_data_partial_double._max_stage, 200)

	assert_eq(characteristics_store_partial_double.attack, 100)
	assert_eq(characteristics_store_partial_double.crit_chance, 100)
	assert_eq(characteristics_store_partial_double.crit_damage, 100)
	assert_eq(characteristics_store_partial_double.health, 100)
	assert_eq(characteristics_store_partial_double.resistance, 100)

	assert_eq(inventory_data_partial_double.items.size(), 0)

	assert_eq(difficulty_store.current_difficulty, 100.0)


func test_save_game_success() -> void:
	# Arrange
	stub(clock_service_partial_double, "get_unix_time_from_system").to_return(1000.0)

	stub(characteristics_api_partial_double, "update_game_save_characteristics").to_return(true)
	stub(currencies_api_partial_double, "update_game_save_currencies").to_return(true)
	stub(stage_api_partial_double, "update_game_save_stage").to_return(true)

	# Act
	sut.save_game()

	# Assert
	assert_eq(game_save_data_partial_double._last_save_time, 1000.0)


func test_save_game_partial_failure() -> void:
	# Arrange
	stub(clock_service_partial_double, "get_unix_time_from_system").to_return(1000.0)

	stub(characteristics_api_partial_double, "update_game_save_characteristics").to_return(true)
	stub(currencies_api_partial_double, "update_game_save_currencies").to_return(false)
	stub(stage_api_partial_double, "update_game_save_stage").to_return(true)

	# Act
	sut.save_game()

	# Assert
	assert_eq(game_save_data_partial_double._last_save_time, 0.0)


func test_save_characteristics_success() -> void:
	# Arrange
	stub(characteristics_api_partial_double, "update_game_save_characteristics").to_return(true)

	# Act
	var success := await sut._save_characteristics()

	# Assert
	assert_true(success)


func test_save_characteristics_failure() -> void:
	# Arrange
	stub(characteristics_api_partial_double, "update_game_save_characteristics").to_return(false)

	# Act
	var success := await sut._save_characteristics()

	# Assert
	assert_false(success)


func test_save_currencies_success() -> void:
	# Arrange
	stub(currencies_api_partial_double, "update_game_save_currencies").to_return(true)

	# Act
	var success := await sut._save_currencies()

	# Assert
	assert_true(success)


func test_save_currencies_failure() -> void:
	# Arrange
	stub(currencies_api_partial_double, "update_game_save_currencies").to_return(false)

	# Act
	var success := await sut._save_currencies()

	# Assert
	assert_false(success)


func test_save_stage_success() -> void:
	# Arrange
	stub(stage_api_partial_double, "update_game_save_stage").to_return(true)

	# Act
	var success := await sut._save_stage()

	# Assert
	assert_true(success)


func test_save_stage_failure() -> void:
	# Arrange
	stub(stage_api_partial_double, "update_game_save_stage").to_return(false)

	# Act
	var success := await sut._save_stage()

	# Assert
	assert_false(success)


func after_each() -> void:
	Stores.reset()
