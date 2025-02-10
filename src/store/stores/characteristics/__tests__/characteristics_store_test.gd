extends GutTest

const CharacteristicsStoreClass = preload(
	"res://src/store/stores/characteristics/characteristics_store.gd"
)

var sut: CharacteristicsStoreClass


func before_each() -> void:
	sut = CharacteristicsStoreClass.new()

	Stores.reset()
	await (
		Stores
		. replace_stores_with_doubles(
			{
				&"characteristics": sut,
			}
		)
	)


func test_initial_values() -> void:
	# Arrange
	# Already done in before_each

	# Act
	var attack_value := sut.attack
	var crit_chance_value := sut.crit_chance
	var crit_damage_value := sut.crit_damage
	var health_value := sut.health
	var resistance_value := sut.resistance

	# Assert
	assert_eq(attack_value.current_value(), 2)
	assert_eq(crit_chance_value.current_value(), 2)
	assert_eq(crit_damage_value.current_value(), 2)
	assert_eq(health_value.current_value(), 2)
	assert_eq(resistance_value.current_value(), 2)


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
	assert_eq(sut.attack.get_level(), attack)
	assert_eq(sut.crit_chance.get_level(), crit_chance)
	assert_eq(sut.crit_damage.get_level(), crit_damage)
	assert_eq(sut.health.get_level(), health)
	assert_eq(sut.resistance.get_level(), resistance)


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
	sut.attack = Characteristic.new(attack_value)
	sut.crit_chance = Characteristic.new(crit_chance_value)
	sut.crit_damage = Characteristic.new(crit_damage_value)
	sut.health = Characteristic.new(health_value)
	sut.resistance = Characteristic.new(resistance_value)

	# Assert
	assert_eq(sut.attack.get_level(), attack_value)
	assert_eq(sut.crit_chance.get_level(), crit_chance_value)
	assert_eq(sut.crit_damage.get_level(), crit_damage_value)
	assert_eq(sut.health.get_level(), health_value)
	assert_eq(sut.resistance.get_level(), resistance_value)

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
