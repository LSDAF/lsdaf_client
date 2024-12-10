class_name ArrayUtilsTest

extends GutTest


func test_find_index_with_predicate() -> void:
	# Arrange
	var array: Array = [1, 2, 3, 4, 5]
	var predicate: Callable = func(value: int) -> bool: return value == 3

	# Act
	var result: int = ArrayUtils.find_index_predicate(array, predicate)

	# Assert
	assert_eq(result, 2)


func test_find_index_with_predicate_when_no_element_matches() -> void:
	# Arrange
	var array: Array = [1, 2, 3, 4, 5]
	var predicate: Callable = func(value: int) -> bool: return value == 6

	# Act
	var result: int = ArrayUtils.find_index_predicate(array, predicate)

	# Assert
	assert_eq(result, -1)


func test_find_index_with_predicate_when_array_is_empty() -> void:
	# Arrange
	var array: Array = []
	var predicate: Callable = func(value: int) -> bool: return value == 3

	# Act
	var result: int = ArrayUtils.find_index_predicate(array, predicate)

	# Assert
	assert_eq(result, -1)


func test_find_index_with_predicate_when_predicate_does_not_return_bool() -> void:
	# Arrange
	var array: Array = [1, 2, 3, 4, 5]
	var predicate: Callable = func(value: int) -> int: return value - 1

	# Act
	var result: int = ArrayUtils.find_index_predicate(array, predicate)

	# Assert
	assert_eq(result, -1)
