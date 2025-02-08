extends GutTest

var sut: DifficultyStore


func before_each() -> void:
	sut = DifficultyStore.new()
	Stores.override("Difficulty", sut)


func test_set_current_difficulty() -> void:
	# Arrange
	sut.current_difficulty = 420.0

	# Act
	sut.set_current_difficulty(1.0)

	# Assert
	assert_eq(sut.current_difficulty, 1.0)


func test_get_current_difficulty() -> void:
	# Arrange
	sut.current_difficulty = 69.0

	# Act
	var current_difficulty: float = sut.current_difficulty

	# Assert
	assert_eq(current_difficulty, 69.0)


func after_each() -> void:
	Stores.reset()
