# GdUnit generated TestSuite
class_name DifficultyServiceTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://src/autoload/services/difficulty/difficulty_service.gd'


func test_set_current_difficulty() -> void:
	# Arrange
	Data.difficulty._current_difficulty = 420.69

	# Act
	DifficultyService.set_current_difficulty(1.0)

	# Assert
	assert_float(DifficultyService.get_current_difficulty()).is_equal(1.0)


func test_get_current_difficulty() -> void:
	# Arrange
	Data.difficulty._current_difficulty = 420.69

	# Act
	var current_difficulty: float = DifficultyService.get_current_difficulty()

	# Assert
	assert_float(current_difficulty).is_equal(420.69)
