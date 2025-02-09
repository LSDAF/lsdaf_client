extends GutTest

var sut: BaseState


# Test implementation of BaseState
class TestState:
	extends BaseState

	static func get_property_types() -> Dictionary:
		return {&"health": TYPE_INT, &"name": TYPE_STRING}

	static func get_initial_state() -> Dictionary:
		return {&"health": 100, &"name": "Player"}


# Invalid implementation missing required methods
class InvalidState:
	extends BaseState


# Implementation with type mismatch
class InvalidTypeState:
	extends BaseState

	static func get_property_types() -> Dictionary:
		return {&"score": TYPE_INT}

	static func get_initial_state() -> Dictionary:
		return {&"score": "invalid"}  # String instead of int


func before_each() -> void:
	# Arrange
	sut = BaseState.new()
	add_child(sut)


func after_each() -> void:
	if is_instance_valid(sut):
		sut.queue_free()
	await get_tree().process_frame


func test_base_state_abstract_methods() -> void:
	# Arrange - done in before_each

	# Act & Assert
	var result = sut.get_property_types()
	assert_eq(result, {}, "Base state should return empty dictionary for get_property_types")

	result = sut.get_initial_state()
	assert_eq(result, {}, "Base state should return empty dictionary for get_initial_state")


func test_valid_state_implementation() -> void:
	# Arrange
	sut.queue_free()
	sut = TestState.new()
	add_child(sut)

	# Act
	var types := sut.get_property_types()
	var initial := sut.get_initial_state()

	# Assert
	assert_eq(types.size(), 2, "Should have 2 property types")
	assert_eq(types[&"health"], TYPE_INT, "Health should be TYPE_INT")
	assert_eq(types[&"name"], TYPE_STRING, "Name should be TYPE_STRING")

	assert_eq(initial.size(), 2, "Should have 2 initial values")
	assert_eq(initial[&"health"], 100, "Health should be initialized to 100")
	assert_eq(initial[&"name"], "Player", "Name should be initialized to 'Player'")


func test_missing_implementation() -> void:
	# Arrange
	sut.queue_free()
	sut = InvalidState.new()
	add_child(sut)

	# Act & Assert
	var result = sut.get_property_types()
	assert_eq(result, {}, "Invalid state should return empty dictionary for get_property_types")

	result = sut.get_initial_state()
	assert_eq(result, {}, "Invalid state should return empty dictionary for get_initial_state")


func test_type_mismatch() -> void:
	# Arrange
	sut.queue_free()
	sut = InvalidTypeState.new()
	add_child(sut)

	# Act
	var types := sut.get_property_types()
	var initial := sut.get_initial_state()

	# Assert
	assert_eq(typeof(initial[&"score"]), TYPE_STRING, "Initial value is string")
	assert_ne(
		typeof(initial[&"score"]),
		types[&"score"],
		"Type mismatch between definition and initial value"
	)
