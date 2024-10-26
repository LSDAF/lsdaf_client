extends GutTest

var sut: DifficultyService

var difficulty_data := preload("res://src/data/difficulty/difficulty_data.gd")

var difficulty_data_partial_double: DifficultyData

func before_each() -> void:
	difficulty_data_partial_double = partial_double(difficulty_data).new()
	sut = preload("res://src/services/difficulty/difficulty_service.gd").new(difficulty_data_partial_double)


func test_set_current_difficulty() -> void:
	# Arrange
	difficulty_data_partial_double._current_difficulty = 420.0

	# Act
	sut.set_current_difficulty(1.0)

	# Assert
	assert_eq(difficulty_data_partial_double._current_difficulty, 1.0)

func test_get_current_difficulty() -> void:
	# Arrange
	difficulty_data_partial_double._current_difficulty = 69.0

	# Act
	var current_difficulty: float = sut.get_current_difficulty()

	# Assert
	assert_eq(current_difficulty, 69.0)
