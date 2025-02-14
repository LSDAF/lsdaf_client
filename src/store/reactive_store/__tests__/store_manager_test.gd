extends GutTest

var sut: StoreManager
var mock_store: Node


func before_each() -> void:
	sut = StoreManager.new()
	mock_store = Node.new()
	mock_store.name = "mock_store"
	add_child_autofree(sut)


func after_each() -> void:
	sut.free()
	if is_instance_valid(mock_store):
		mock_store.free()


func test_register_store() -> void:
	# Arrange

	# Act
	sut.register_store(mock_store)

	# Assert
	assert_eq(sut.get_store("mock_store"), mock_store)


func test_get_non_existent_store() -> void:
	# Arrange

	# Act
	var result = sut.get_store("non_existent")

	# Assert
	assert_null(result)


func test_initialize_emits_signal() -> void:
	# Arrange
	watch_signals(sut)
	sut.register_store(mock_store)

	# Act
	await sut.initialize()

	# Assert
	assert_signal_emitted(sut, "initialized")
	assert_true(sut._initialized)


func test_cleanup_stores() -> void:
	# Arrange
	sut.register_store(mock_store)

	# Act
	sut._cleanup_stores()

	# Assert
	assert_null(sut.get_store("mock_store"))
	assert_eq(sut._stores.size(), 0)
	assert_eq(sut._store_dict.size(), 0)


func test_replace_store() -> void:
	# Arrange
	sut.register_store(mock_store)
	var new_store = Node.new()
	new_store.name = "mock_store"

	# Act
	await sut.replace_store("mock_store", new_store)

	# Assert
	assert_true(sut._initialized)
	assert_true(sut.has_node(NodePath(new_store.name)))


func test_replace_stores_with_doubles() -> void:
	# Arrange
	sut.register_store(mock_store)
	var double_store = Node.new()
	double_store.name = "double_store"
	var doubles = {"double_store": double_store}

	# Act
	await sut.replace_stores_with_doubles(doubles)

	# Assert
	assert_true(sut._initialized)
	assert_true(sut.has_node(NodePath(double_store.name)))
	assert_false(sut.has_node(NodePath(mock_store.name)))
