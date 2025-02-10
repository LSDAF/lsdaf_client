extends GutTest

const CurrenciesStoreClass = preload("res://src/store/stores/currencies/currencies_store.gd")

var sut: CurrenciesStoreClass


func before_each() -> void:
	sut = CurrenciesStoreClass.new()
	await Stores.replace_stores_with_doubles({&"currencies": sut})


func test_initial_values() -> void:
	# Arrange
	# Already done in before_each

	# Act
	var gold_value: int = await sut.gold_property.get_value()
	var diamond_value: int = await sut.diamond_property.get_value()
	var emerald_value: int = await sut.emerald_property.get_value()
	var amethyst_value: int = await sut.amethyst_property.get_value()

	# Assert
	assert_eq(gold_value, 0)
	assert_eq(diamond_value, 0)
	assert_eq(emerald_value, 0)
	assert_eq(amethyst_value, 0)


func test_set_currencies() -> void:
	# Arrange
	var gold: int = 100
	var diamond: int = 50
	var emerald: int = 25
	var amethyst: int = 10

	# Act
	sut.set_currencies(gold, diamond, emerald, amethyst)

	# Assert
	assert_eq(await sut.gold_property.get_value(), gold)
	assert_eq(await sut.diamond_property.get_value(), diamond)
	assert_eq(await sut.emerald_property.get_value(), emerald)
	assert_eq(await sut.amethyst_property.get_value(), amethyst)


func test_property_changed_signal() -> void:
	# Arrange
	watch_signals(sut)
	var gold: int = 100
	var diamond: int = 50
	var emerald: int = 25
	var amethyst: int = 10

	# Act
	sut.set_currencies(gold, diamond, emerald, amethyst)

	# Assert
	var signal_emit_count: int = get_signal_emit_count(sut, "property_changed")
	assert_eq(signal_emit_count, 4, "Should emit 4 signals")

	var emitted_properties := {}
	for index: int in range(4):
		var emission_params: Variant = get_signal_parameters(
			sut, "property_changed", signal_emit_count - (1 + index)
		)
		var property: StringName = emission_params[0]
		emitted_properties[property] = true

	assert_true(emitted_properties.has(&"gold"), "Should emit gold property")
	assert_true(emitted_properties.has(&"diamond"), "Should emit diamond property")
	assert_true(emitted_properties.has(&"emerald"), "Should emit emerald property")
	assert_true(emitted_properties.has(&"amethyst"), "Should emit amethyst property")


func test_set_gold() -> void:
	# Arrange
	var gold: int = 100

	# Act
	sut.set_gold(gold)

	# Assert
	assert_eq(await sut.gold_property.get_value(), gold)


func test_set_diamond() -> void:
	# Arrange
	var diamond: int = 50

	# Act
	sut.set_diamond(diamond)

	# Assert
	assert_eq(await sut.diamond_property.get_value(), diamond)


func test_set_emerald() -> void:
	# Arrange
	var emerald: int = 25

	# Act
	sut.set_emerald(emerald)

	# Assert
	assert_eq(await sut.emerald_property.get_value(), emerald)


func test_set_amethyst() -> void:
	# Arrange
	var amethyst: int = 10

	# Act
	sut.set_amethyst(amethyst)

	# Assert
	assert_eq(await sut.amethyst_property.get_value(), amethyst)


func test_direct_property_update() -> void:
	# Arrange
	watch_signals(sut)
	var gold_value: int = 100
	var diamond_value: int = 50
	var emerald_value: int = 25
	var amethyst_value: int = 10

	# Act
	await sut.gold_property.set_value(gold_value)
	await sut.diamond_property.set_value(diamond_value)
	await sut.emerald_property.set_value(emerald_value)
	await sut.amethyst_property.set_value(amethyst_value)

	# Assert
	assert_eq(await sut.gold_property.get_value(), gold_value)
	assert_eq(await sut.diamond_property.get_value(), diamond_value)
	assert_eq(await sut.emerald_property.get_value(), emerald_value)
	assert_eq(await sut.amethyst_property.get_value(), amethyst_value)

	var signal_emit_count: int = get_signal_emit_count(sut, "property_changed")
	assert_eq(signal_emit_count, 4, "Should emit 4 signals")

	var emitted_properties := {}
	for index: int in range(4):
		var emission_params: Variant = get_signal_parameters(
			sut, "property_changed", signal_emit_count - (1 + index)
		)
		var property: StringName = emission_params[0]
		emitted_properties[property] = true

	assert_true(emitted_properties.has(&"gold"), "Should emit gold property")
	assert_true(emitted_properties.has(&"diamond"), "Should emit diamond property")
	assert_true(emitted_properties.has(&"emerald"), "Should emit emerald property")
	assert_true(emitted_properties.has(&"amethyst"), "Should emit amethyst property")
