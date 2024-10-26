extends GutTest

var sut: GameSaveService

var currencies_api := preload("res://src/http/currencies/currencies_api.gd")
var stage_api := preload("res://src/http/stage/stage_api.gd")
var currencies_service := preload("res://src/services/currencies/currencies_service.gd")
var clock_service := preload("res://src/services/clock/clock_service.gd")
var stage_service := preload("res://src/services/stage/stage_service.gd")
var currency_data := preload("res://src/data/currencies/currencies_data.gd")
var game_save_data := preload("res://src/data/game_save/game_save_data.gd")
var stage_data := preload("res://src/data/stage/stage_data.gd")

var currencies_api_partial_double: Variant
var stage_api_partial_double: Variant
var clock_service_partial_double: Variant
var currencies_service_partial_double: Variant
var stage_service_partial_double: Variant
var currency_data_partial_double: Variant
var game_save_data_partial_double: Variant
var stage_data_partial_double: Variant


func before_each() -> void:
	currency_data_partial_double = partial_double(currency_data).new()
	stage_data_partial_double = partial_double(stage_data).new()

	currencies_api_partial_double = partial_double(currencies_api).new()
	stage_api_partial_double = partial_double(stage_api).new()
	clock_service_partial_double = partial_double(clock_service).new()
	currencies_service_partial_double = partial_double(currencies_service).new(
		currency_data_partial_double
	)
	stage_service_partial_double = partial_double(stage_service).new(stage_data_partial_double)
	game_save_data_partial_double = partial_double(game_save_data).new()

	sut = (
		preload("res://src/services/game_save/game_save_service.gd")
		. new(
			currencies_api_partial_double,
			stage_api_partial_double,
			clock_service_partial_double,
			currencies_service_partial_double,
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

	stub(currencies_api_partial_double, "fetch_game_save_currencies").to_return(fetched_currencies)
	stub(stage_api_partial_double, "fetch_game_save_stage").to_return(fetched_stage)

	# Act
	sut.load_game_save("game_save_id")

	# Assert
	assert_eq(currency_data_partial_double.gold._value, 1000)
	assert_eq(currency_data_partial_double.diamond._value, 2000)
	assert_eq(currency_data_partial_double.emerald._value, 3000)
	assert_eq(currency_data_partial_double.amethyst._value, 4000)

	assert_eq(stage_data_partial_double._current_stage, 100)
	assert_eq(stage_data_partial_double._max_stage, 200)


func test_save_game_success() -> void:
	# Arrange
	stub(clock_service_partial_double, "get_unix_time_from_system").to_return(1000.0)

	stub(currencies_api_partial_double, "update_game_save_currencies").to_return(true)
	stub(stage_api_partial_double, "update_game_save_stage").to_return(true)

	# Act
	sut.save_game()

	# Assert
	assert_eq(game_save_data_partial_double._last_save_time, 1000.0)


func test_save_game_partial_failure() -> void:
	# Arrange
	stub(clock_service_partial_double, "get_unix_time_from_system").to_return(1000.0)

	stub(currencies_api_partial_double, "update_game_save_currencies").to_return(false)
	stub(stage_api_partial_double, "update_game_save_stage").to_return(true)

	# Act
	sut.save_game()

	# Assert
	assert_eq(game_save_data_partial_double._last_save_time, 0.0)


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

	# Assert


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