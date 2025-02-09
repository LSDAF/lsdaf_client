# gdlint: disable=class-definitions-order

extends GutTest

var sut: StageService

var currencies_store := preload("res://src/store/stores/currencies/currencies_store.gd")
var current_quest_data := preload("res://src/data/current_quest/current_quest_data.gd")
var stage_data := preload("res://src/data/stage/stage_data.gd")
var current_quest_service := preload("res://src/services/current_quest/current_quest_service.gd")

var currencies_store_partial_double: CurrenciesStore
var current_quest_data_partial_double: CurrentQuestData
var stage_data_partial_double: StageData
var current_quest_service_partial_double: CurrentQuestService
var difficulty_store: DifficultyStore


func before_each() -> void:
	currencies_store_partial_double = partial_double(currencies_store).new()
	current_quest_data_partial_double = partial_double(current_quest_data).new()
	stage_data_partial_double = partial_double(stage_data).new()
	current_quest_service_partial_double = partial_double(current_quest_service).new(
		currencies_store_partial_double, current_quest_data_partial_double
	)
	difficulty_store = partial_double(DifficultyStore).new()

	Stores.reset()
	await Stores.replace_stores_with_doubles({&"difficulty": difficulty_store})

	sut = preload("res://src/services/stage/stage_service.gd").new(
		stage_data_partial_double, current_quest_service_partial_double, difficulty_store
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


func test_set_current_stage_updates_difficulty() -> void:
	# Arrange
	stage_data_partial_double._current_stage = 10

	# Act
	sut.set_current_stage(100)

	# Assert
	assert_eq(difficulty_store.current_difficulty, 100.0)


func after_each() -> void:
	pass
