class_name ReactiveStoreTest extends GutTest


# Test implementation of ReactiveStore
class TestStore:
	extends ReactiveStore

	static func get_property_types() -> Dictionary:
		return {
			&"counter": TYPE_INT,
			&"name": TYPE_STRING,
			&"enabled": TYPE_BOOL,
			&"double_counter": TYPE_INT,
			&"counter_name": TYPE_STRING
		}

	static func get_initial_state() -> Dictionary:
		return {&"counter": 0, &"name": "Test", &"enabled": true}

	func _ready() -> void:
		_define_properties(get_property_types(), get_initial_state())

		define_computed(&"double_counter", func(): return await _get_property(&"counter") * 2)

		define_computed(
			&"counter_name",
			func():
				return "%s: %d" % [await _get_property(&"name"), await _get_property(&"counter")]
		)

		# Initialize computed properties
		await _get_property(&"double_counter")
		await _get_property(&"counter_name")


var sut: TestStore


func before_each() -> void:
	# Arrange
	sut = TestStore.new()
	add_child(sut)


func after_each() -> void:
	if is_instance_valid(sut):
		sut.queue_free()
	await get_tree().process_frame


func test_initialization() -> void:
	# Arrange - done in before_each

	# Act - initialization happens in _ready

	# Assert
	assert_true(sut._store_initialized, "Store should be initialized")
	assert_eq(await sut._get_property(&"counter"), 0, "Counter should be initialized to 0")
	assert_eq(await sut._get_property(&"name"), "Test", "Name should be initialized to 'Test'")
	assert_eq(await sut._get_property(&"enabled"), true, "Enabled should be initialized to true")


func test_set_property() -> void:
	# Arrange - done in before_each

	# Act
	sut.set_property(&"counter", 42)
	sut.set_property(&"name", "Updated")
	sut.set_property(&"enabled", false)

	# Assert
	assert_eq(await sut._get_property(&"counter"), 42, "Counter should be updated to 42")
	assert_eq(await sut._get_property(&"name"), "Updated", "Name should be updated to 'Updated'")
	assert_eq(await sut._get_property(&"enabled"), false, "Enabled should be updated to false")


func test_set_property_type_mismatch() -> void:
	# Arrange - done in before_each

	# Act & Assert
	watch_signals(sut)
	sut.set_property(&"counter", "not an int")
	assert_signal_not_emitted(
		sut, "property_changed", "Property should not change on type mismatch"
	)


func test_set_property_undefined() -> void:
	# Arrange - done in before_each

	# Act & Assert
	watch_signals(sut)
	sut.set_property(&"undefined", 42)
	assert_signal_not_emitted(sut, "property_changed", "Property should not change when undefined")


func test_set_properties() -> void:
	# Arrange - done in before_each

	# Act
	sut.set_properties({&"counter": 42, &"name": "Updated", &"enabled": false})

	# Assert
	assert_eq(await sut._get_property(&"counter"), 42, "Counter should be updated to 42")
	assert_eq(await sut._get_property(&"name"), "Updated", "Name should be updated to 'Updated'")
	assert_eq(await sut._get_property(&"enabled"), false, "Enabled should be updated to false")


func test_property_changed_signal() -> void:
	# Arrange - done in before_each
	watch_signals(sut)

	# Act
	sut.set_property(&"counter", 42)

	# Assert
	assert_signal_emitted_with_parameters(sut, "property_changed", [&"counter"])


func test_computed_property() -> void:
	# Arrange - done in before_each

	# Act
	sut.set_property(&"counter", 21)

	# Assert
	assert_eq(
		await sut._get_property(&"double_counter"),
		42,
		"Computed property should be double the counter"
	)


func test_computed_property_dependencies() -> void:
	# Arrange - done in before_each
	watch_signals(sut)

	# Act
	sut.set_property(&"counter", 21)
	# Access computed properties to trigger recomputation
	await sut._get_property(&"double_counter")
	await sut._get_property(&"counter_name")

	# Assert
	# Check that all expected signals were emitted, regardless of order
	var emitted_signals: int = get_signal_emit_count(sut, "property_changed")
	var expected_signals: Array[Array] = [[&"counter"], [&"double_counter"], [&"counter_name"]]

	for params: Array in expected_signals:
		var found: bool = false
		for i in range(emitted_signals):
			if get_signal_parameters(sut, "property_changed", i) == params:
				found = true
				break
		assert_true(found, "Expected signal with params %s was not emitted" % params)


func test_computed_property_with_multiple_dependencies() -> void:
	# Arrange - done in before_each

	# Act
	sut.set_property(&"counter", 42)
	sut.set_property(&"name", "Answer")

	# Assert
	assert_eq(
		await sut._get_property(&"counter_name"),
		"Answer: 42",
		"Computed property should update when any dependency changes"
	)


func test_computed_property_caching() -> void:
	# Arrange - done in before_each
	var computed: Dictionary = sut._computeds[&"double_counter"]

	# Act
	sut.set_property(&"counter", 21)
	var first_value := await sut._get_property(&"double_counter")
	var second_value := await sut._get_property(&"double_counter")

	# Assert
	assert_eq(first_value, 42, "First computed value should be correct")
	assert_eq(second_value, 42, "Second computed value should be cached")
	assert_false(computed.stale, "Computed value should not be stale after access")


func test_computed_property_invalidation() -> void:
	# Arrange - done in before_each
	var computed: Dictionary = sut._computeds[&"double_counter"]

	# Act
	sut.set_property(&"counter", 21)
	var unused_value := await sut._get_property(&"double_counter")  # Access to cache value
	sut.set_property(&"counter", 42)  # Should invalidate cache

	# Assert
	assert_true(computed.stale, "Computed value should be stale after dependency change")
