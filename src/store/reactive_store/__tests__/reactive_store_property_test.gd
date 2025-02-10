extends GutTest

var sut: ReactiveStoreProperty
var store: ReactiveStore


func before_each() -> void:
	store = ReactiveStore.new()
	store._initialize_reactive_store({&"test_property": TYPE_STRING}, {&"test_property": ""})
	sut = ReactiveStoreProperty.new(store, &"test_property")
	add_child_autofree(store)
	add_child_autofree(sut)


func test_get_value_returns_store_property_value() -> void:
	# Arrange
	store.set_property(&"test_property", "test_value")

	# Act
	var value = await sut.get_value()

	# Assert
	assert_eq(value, "test_value")


func test_set_value_updates_store_property() -> void:
	# Arrange

	# Act
	sut.set_value("new_value")
	var value = await store._get_property(&"test_property")

	# Assert
	assert_eq(value, "new_value")
