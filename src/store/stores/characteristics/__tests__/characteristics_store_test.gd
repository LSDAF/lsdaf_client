extends GutTest

const CharacteristicsStoreClass = preload(
	"res://src/store/stores/characteristics/characteristics_store.gd"
)

var sut: CharacteristicsStoreClass


func before_each() -> void:
	sut = CharacteristicsStoreClass.new()


func test_initial_values() -> void:
	# Arrange
	# Already done in before_each

	# Act
	var attack_value: int = sut.attack
	var crit_chance_value: int = sut.crit_chance
	var crit_damage_value: int = sut.crit_damage
	var health_value: int = sut.health
	var resistance_value: int = sut.resistance

	# Assert
	assert_eq(attack_value, 0)
	assert_eq(crit_chance_value, 0)
	assert_eq(crit_damage_value, 0)
	assert_eq(health_value, 0)
	assert_eq(resistance_value, 0)


func test_set_characteristics() -> void:
	# Arrange
	var attack: int = 5
	var crit_chance: int = 3
	var crit_damage: int = 4
	var health: int = 6
	var resistance: int = 2

	# Act
	sut.set_characteristics(attack, crit_chance, crit_damage, health, resistance)

	# Assert
	assert_eq(sut.attack, attack)
	assert_eq(sut.crit_chance, crit_chance)
	assert_eq(sut.crit_damage, crit_damage)
	assert_eq(sut.health, health)
	assert_eq(sut.resistance, resistance)


func test_property_changed_signal() -> void:
	# Arrange
	watch_signals(sut)
	var attack: int = 5
	var crit_chance: int = 3
	var crit_damage: int = 4
	var health: int = 6
	var resistance: int = 2

	# Act
	sut.set_characteristics(attack, crit_chance, crit_damage, health, resistance)

	# Assert
	var signal_emit_count: int = get_signal_emit_count(sut, "property_changed")
	assert_eq(signal_emit_count, 5, "Should emit 5 signals")

	var emitted_properties := {}
	for index: int in range(5):
		var emission_params: Variant = get_signal_parameters(
			sut, "property_changed", signal_emit_count - (1 + index)
		)
		var property: StringName = emission_params[0]
		emitted_properties[property] = true

	assert_true(emitted_properties.has(&"attack"), "Should emit attack property")
	assert_true(emitted_properties.has(&"crit_chance"), "Should emit crit_chance property")
	assert_true(emitted_properties.has(&"crit_damage"), "Should emit crit_damage property")
	assert_true(emitted_properties.has(&"health"), "Should emit health property")
	assert_true(emitted_properties.has(&"resistance"), "Should emit resistance property")


func test_direct_property_update() -> void:
	# Arrange
	watch_signals(sut)
	var attack_value: int = 5
	var crit_chance_value: int = 3
	var crit_damage_value: int = 4
	var health_value: int = 6
	var resistance_value: int = 2

	# Act
	sut.attack = attack_value
	sut.crit_chance = crit_chance_value
	sut.crit_damage = crit_damage_value
	sut.health = health_value
	sut.resistance = resistance_value

	# Assert
	assert_eq(sut.attack, attack_value)
	assert_eq(sut.crit_chance, crit_chance_value)
	assert_eq(sut.crit_damage, crit_damage_value)
	assert_eq(sut.health, health_value)
	assert_eq(sut.resistance, resistance_value)

	var signal_emit_count: int = get_signal_emit_count(sut, "property_changed")
	assert_eq(signal_emit_count, 5, "Should emit 5 signals")

	var emitted_properties := {}
	for index: int in range(5):
		var emission_params: Variant = get_signal_parameters(
			sut, "property_changed", signal_emit_count - (1 + index)
		)
		var property: StringName = emission_params[0]
		emitted_properties[property] = true

	assert_true(emitted_properties.has(&"attack"), "Should emit attack property")
	assert_true(emitted_properties.has(&"crit_chance"), "Should emit crit_chance property")
	assert_true(emitted_properties.has(&"crit_damage"), "Should emit crit_damage property")
	assert_true(emitted_properties.has(&"health"), "Should emit health property")
	assert_true(emitted_properties.has(&"resistance"), "Should emit resistance property")
