# gdlint: disable=class-definitions-order

extends GutTest

var sut: StageService

var currencies_store := preload("res://src/store/stores/currencies/currencies_store.gd")
var current_quest_data := preload("res://src/data/current_quest/current_quest_data.gd")
var stage_store := preload("res://src/store/stores/stage/stage_store.gd")
var current_quest_service := preload("res://src/services/current_quest/current_quest_service.gd")

var currencies_store_partial_double: CurrenciesStore
var current_quest_data_partial_double: CurrentQuestData
var stage_store_partial_double: StageStore
var current_quest_service_partial_double: CurrentQuestService
var difficulty_store: DifficultyStore


func before_each() -> void:
	currencies_store_partial_double = partial_double(currencies_store).new()
	current_quest_data_partial_double = partial_double(current_quest_data).new()
	stage_store_partial_double = partial_double(stage_store).new()
	difficulty_store = partial_double(DifficultyStore).new()

	# Initialize stage store
	stage_store_partial_double._initialize_reactive_store(
		{
			&"current_stage": TYPE_INT,
			&"current_wave": TYPE_INT,
			&"max_stage": TYPE_INT,
			&"max_wave": TYPE_INT
		},
		{&"current_stage": 1, &"current_wave": 1, &"max_stage": 1, &"max_wave": 10}
	)

	# Initialize difficulty store
	difficulty_store._initialize_reactive_store(
		{&"current_difficulty": TYPE_FLOAT}, {&"current_difficulty": 1.0}
	)

	# Create reactive properties
	stage_store_partial_double.current_stage_property = ReactiveStoreProperty.new(
		stage_store_partial_double, &"current_stage"
	)
	stage_store_partial_double.current_wave_property = ReactiveStoreProperty.new(
		stage_store_partial_double, &"current_wave"
	)
	stage_store_partial_double.max_stage_property = ReactiveStoreProperty.new(
		stage_store_partial_double, &"max_stage"
	)
	stage_store_partial_double.max_wave_property = ReactiveStoreProperty.new(
		stage_store_partial_double, &"max_wave"
	)
	difficulty_store.current_difficulty_property = ReactiveStoreProperty.new(
		difficulty_store, &"current_difficulty"
	)

	# Define computed properties
	stage_store_partial_double.define_computed(
		&"is_boss_wave",
		func() -> bool:
			var current_wave = await stage_store_partial_double.current_wave_property.get_value()
			var max_wave = await stage_store_partial_double.max_wave_property.get_value()
			return current_wave == max_wave
	)

	stage_store_partial_double.is_boss_wave_computed = ReactiveStoreComputed.new(
		stage_store_partial_double, &"is_boss_wave"
	)

	# Initialize services
	current_quest_service_partial_double = partial_double(current_quest_service).new(
		currencies_store_partial_double, current_quest_data_partial_double
	)

	# Reset stores
	Stores.reset()
	await Stores.replace_stores_with_doubles({&"difficulty": difficulty_store})

	# Initialize stage service
	sut = StageService.new(
		stage_store_partial_double, current_quest_service_partial_double, difficulty_store
	)


func test_get_current_stage() -> void:
	# Arrange
	stage_store_partial_double.set_current_stage(10)

	# Act
	var current_stage: int = await sut.get_current_stage()

	# Assert
	assert_eq(current_stage, 10)


func test_get_current_wave() -> void:
	# Arrange
	stage_store_partial_double.set_current_wave(20)

	# Act
	var current_wave: int = await sut.get_current_wave()

	# Assert
	assert_eq(current_wave, 20)


func test_get_max_stage() -> void:
	# Arrange
	stage_store_partial_double.set_max_stage(30)

	# Act
	var max_stage: int = await sut.get_max_stage()

	# Assert
	assert_eq(max_stage, 30)


func test_get_max_wave() -> void:
	# Arrange
	stage_store_partial_double.set_max_wave(40)

	# Act
	var max_wave: int = await sut.get_max_wave()

	# Assert
	assert_eq(max_wave, 40)


# Parameters
# [current_wave, max_wave, expected]
var test_is_boss_wave_parameters := [
	[0, 10, false],
	[1, 10, false],
	[2, 10, false],
	[9, 10, false],
	[10, 10, true],
	[1, 20, false],
	[2, 20, false],
	[9, 20, false],
	[19, 20, false],
	[20, 20, true],
]


func test_is_boss_wave(params: Array = use_parameters(test_is_boss_wave_parameters)) -> void:
	# Arrange
	var current_wave: int = params[0]
	var max_wave: int = params[1]
	var expected: bool = params[2]

	stage_store_partial_double.set_current_wave(current_wave)
	stage_store_partial_double.set_max_wave(max_wave)

	# Act
	var is_boss_wave: bool = await sut.is_boss_wave()

	# Assert
	assert_eq(is_boss_wave, expected)


func test_set_current_stage() -> void:
	# Arrange
	stage_store_partial_double.set_current_stage(10)

	# Act
	sut.set_current_stage(100)

	# Assert
	assert_eq(await stage_store_partial_double.current_stage_property.get_value(), 100)


func test_set_current_wave() -> void:
	# Arrange
	stage_store_partial_double.set_current_wave(10)

	# Act
	sut.set_current_wave(20)

	# Assert
	assert_eq(await stage_store_partial_double.current_wave_property.get_value(), 20)


func test_set_max_stage() -> void:
	# Arrange
	stage_store_partial_double.set_max_stage(20)

	# Act
	sut.set_max_stage(500)

	# Assert
	assert_eq(await stage_store_partial_double.max_stage_property.get_value(), 500)


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

	stage_store_partial_double.set_current_stage(current_stage)
	stage_store_partial_double.set_max_stage(max_stage)

	# Act
	sut.beat_current_stage()

	# Assert
	assert_eq(
		await stage_store_partial_double.current_stage_property.get_value(), current_stage + 1
	)
	if current_stage == max_stage:
		assert_eq(await stage_store_partial_double.max_stage_property.get_value(), max_stage + 1)


func test_set_current_stage_updates_difficulty() -> void:
	# Arrange

	# Act
	sut.set_current_stage(100)

	# Assert
	assert_almost_eq(await difficulty_store.current_difficulty_property.get_value(), 100.0, 0.001)

	# Act
	sut.set_current_stage(100)

	# Assert
	assert_almost_eq(await difficulty_store.current_difficulty_property.get_value(), 100.0, 0.001)
