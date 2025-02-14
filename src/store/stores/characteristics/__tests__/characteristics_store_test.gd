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
	var initial_attack := Characteristic.new(1)
	var initial_crit_chance := Characteristic.new(2)
	var initial_crit_damage := Characteristic.new(3)
	var initial_health := Characteristic.new(4)
	var initial_resistance := Characteristic.new(5)

	sut._initialize_reactive_store(
		{
			&"attack": TYPE_OBJECT,
			&"crit_chance": TYPE_OBJECT,
			&"crit_damage": TYPE_OBJECT,
			&"health": TYPE_OBJECT,
			&"resistance": TYPE_OBJECT
		},
		{
			&"attack": initial_attack,
			&"crit_chance": initial_crit_chance,
			&"crit_damage": initial_crit_damage,
			&"health": initial_health,
			&"resistance": initial_resistance
		}
	)

	# Act
	var attack_value := await sut.attack_property.get_value()
	var crit_chance_value := await sut.crit_chance_property.get_value()
	var crit_damage_value := await sut.crit_damage_property.get_value()
	var health_value := await sut.health_property.get_value()
	var resistance_value := await sut.resistance_property.get_value()

	# Assert
	assert_eq(attack_value.get_level(), 1)
	assert_eq(crit_chance_value.get_level(), 2)
	assert_eq(crit_damage_value.get_level(), 3)
	assert_eq(health_value.get_level(), 4)
	assert_eq(resistance_value.get_level(), 5)


func test_set_characteristics_level() -> void:
	# Arrange
	var attack: int = 5
	var crit_chance: int = 3
	var crit_damage: int = 4
	var health: int = 6
	var resistance: int = 2

	# Act
	sut.set_characteristics_level(attack, crit_chance, crit_damage, health, resistance)

	# Assert
	assert_eq((await sut.attack_property.get_value()).get_level(), attack)
	assert_eq((await sut.crit_chance_property.get_value()).get_level(), crit_chance)
	assert_eq((await sut.crit_damage_property.get_value()).get_level(), crit_damage)
	assert_eq((await sut.health_property.get_value()).get_level(), health)
	assert_eq((await sut.resistance_property.get_value()).get_level(), resistance)


func test_properties_cannot_be_set_directly() -> void:
	# Arrange
	var old_attack = sut.attack_property
	var old_crit_chance = sut.crit_chance_property
	var old_crit_damage = sut.crit_damage_property
	var old_health = sut.health_property
	var old_resistance = sut.resistance_property

	# Act
	sut.attack_property = ReactiveStoreProperty.new(sut, &"attack")
	sut.crit_chance_property = ReactiveStoreProperty.new(sut, &"crit_chance")
	sut.crit_damage_property = ReactiveStoreProperty.new(sut, &"crit_damage")
	sut.health_property = ReactiveStoreProperty.new(sut, &"health")
	sut.resistance_property = ReactiveStoreProperty.new(sut, &"resistance")

	# Assert
	assert_eq(sut.attack_property, old_attack, "Attack property should not change")
	assert_eq(sut.crit_chance_property, old_crit_chance, "Crit chance property should not change")
	assert_eq(sut.crit_damage_property, old_crit_damage, "Crit damage property should not change")
	assert_eq(sut.health_property, old_health, "Health property should not change")
	assert_eq(sut.resistance_property, old_resistance, "Resistance property should not change")


func test_property_changed_signal() -> void:
	# Arrange
	watch_signals(sut)
	var attack: int = 5
	var crit_chance: int = 3
	var crit_damage: int = 4
	var health: int = 6
	var resistance: int = 2

	# Act
	sut.set_characteristics_level(attack, crit_chance, crit_damage, health, resistance)

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


func test_set_attack_level() -> void:
	# Arrange
	var attack: int = 5

	# Act
	sut.set_attack_level(attack)

	# Assert
	assert_eq((await sut.attack_property.get_value()).get_level(), attack)


func test_set_crit_chance_level() -> void:
	# Arrange
	var crit_chance: int = 3

	# Act
	sut.set_crit_chance_level(crit_chance)

	# Assert
	assert_eq((await sut.crit_chance_property.get_value()).get_level(), crit_chance)


func test_set_crit_damage_level() -> void:
	# Arrange
	var crit_damage: int = 4

	# Act
	sut.set_crit_damage_level(crit_damage)

	# Assert
	assert_eq((await sut.crit_damage_property.get_value()).get_level(), crit_damage)


func test_set_health_level() -> void:
	# Arrange
	var health: int = 6

	# Act
	sut.set_health_level(health)

	# Assert
	assert_eq((await sut.health_property.get_value()).get_level(), health)


func test_set_resistance_level() -> void:
	# Arrange
	var resistance: int = 2

	# Act
	sut.set_resistance_level(resistance)

	# Assert
	assert_eq((await sut.resistance_property.get_value()).get_level(), resistance)


func test_direct_property_update() -> void:
	# Arrange
	watch_signals(sut)
	var attack_value: int = 5
	var crit_chance_value: int = 3
	var crit_damage_value: int = 4
	var health_value: int = 6
	var resistance_value: int = 2

	# Act
	await sut.attack_property.set_value(Characteristic.new(attack_value))
	await sut.crit_chance_property.set_value(Characteristic.new(crit_chance_value))
	await sut.crit_damage_property.set_value(Characteristic.new(crit_damage_value))
	await sut.health_property.set_value(Characteristic.new(health_value))
	await sut.resistance_property.set_value(Characteristic.new(resistance_value))

	# Assert
	assert_eq((await sut.attack_property.get_value()).get_level(), attack_value)
	assert_eq((await sut.crit_chance_property.get_value()).get_level(), crit_chance_value)
	assert_eq((await sut.crit_damage_property.get_value()).get_level(), crit_damage_value)
	assert_eq((await sut.health_property.get_value()).get_level(), health_value)
	assert_eq((await sut.resistance_property.get_value()).get_level(), resistance_value)

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
