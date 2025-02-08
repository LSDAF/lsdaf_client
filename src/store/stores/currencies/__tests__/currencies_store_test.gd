extends GutTest

const CurrenciesStoreClass = preload("res://src/store/stores/currencies/currencies_store.gd")

var sut: CurrenciesStoreClass


func before_each() -> void:
	sut = CurrenciesStoreClass.new()


func test_initial_values() -> void:
	# Arrange
	# Already done in before_each

	# Act
	var gold_value: int = sut.gold
	var diamond_value: int = sut.diamond
	var emerald_value: int = sut.emerald
	var amethyst_value: int = sut.amethyst

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
	assert_eq(sut.gold, gold)
	assert_eq(sut.diamond, diamond)
	assert_eq(sut.emerald, emerald)
	assert_eq(sut.amethyst, amethyst)


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


func test_direct_property_update() -> void:
	# Arrange
	watch_signals(sut)
	var gold_value: int = 100
	var diamond_value: int = 50
	var emerald_value: int = 25
	var amethyst_value: int = 10

	# Act
	sut.gold = gold_value
	sut.diamond = diamond_value
	sut.emerald = emerald_value
	sut.amethyst = amethyst_value

	# Assert
	assert_eq(sut.gold, gold_value)
	assert_eq(sut.diamond, diamond_value)
	assert_eq(sut.emerald, emerald_value)
	assert_eq(sut.amethyst, amethyst_value)

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
