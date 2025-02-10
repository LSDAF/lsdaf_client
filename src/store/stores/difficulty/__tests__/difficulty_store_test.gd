extends GutTest

var sut: DifficultyStore


func before_each() -> void:
	sut = DifficultyStore.new()
	Stores.reset()
	await Stores.replace_stores_with_doubles({&"difficulty": sut})


func test_set_current_difficulty() -> void:
	# Arrange
	await sut.current_difficulty_property.set_value(420.0)

	# Act
	sut.set_current_difficulty(1.0)

	# Assert
	assert_eq(await sut.current_difficulty_property.get_value(), 1.0)


func test_get_current_difficulty() -> void:
	# Arrange
	await sut.current_difficulty_property.set_value(69.0)

	# Act
	var current_difficulty: float = await sut.current_difficulty_property.get_value()

	# Assert
	assert_eq(current_difficulty, 69.0)
