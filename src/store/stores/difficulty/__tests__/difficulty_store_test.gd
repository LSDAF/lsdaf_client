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


func test_property_cannot_be_set_directly() -> void:
	# Arrange
	var old_difficulty = sut.current_difficulty_property

	# Act
	sut.current_difficulty_property = ReactiveStoreProperty.new(sut, &"current_difficulty")

	# Assert
	assert_eq(
		sut.current_difficulty_property,
		old_difficulty,
		"Current difficulty property should not change"
	)


func test_get_current_difficulty() -> void:
	# Arrange
	await sut.current_difficulty_property.set_value(69.0)

	# Act
	var current_difficulty: float = await sut.current_difficulty_property.get_value()

	# Assert
	assert_eq(current_difficulty, 69.0)
