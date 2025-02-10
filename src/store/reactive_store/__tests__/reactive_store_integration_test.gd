extends GutTest


class TestState:
	extends BaseState

	static func get_property_types() -> Dictionary:
		return {
			&"health": TYPE_INT,
			&"mana": TYPE_INT,
			&"is_alive": TYPE_BOOL,
			&"can_cast_spell": TYPE_BOOL,
		}

	static func get_initial_state() -> Dictionary:
		return {
			&"health": 100,
			&"mana": 50,
			&"is_alive": true,
			&"can_cast_spell": true,
		}


class TestStore:
	extends ReactiveStore

	func _ready() -> void:
		_initialize()

	func _initialize() -> void:
		_define_properties(TestState.get_property_types(), TestState.get_initial_state())

		# Update can_cast_spell whenever mana or is_alive changes
		var update_can_cast = func():
			var mana = _state[&"mana"]
			var is_alive = _state[&"is_alive"]
			set_property(&"can_cast_spell", mana >= 10 and is_alive)

		# Connect to property changes
		property_changed.connect(
			func(property: StringName):
				if property == &"mana" or property == &"is_alive":
					update_can_cast.call()
		)

		# Call update_can_cast initially to set the initial state
		update_can_cast.call()


var sut: StoreManager
var player_store: TestStore
var enemy_store: TestStore


# Test helpers
func _create_store(name: String) -> TestStore:
	var store := TestStore.new()
	store.name = name
	return store


func before_each() -> void:
	sut = StoreManager.new()
	player_store = _create_store("player")
	enemy_store = _create_store("enemy")
	autofree(player_store)
	autofree(enemy_store)
	sut.register_store(player_store)
	sut.register_store(enemy_store)
	add_child_autofree(sut)
	await sut.initialize()


func test_store_initializes_with_correct_state() -> void:
	# Arrange
	# Initial setup done in before_each

	# Act
	var health_prop = ReactiveStoreProperty.new(player_store, &"health")
	var mana_prop = ReactiveStoreProperty.new(player_store, &"mana")
	var can_cast_prop = ReactiveStoreProperty.new(player_store, &"can_cast_spell")
	autofree(health_prop)
	autofree(mana_prop)
	autofree(can_cast_prop)

	var player_health = await health_prop.get_value()
	var player_mana = await mana_prop.get_value()
	var can_cast = await can_cast_prop.get_value()

	# Assert
	assert_eq(player_health, 100, "Player should start with 100 health")
	assert_eq(player_mana, 50, "Player should start with 50 mana")
	assert_true(can_cast, "Player should be able to cast with 50 mana")


func test_computed_property_updates_on_mana_change() -> void:
	# Arrange
	# Initial setup done in before_each

	# Act
	player_store.set_property(&"mana", 5)

	# Assert
	var can_cast_prop = ReactiveStoreProperty.new(player_store, &"can_cast_spell")
	autofree(can_cast_prop)
	var can_cast = await can_cast_prop.get_value()
	assert_false(can_cast, "Player shouldn't be able to cast with 5 mana")


func test_computed_property_updates_on_multiple_dependencies() -> void:
	# Arrange
	# Initial setup done in before_each

	# Act
	player_store.set_properties({&"health": 0, &"is_alive": false})

	# Assert
	var can_cast_prop = ReactiveStoreProperty.new(player_store, &"can_cast_spell")
	autofree(can_cast_prop)
	var can_cast = await can_cast_prop.get_value()
	assert_false(can_cast, "Dead player shouldn't be able to cast spells")


func test_store_replacement_preserves_initial_state() -> void:
	# Arrange
	var new_player_store := _create_store("player")
	autofree(new_player_store)

	# Act
	sut._cleanup_stores()
	sut.register_store(new_player_store)
	await sut.initialize()

	# Assert
	var health_prop = ReactiveStoreProperty.new(new_player_store, &"health")
	autofree(health_prop)
	var player_health = await health_prop.get_value()
	assert_eq(player_health, 100, "New player store should have initial health")
