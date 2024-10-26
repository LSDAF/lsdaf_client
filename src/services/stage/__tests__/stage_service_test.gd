extends GutTest

var sut: StageService

var currencies_data := preload("res://src/data/currencies/currencies_data.gd")
var current_quest_data := preload("res://src/data/current_quest/current_quest_data.gd")
var difficulty_data := preload("res://src/data/difficulty/difficulty_data.gd")
var stage_data := preload("res://src/data/stage/stage_data.gd")
var current_quest_service := preload("res://src/services/current_quest/current_quest_service.gd")
var difficulty_service := preload("res://src/services/difficulty/difficulty_service.gd")

var currencies_data_partial_double: CurrenciesData
var current_quest_data_partial_double: CurrentQuestData
var difficulty_data_partial_double: DifficultyData
var stage_data_partial_double: StageData
var current_quest_service_partial_double: CurrentQuestService
var difficulty_service_partial_double: DifficultyService


func before_each() -> void:
	currencies_data_partial_double = partial_double(currencies_data).new()
	current_quest_data_partial_double = partial_double(current_quest_data).new()
	difficulty_data_partial_double = partial_double(difficulty_data).new()
	stage_data_partial_double = partial_double(stage_data).new()
	current_quest_service_partial_double = partial_double(current_quest_service).new(
		currencies_data_partial_double, current_quest_data_partial_double
	)
	difficulty_service_partial_double = partial_double(difficulty_service).new(
		difficulty_data_partial_double
	)

	sut = preload("res://src/services/stage/stage_service.gd").new(
		stage_data_partial_double,
		current_quest_service_partial_double,
		difficulty_service_partial_double
	)


func test_get_current_stage() -> void:
	# Arrange
	stage_data_partial_double._current_stage = 10

	# Act
	var current_stage: int = sut.get_current_stage()

	# Assert
	assert_eq(current_stage, 10)


func test_get_current_wave() -> void:
	# Arrange
	stage_data_partial_double._current_wave = 20

	# Act
	var current_wave: int = sut.get_current_wave()

	# Assert
	assert_eq(current_wave, 20)


func test_get_max_stage() -> void:
	# Arrange
	stage_data_partial_double._max_stage = 30

	# Act
	var max_stage: int = sut.get_max_stage()

	# Assert
	assert_eq(max_stage, 30)


func test_get_max_wave() -> void:
	# Arrange
	stage_data_partial_double._max_wave = 40

	# Act
	var max_wave: int = sut.get_max_wave()

	# Assert
	assert_eq(max_wave, 40)


# Parameters
# [current_wave, max_wave]
var test_is_boss_wave_parameters := [
	[0, 10],
	[1, 10],
	[2, 10],
	[9, 10],
	[10, 10],
	[1, 20],
	[2, 20],
	[9, 20],
	[10, 20],
	[20, 20],
]


func test_is_boss_wave(params: Array = use_parameters(test_is_boss_wave_parameters)) -> void:
	# Arrange
	var current_wave: int = params[0]
	var max_wave: int = params[1]

	stage_data_partial_double._current_wave = current_wave
	stage_data_partial_double._max_wave = max_wave

	# Act
	var is_boss_wave: bool = sut.is_boss_wave()

	# Assert
	assert_eq(is_boss_wave, current_wave == max_wave)


func test_set_current_stage() -> void:
	# Arrange
	stage_data_partial_double._current_stage = 10

	# Act
	sut.set_current_stage(100)

	# Assert
	assert_eq(stage_data_partial_double._current_stage, 100)


func test_set_current_wave() -> void:
	# Arrange
	stage_data_partial_double._current_wave = 10

	# Act
	sut.set_current_wave(20)

	# Assert
	assert_eq(stage_data_partial_double._current_wave, 20)


func test_set_max_stage() -> void:
	# Arrange
	stage_data_partial_double._max_stage = 20

	# Act
	sut.set_max_stage(500)

	# Assert
	assert_eq(stage_data_partial_double._max_stage, 500)


# Parameters
# [current_stage, max_stage]
var test_beat_current_stage_parameters := [
	[0, 10],
	[1, 10],
	[2, 10],
	[9, 10],
	[10, 10],
	[1, 20],
	[2, 20],
	[9, 20],
	[10, 20],
	[20, 20],
]


func test_beat_current_stage(
	params: Array = use_parameters(test_beat_current_stage_parameters)
) -> void:
	# Arrange
	var current_stage: int = params[0]
	var max_stage: int = params[1]

	stage_data_partial_double._current_stage = current_stage
	stage_data_partial_double._max_stage = max_stage

	# Act
	sut.beat_current_stage()

	# Assert
	assert_eq(stage_data_partial_double._current_stage, current_stage + 1)
	if current_stage == max_stage:
		assert_eq(stage_data_partial_double._max_stage, max_stage + 1)
